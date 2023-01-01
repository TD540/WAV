//
//  InfiniteView.swift
//  Shared
//
//  Created by Thomas Decrick on 17/01/2021.
//

import SwiftUI

struct InfiniteView: View {
    @ObservedObject private var viewModel: ViewModel
    init(archiveDataController: ArchiveDataController) {
        viewModel = ViewModel(archiveDataController: archiveDataController)
    }
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(viewModel.records.indices, id: \.self) { index in
                    ArchiveItem(record: viewModel.records[index]) {
                        viewModel.play(viewModel.records[index])
                    }
                    .padding(.horizontal)
                    .onAppear(perform: viewModel.records.last == viewModel.records[index] ? viewModel.loadNext : nil)
                }
            }
        }
        .background(.black.opacity(0.1))
        .onAppear(perform: viewModel.loadNext)
    }
}

struct InfiniteView_Previews: PreviewProvider {
    static var previews: some View {
        let wavPost = WAVPost(
            id: 1,
            date: "2022-12-24T17:43:55",
            title: WAVPost.Title(rendered: "88 Black Gravity X-Mas Rhythms for the brain"),
            mixcloudURL: "https://www.mixcloud.com/WeAreVarious/privat-live-aus-at-de-nor-08-07-22/",
            embedded: WAVPost.Embedded(
                wpFeaturedmedia:
                    [
                        WAVPost.WpFeaturedmedia(
                            sourceURL:
                                "https://dev.wearevarious.com/wp-content/uploads/2022/07/privat-live-at-de-nor-.jpg"
                        )
                    ]
            )
        )
        let archiveDataController = ArchiveDataController.preview
        archiveDataController.state.wavPosts += [wavPost]
        return InfiniteView(archiveDataController: archiveDataController)
            .preferredColorScheme(.light)
    }
}
