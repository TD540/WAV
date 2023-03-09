//
//  DataController.swift
//  WeAreVarious
//
//  Created by Thomas on 17/04/2021.
//

import Combine
import Foundation
import MediaPlayer

class DataController: ObservableObject {

    // ARCHIVE STUFF
    struct State {
        var wavShowIsPlaying =  false
        var playPause = false // the value of doesn't matter, only the toggle
        var selectedShow: WAVShow?
        var wavShows: WAVShows = []
        var page = 0
        var canLoadNextPage = true
    }
    @Published var state = State()

    var subscriptions = Set<AnyCancellable>()
    func loadNextPageIfPossible() {
        guard state.canLoadNextPage else { return }
        // print("WAV: loadWAVShows(page: \(state.page))")
        loadWAVShows(page: state.page)
            .sink(receiveCompletion: onReceive, receiveValue: onReceive)
            .store(in: &subscriptions)
    }
    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure:
            state.canLoadNextPage = false
        }
    }
    
    let loadLimit = 10
    private func onReceive(_ wavShows: WAVShows) {
        // if mixcloudURL is empty, don't add show to wavShows
        state.wavShows += wavShows.filter { !$0.mixcloudURL.isEmpty }
        state.page += 1
        state.canLoadNextPage = wavShows.count == loadLimit
    }

    func loadWAVShows(page: Int) -> AnyPublisher<WAVShows, Error> {
        let offset = page * loadLimit
        let url = URL(
            string: "https://wearevarious.com/wp-json/wp/v2/posts?_embed=wp:featuredmedia&per_page=\(loadLimit)&offset=\(offset)"
        )!
        // print("WAV: load restapi \(url.description)")
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { data, response in
                do {
                    return try JSONDecoder().decode(WAVShows.self, from: data)
                } catch let error {
                    print("WAV: JSONDecoder error \(error)")
                    throw error
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    // RADIO STUFF
    let azuracastAPI = URL(string: "https://azuracast.wearevarious.com/api/nowplaying/1")!
    let livestreamAPI = URL(string: "https://radio.wearevarious.com/stream.xml")!
    let livestream = AVPlayerItem(url: URL(string: "https://azuracast.wearevarious.com/listen/we_are_various/live.mp3")!)
    let radioPlayer = AVPlayer()
    var radioTask: Task<Void, Error>?

    @Published var radioIsPlaying = false
    @Published var radioIsLive = false
    @Published var radioIsOffAir = true
    @Published var radioTitle: String = "Loading ..."
    @Published var radioArtURL: URL?

    func updateRadio() {
        radioTask = Task(priority: .medium) {
            do {
                let (jsonData, _) = try await URLSession.shared.data(from: azuracastAPI)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let newData = try jsonDecoder.decode(AzuracastData.self, from: jsonData)
                    DispatchQueue.main.async {
                        self.radioIsOffAir = newData.isOffAir
                        self.radioIsLive = newData.isLive
                    }
                    if radioTitle != newData.title {
                        if newData.isLive {
                            updateLiveTitle()
                        } else {
                            updateRadioTitle(with: newData.title)
                        }
                    }
                    if radioArtURL != URL(string: newData.artURL) {
                        if newData.artURL.hasSuffix("generic_song.jpg") {
                            // generic artwork image looks aweful,
                            // update with nil
                            updateRadioArtURL(with: nil)
                        } else {
                            // artwork image available
                            updateRadioArtURL(with: newData.artURL)
                        }
                        // updateArtURL(with: newData.artURL) // dev
                    }
                } catch {
                    updateRadioTitle(with: "We Are Various")
                    updateRadioArtURL(with: nil)
                }
            } catch {
                updateRadioTitle(with: "We Are Various")
                updateRadioArtURL(with: nil)
            }
            
            try await Task.sleep(nanoseconds: 60_000_000_000)
            guard !Task.isCancelled else { return }
            updateRadio()
        }
    }
    func updateRadioArtURL(with newArt: String?) {
        DispatchQueue.main.async {
            if let newArt {
                self.radioArtURL = URL(string: newArt)
            } else {
                self.radioArtURL = nil
            }
        }
    }
    func updateRadioTitle(with newTitle: String) {
        DispatchQueue.main.async {
            self.radioTitle = newTitle
        }
    }

    /// updateLiveTitle() parses stream.xml and updates title
    func updateLiveTitle() {
        Task(priority: .medium) {
            do {
                let (data, _) = try await URLSession.shared.data(from: livestreamAPI)
                let dom = MicroDOM(data: data)
                let tree = dom.parse()
                // print(tree?.tag ?? "") // todo: check later if this is still "live" when wearevarious.com radio is not live
                if let tags = tree?.getElementsByTagName("title") {
                    let newTitle = tags[0].data
                    if radioTitle != newTitle {
                        updateRadioTitle(with: newTitle)
                    }
                }
            } catch {
                print("WAV: URLSession", String(describing: error))
            }
        }
    }

    func updateInfoCenter() {
        let artwork: MPMediaItemArtwork
        if
            let url = radioArtURL,
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {
            artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in
                image
            }
        } else {
            let image = UIImage(named: "AppIcon")!
            artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in
                    image
                }
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyArtwork: artwork,
            MPMediaItemPropertyTitle: radioTitle,
            MPMediaItemPropertyArtist: "We Are Various",
            MPMediaItemPropertyPlaybackDuration: 0,
            MPNowPlayingInfoPropertyIsLiveStream: true
        ]
    }
    func playRadio() {
        print("WAV: Play radio")
        radioPlayer.replaceCurrentItem(with: nil)
        radioPlayer.replaceCurrentItem(with: livestream)
        radioPlayer.play()
        radioIsPlaying = true
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            updateInfoCenter()
            let commandCenter = MPRemoteCommandCenter.shared()
            commandCenter.playCommand.isEnabled = true
            commandCenter.stopCommand.isEnabled = true
            commandCenter.playCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
                self?.radioPlayer.play()
                self?.radioIsPlaying = true
                return .success
            }
            commandCenter.stopCommand.addTarget  { [weak self] (event) -> MPRemoteCommandHandlerStatus in
                self?.stopRadio()
                return .success
            }
        } catch {
            // print(error.localizedDescription)
        }
    }
    func stopRadio() {
        print("WAV: Stop radio")
        radioPlayer.pause()
        radioIsPlaying = false
        radioTask?.cancel()
    }

}

struct AzuracastData: Decodable {
    let nowPlaying: NowPlaying
    struct NowPlaying: Decodable {
        let song: Song
        struct Song: Decodable {
            let text: String
            let art: String
        }
    }
    var title: String {
        nowPlaying.song.text
    }
    /// `art` contains a URL string to a relevant image
    var artURL: String {
        nowPlaying.song.art.replacingOccurrences(of: "http:", with: "https:")
    }
    var isLive: Bool {
        title.lowercased().contains("live broadcast")
    }
    var isOffAir: Bool {
        title.lowercased().contains("currently off air")
    }
}
