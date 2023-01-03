//
//  InfiniteView.swift
//  Shared
//
//  Created by Thomas Decrick on 17/01/2021.
//

import SwiftUI

struct InfiniteView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var viewModel: ViewModel
    var scrollProxy: ScrollViewProxy
    init(archiveDataController: ArchiveDataController, scrollProxy: ScrollViewProxy) {
        viewModel = ViewModel(archiveDataController: archiveDataController)
        self.scrollProxy = scrollProxy
    }
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(viewModel.records.indices, id: \.self) { index in
                    ArchiveItem(
                        infiniteViewModel: viewModel,
                        index: index
                    )
                    .id(viewModel.records[index].id)
                    .padding(.horizontal)
                    .onAppear(perform: viewModel.records.last == viewModel.records[index] ? viewModel.loadNext : nil)
                }
            }
        }
        .background(colorScheme == .dark ? .white.opacity(0.12) : .black.opacity(0.1))
        .onAppear(perform: viewModel.loadNext)
    }
}

struct InfiniteView_Previews: PreviewProvider {
    static var previews: some View {
        let archiveDataController = ArchiveDataController.preview
        archiveDataController.state.wavPosts += [WAVPost.preview]
        archiveDataController.state.selectedPost = nil
        return ScrollViewReader { scrollProxy in
            InfiniteView(archiveDataController: archiveDataController, scrollProxy: scrollProxy)
        }
            .preferredColorScheme(.dark)
    }
}
