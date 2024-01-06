//
//  InfiniteView.swift
//  Shared
//
//  Created by Thomas Decrick on 17/01/2021.
//

import Combine
import SwiftUI
import OSLog

struct InfiniteView: View {
    @EnvironmentObject var dataController: DataController
    @State private var wavShows = WAVShows() // Starts off empty
    @State private var loading = false
    @State private var canLoadMore = true
    @State private var page = 0
    @State private var subscriptions = Set<AnyCancellable>()

    var tag: WAVTag?
    var category: WAVCategory?
    var searchQuery: String?

    var topPadding = 0.0
    var bottomPadding = 0.0

    private let loadLimit = 10

    private var requestParameters: String {
        [
            tag.map { "tags=\($0.id)" },
            category.map { "categories=\($0.id)" },
            searchQuery.map { "search=\($0)" }
        ]
        .compactMap { $0 }
        .joined(separator: "&")
        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }

    var body: some View {
        ZStack {
            if wavShows.isEmpty && loading {
                LoadingView()
            } else if wavShows.isEmpty {
                PlaceholderView()
            } else {
                wavShowsScrollView
            }
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadInitialData)
    }

    private var wavShowsScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 50) {
                ForEach(wavShows) { wavShow in
                    WAVShowView(wavShow: wavShow, category: category, tag: tag)
                        .onAppear {
                            if wavShow == wavShows.last {
                                loadNextPageIfPossible()
                            }
                        }
                }
            }
            .padding(.top, topPadding)
            .padding(.bottom, bottomPadding)
        }
    }

    private var navigationTitle: String {
        category?.name.stringByDecodingHTMLEntities.uppercased() ??
        tag?.name.stringByDecodingHTMLEntities.uppercased() ?? ""
    }

    private func loadInitialData() {
        guard canLoadMore else { return }
        loadWAVShows()
    }

    private func loadWAVShows() {
        guard canLoadMore else { return }
        loading = true

        let urlString = "https://wearevarious.com/wp-json/wp/v2/posts?_embed=wp:featuredmedia&per_page=\(loadLimit)&offset=\(page * loadLimit)&\(requestParameters)"

        Logger.check.info("Loading \(urlString)")
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WAVShows.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        print("Error: \(error)")
                        self.canLoadMore = false
                    case .finished:
                        print("urlString finished loading: \(urlString)")
                        break
                }
                self.loading = false
            }, receiveValue: { newWavShows in
                self.wavShows.append(contentsOf: newWavShows.filter { !$0.mixcloudURL.isEmpty })
                self.page += 1
                self.canLoadMore = newWavShows.count == self.loadLimit
            })
            .store(in: &subscriptions)
    }

    private func loadNextPageIfPossible() {
        loadWAVShows()
    }
}

#Preview {
    NavigationStack {
        InfiniteView()
    }
    .environmentObject(DataController())
}
