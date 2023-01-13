//
//  DataController.swift
//  WeAreVarious
//
//  Created by Thomas on 17/04/2021.
//

import Foundation
import Combine

class ArchiveDataController: ObservableObject {
    struct State {
        var isPlaying =  false
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
        WAVWordPress.load(page: state.page)
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
    private func onReceive(_ wavShows: WAVShows) {
        // if mixcloudURL is empty, don't add show to wavShows
        state.wavShows += wavShows.filter { !$0.mixcloudURL.isEmpty }
        state.page += 1
        state.canLoadNextPage = wavShows.count == WAVWordPress.limit
    }
    static var preview: ArchiveDataController = {
        let previewArchiveDataController = ArchiveDataController()
        previewArchiveDataController.state.wavShows += [WAVShow.preview]
        previewArchiveDataController.state.selectedShow = WAVShow.preview
        return previewArchiveDataController
    }()
}

enum WAVWordPress {
    static let limit = 10
    static func load(page: Int) -> AnyPublisher<WAVShows, Error> {
        let url = URL(
            string: "https://wearevarious.com/wp-json/wp/v2/posts?_embed=wp:featuredmedia&per_page=\(limit)&offset=\(page*limit)"
        )!
        // print("WAV: load restapi \(url.description)")
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { try JSONDecoder().decode(WAVShows.self, from: $0.data) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

