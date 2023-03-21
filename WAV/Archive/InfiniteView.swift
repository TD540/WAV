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

    var tag: WAVTag?
    var tagParameter: String {
        if let tag {
            return "&tags=" + String(tag.id)
        } else {
            return ""
        }
    }

    var category: WAVCategory?
    var categoryParameter: String {
        if let category {
            return "&categories=" + String(category.id)
        } else {
            return ""
        }
    }

    var searchQuery: String?
    var searchQueryParameter: String {
        if let searchQuery {
            return "&search=" + searchQuery
        } else {
            return ""
        }
    }


    let loadLimit = 10

    var body: some View {
        Group {
            if wavShows.isEmpty && !canLoadNextPage {
                Text("NO SHOWS FOUND")
                    .wavBlack()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(wavShows) { wavShow in
                            VStack(alignment: .leading, spacing: 2) {
                                WAVShowImage(wavShow: wavShow)
                                    .padding(.horizontal)
                                    .shadow(color: .black.opacity(0.2), radius: 7, y: 8)
                                    .onAppear {
                                        wavShows.last == wavShow ?
                                        loadNextPageIfPossible() :
                                        nil
                                    }

                                Text(wavShow.name.uppercased())
                                    .wavBlack(size: 12, vPadding: 4)
                                    .padding(.horizontal)

                                if category == nil {
                                    WAVShowCategories(wavShow: wavShow, hideCategory: category)
                                        .padding(.horizontal)
                                }

                                Text(wavShow.dateFormatted.uppercased())
//                                    .padding(.horizontal)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 2)
                                    .padding(.horizontal, 4)
                                    .font(Font.custom("Helvetica Neue Medium", size: 12))
                                    .background(.black)
                                    .padding(.horizontal)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    if tag == nil {
                                        WAVShowTags(wavShow: wavShow, hideTag: tag)
                                            .padding(.horizontal)
                                            .padding(.trailing, 50)
                                    }
                                }
                                .mask(
                                    LinearGradient(gradient: Gradient(stops: [
                                        .init(color: .white, location: 0),
                                        .init(color: .white, location: 0.80),
                                        .init(color: .clear, location: 0.98)
                                    ]), startPoint: .leading, endPoint: .trailing)
                                    .frame(height: 100)
                                )

                            }
                        }
                    }
                    .padding(.vertical, 20)

                }
            }
        }
        .background {
            Group {
                colorScheme == .light ?
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            .black.opacity(0),
                            .black.opacity(0.2),
                            .black.opacity(0)
                        ]
                    ),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                :
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            .white.opacity(0.1),
                            .white.opacity(0.0),
                            .white.opacity(0.1)
                        ]
                    ),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            }
            .fadeIn()
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle(category?.name.stringByDecodingHTMLEntities.uppercased() ?? tag?.name.stringByDecodingHTMLEntities.uppercased() ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            guard canLoadNextPage else { return }
            loadWAVShows()
                .sink(receiveCompletion: onReceive, receiveValue: onReceive)
                .store(in: &subscriptions)
        }
    }

    func loadWAVShows() -> AnyPublisher<WAVShows, Error> {
        let offset = page * loadLimit
        let url = URL(
            string: "https://wearevarious.com/wp-json/wp/v2/posts?_embed=wp:featuredmedia&per_page=\(loadLimit)&offset=\(offset)\(tagParameter + categoryParameter + searchQueryParameter)"
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
        NavigationStack {
            InfiniteView()
        }
        .environmentObject(DataController())
    }
}
