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
            LazyVStack(spacing: 30) {
                ForEach(viewModel.wavShows.indices, id: \.self) { index in
                    ArchiveItemView(
                        infiniteViewModel: viewModel,
                        index: index
                    )
                    .id(viewModel.wavShows[index].id)
                    .padding(.horizontal)
                    .onAppear(perform: viewModel.wavShows.last == viewModel.wavShows[index] ? viewModel.loadNext : nil)
                }
            }
        }
        .background(colorScheme == .dark ? .white.opacity(0.15) : .black.opacity(0.1))
        .onAppear(perform: viewModel.loadNext)
    }
}

struct InfiniteView_Previews: PreviewProvider {
    static var previews: some View {
        let archiveDataController = ArchiveDataController.preview
        archiveDataController.state.wavShows += [WAVShow.preview]
        archiveDataController.state.selectedShow = nil
        return ScrollViewReader { scrollProxy in
            InfiniteView(archiveDataController: archiveDataController, scrollProxy: scrollProxy)
        }
        .preferredColorScheme(.dark)
    }
}
