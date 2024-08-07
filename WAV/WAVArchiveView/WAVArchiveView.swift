//
//  WAVArchiveView.swift
//

import Combine
import SwiftUI
import OSLog


//struct WAVArchiveView: View {
//    var body: some View {
//        NavigationStack {
//            InfiniteView(topPadding: Constants.marqueeHeight + 20)
//        }
//    }
//}
//
//struct Archive_Previews: PreviewProvider {
//    static var previews: some View {
//        WAVArchiveView()
//            .environmentObject(DataController())
//    }
//}


struct WAVArchiveView: View {
    @EnvironmentObject var dataController: DataController
    @State private var wavShows = WAVShows() // Starts off empty
    @State private var loading = false
    @State private var canLoadMore = true
    @State private var page = 0
    @State private var subscriptions = Set<AnyCancellable>()
    @State private var retriedOnce = false // Track if retry has been attempted
    
    var tag: WAVTag?
    var category: WAVCategory?
    var searchQuery: String?
    
    var topPadding = Constants.marqueeHeight + 20
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
        NavigationStack {
            ZStack {
                if wavShows.isEmpty && loading {
                    PlaceholderView(message: "LOADING VARIOUS")
                } else if wavShows.isEmpty {
                    PlaceholderView(message: retriedOnce ? "NOTHING VARIOUS" : "JUST A SEC...")
                        .onAppear {
                            if !retriedOnce {
                                retriedOnce = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                    loadInitialData()
                                }
                            }
                        }
                } else {
                    wavShowsScrollView
                }
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
        
        Logger.check.info("WAV: Loading \(urlString)")
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
                    Logger.check.error("WAV: Error loading \(urlString): \(error.localizedDescription)")
                    self.canLoadMore = false
                case .finished:
                    Logger.check.info("WAV: Finished loading \(urlString)")
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
        WAVArchiveView()
    }
    .environmentObject(DataController())
}
