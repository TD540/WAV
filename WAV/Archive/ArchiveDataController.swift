//
//  DataController.swift
//  WeAreVarious
//
//  Created by Thomas on 17/04/2021.
//

import Foundation
import Combine

class ArchiveDataController: ObservableObject {
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
    private func onReceive(_ batch: [WAVShow]) {
        state.wavShows += batch
        state.page += 1
        state.canLoadNextPage = batch.count == WAVWordPress.limit
    }
    struct State {
        var isPlaying =  false
        var playPause = false // the value of doesn't matter, only the toggle
        var selectedShow: WAVShow?
        var wavShows: [WAVShow] = []
        var page = 0
        var canLoadNextPage = true
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
    static func load(page: Int) -> AnyPublisher<[WAVShow], Error> {
        let url = URL(
            string: "https://wearevarious.com/wp-json/wp/v2/posts?_embed=wp:featuredmedia&per_page=\(limit)&offset=\(page*limit)"
        )!
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { try JSONDecoder().decode([WAVShow].self, from: $0.data) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

