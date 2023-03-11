//
//  InfiniteView.swift
//  Shared
//
//  Created by Thomas Decrick on 17/01/2021.
//

import Combine
import SwiftUI

struct InfiniteView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.colorScheme) var colorScheme
    @State var wavShows = WAVShows()
    @State var canLoadNextPage = true
    @State var page = 0
    @State var subscriptions = Set<AnyCancellable>()
    
    let loadLimit = 10
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(wavShows) { wavShow in
                    ArchiveItemView(wavShow: wavShow)
                        .onAppear {
                            wavShows.last == wavShow ?
                            loadNextPageIfPossible() :
                            nil
                        }
                }
            }
            .padding()
        }
        .background(colorScheme == .light ? .black.opacity(0.1) : .white.opacity(0.1))
        .onAppear {
            guard canLoadNextPage else { return }
            // print("WAV: loadWAVShows(page: \(state.page))")
            loadWAVShows()
                .sink(receiveCompletion: onReceive, receiveValue: onReceive)
                .store(in: &subscriptions)
        }
    }

    func loadWAVShows() -> AnyPublisher<WAVShows, Error> {
        let offset = page * loadLimit
        let url = URL(
            string: "https://wearevarious.com/wp-json/wp/v2/posts?_embed=wp:featuredmedia&per_page=\(loadLimit)&offset=\(offset)"
        )!
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

    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure:
            canLoadNextPage = false
        }
    }

    private func onReceive(_ wavShows: WAVShows) {
        // if mixcloudURL is empty, don't add show to wavShows
        self.wavShows += wavShows.filter { !$0.mixcloudURL.isEmpty }
        page += 1
        canLoadNextPage = wavShows.count == loadLimit
    }

    func loadNextPageIfPossible() {
        guard canLoadNextPage else { return }
        // print("WAV: loadWAVShows(page: \(state.page))")
        loadWAVShows()
            .sink(receiveCompletion: onReceive, receiveValue: onReceive)
            .store(in: &subscriptions)
    }
}

struct InfiniteView_Previews: PreviewProvider {
    static var previews: some View {
        InfiniteView()
            .environmentObject(DataController())
    }
}
