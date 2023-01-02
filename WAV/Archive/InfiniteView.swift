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
                    ArchiveItem(
                        viewModel: viewModel,
                        index: index
                    )
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
        let archiveDataController = ArchiveDataController.preview
        archiveDataController.state.wavPosts += [WAVPost.preview]
        return InfiniteView(archiveDataController: archiveDataController)
            .preferredColorScheme(.light)
    }
}
