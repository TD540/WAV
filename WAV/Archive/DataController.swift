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
        MixcloudAPI.load(page: state.page)
            .sink(receiveCompletion: onReceive,
                  receiveValue: onReceive)
            .store(in: &subscriptions)
    }
    func play(_ wavCast: MixcloudCast) {
        // print("playing: \(wavCast.webPlayerURL.description)")
        state.playing = wavCast
    }
    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure:
            state.canLoadNextPage = false
        }
    }

    private func onReceive(_ batch: [MixcloudCast]) {
        state.wavCasts += batch
        state.page += 1
        state.canLoadNextPage = batch.count == MixcloudAPI.limit
    }

    struct State {
        var playing: MixcloudCast? // needs to go to infinitelist
        var wavCasts: [MixcloudCast] = []
        var page = 0
        var canLoadNextPage = true
    }

    init(disableAPI: Bool = false, previewPlaying: Bool = false) {
        let previewCast = MixcloudCast(
            name: "Dreamgaze w/ Xain09 at We Are Various | 08-05-21",
            slug: "dreamgaze-w-xain09-at-we-are-various-08-05-21",
            pictures: ["": ""]
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

enum MixcloudAPI {
    static let limit = 10
    static let account = "WeAreVarious" // WeAreVarious
    static func load(page: Int) -> AnyPublisher<[MixcloudCast], Error> {
        let url = URL(
            string: "https://api.mixcloud.com/\(self.account)/cloudcasts/?limit=\(limit)&offset=\(page*limit)"
        )!
        // print("API Request: \(url.description)")
        return URLSession.shared
            .dataTaskPublisher(for: url)
//             .handleEvents(
//                receiveOutput: {
//                    print(NSString(data: $0.data, encoding: String.Encoding.utf8.rawValue)!)
//                }
//             )
            .tryMap { try JSONDecoder().decode(MixcloudCasts<MixcloudCast>.self, from: $0.data).data }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct MixcloudCasts<T: Codable>: Codable {
    let data: [T]
}

struct MixcloudCast: Codable, Identifiable, Equatable {
    var id: String { slug }
    let name: String
    let slug: String
    static var autoplay = true
    var webPlayerURL: URL {
        URL(
            string: "https://www.mixcloud.com/widget/iframe/?hide_cover=1&mini=1&hide_artwork=1" +
                    "&autoplay=\(MixcloudCast.autoplay ? "1" : "0")" +
                    "&feed=/\(MixcloudAPI.account)/" +
                    "\(slug.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)/"
        )!
    }
    let pictures: [String: String]?
    var pictureURL: URL? {
        if let pictures = pictures {
            if let pictureString = pictures["extra_large"] {
                return URL(string: pictureString)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
