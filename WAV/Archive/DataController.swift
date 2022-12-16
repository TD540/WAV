//
//  DataController.swift
//  WeAreVarious
//
//  Created by Thomas on 17/04/2021.
//

import Foundation
import Combine

class DataController: ObservableObject {
    // let container: NSPersistentCloudKitContainer
    // Todo: Save played before states in iCloud
    @Published private(set) var state = State()
    private var subscriptions = Set<AnyCancellable>()
    func loadNextPageIfPossible() {
        guard state.canLoadNextPage else { return }
        WAVWordPress.load(page: state.page)
            .sink(receiveCompletion: onReceive, receiveValue: onReceive)
            .store(in: &subscriptions)
    }
    func play(_ wavCast: WAVPost) {
        // print("playing: \(wavCast.webPlayerURL.description)")
        state.playing = wavCast
    }
    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            print("TD: FINISHED")
            break
        case .failure:
            print("TD: ERROR \(completion)")
            state.canLoadNextPage = false
        }
    }
    private func onReceive(_ batch: [WAVPost]) {
        state.wavCasts += batch
        state.page += 1
        state.canLoadNextPage = batch.count == WAVWordPress.limit
    }
    struct State {
        var playing: WAVPost? // needs to go to infinitelist
        var wavCasts: [WAVPost] = []
        var page = 0
        var canLoadNextPage = true
    }
    init(disableAPI: Bool = false, previewPlaying: Bool = false) {
        let previewCast = WAVPost(
            id: 99999999999999,
            date: "2022-12-01T20:14:58",
            title: WAVPost.Title(rendered: "PREVIEW TITLE"),
            mixcloudURL: "https://www.mixcloud.com/MonkeyShoulder/dj-jazzy-jeff-monkey-shoulder-mix/",
            embedded:
                WAVPost.Embedded(
                    wpFeaturedmedia:
                        [WAVPost.WpFeaturedmedia(
                            sourceURL: "https://dev.wearevarious.com/wp-content/uploads/2022/12/b0c5-764e-4089-b8ca-07ee4a48f6cf.jpg")
                        ]
                )
        )
        if disableAPI {
            state = State(
                playing: previewPlaying ? previewCast : nil,
                wavCasts: Array(repeating: previewCast, count: 100),
                page: 1, canLoadNextPage: false
            )
        }
        if previewPlaying {
            state = State(
                playing: previewPlaying ? previewCast : nil,
                wavCasts: [],
                page: 1, canLoadNextPage: true
            )
        }
    }
    static var preview: DataController = {
        DataController(previewPlaying: true)
    }()
}

enum WAVWordPress {
    static let limit = 10
    static func load(page: Int) -> AnyPublisher<[WAVPost], Error> {
        let url = URL(
            string: "https://dev.wearevarious.com/wp-json/wp/v2/posts?_fields=id,date,title,_links,mixcloud_url&_embed=wp:featuredmedia&per_page=\(limit)&offset=\(page*limit)"
        )!
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { try JSONDecoder().decode([WAVPost].self, from: $0.data) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - WAVPost
struct WAVPost: Codable, Identifiable, Equatable {
    static func == (lhs: WAVPost, rhs: WAVPost) -> Bool {
        lhs.id == rhs.id
    }

    let id: Int
    let date: String
    let title: Title
    let mixcloudURL: String
    let embedded: Embedded

    enum CodingKeys: String, CodingKey {
        case id, date, title
        case mixcloudURL = "mixcloud_url"
        case embedded = "_embedded"
    }

    static var autoplay = true
    var name: String {
        title.rendered
    }
    var mixcloudEmbed: URL {
        URL(string: mixcloudURL)!
    }
    var pictureURL: URL {
        URL(string: embedded.wpFeaturedmedia.first!.sourceURL)!
    }

    struct Embedded: Codable {
        let wpFeaturedmedia: [WpFeaturedmedia]
        enum CodingKeys: String, CodingKey {
            case wpFeaturedmedia = "wp:featuredmedia"
        }
    }
    struct WpFeaturedmedia: Codable {
        let sourceURL: String
        enum CodingKeys: String, CodingKey {
            case sourceURL = "source_url"
        }
    }
    struct Title: Codable {
        let rendered: String
    }

}

typealias WAVPosts = [WAVPost]

