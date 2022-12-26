//
//  DataController.swift
//  WeAreVarious
//
//  Created by Thomas on 17/04/2021.
//

import Foundation
import Combine

class ArchiveDataController: ObservableObject {
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
    func play(_ wavPost: WAVPost) {
        state.playing = wavPost
    }
    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            // print("WAV: onReceive \(completion)")
            break
        case .failure:
            // print("WAV: ERROR \(completion)")
            state.canLoadNextPage = false
        }
    }
    private func onReceive(_ batch: [WAVPost]) {
        state.wavPosts += batch
        state.page += 1
        state.canLoadNextPage = batch.count == WAVWordPress.limit
    }
    struct State {
        var playing: WAVPost? // needs to go to infinitelist
        var wavPosts: [WAVPost] = []
        var page = 0
        var canLoadNextPage = true
    }
    static var preview: ArchiveDataController = {
        ArchiveDataController()
    }()
}

enum WAVWordPress {
    static let limit = 10
    static func load(page: Int) -> AnyPublisher<[WAVPost], Error> {
        let url = URL(
            string: "https://dev.wearevarious.com/wp-json/wp/v2/posts?_fields=id,date,title,_links,mixcloud_url&_embed=wp:featuredmedia&per_page=\(limit)&offset=\(page*limit)"
        )!
        print("WAV: Loading \(url)")
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
    var mixcloudWidget: URL {
        let range = mixcloudURL.range(of: "mixcloud.com")!
        let slug = String(mixcloudURL[range.upperBound...])
        let widgetURL = "https://www.mixcloud.com/widget/iframe/?hide_cover=1&mini=1&hide_artwork=1" +
        "&autoplay=\(WAVPost.autoplay ? "1" : "0")" +
        "&feed=" +
        "\(slug.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)"
        return URL(string: widgetURL)!
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

