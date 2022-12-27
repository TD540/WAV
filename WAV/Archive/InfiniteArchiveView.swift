//
//  InfiniteArchiveView.swift
//  Shared
//
//  Created by Thomas Decrick on 17/01/2021.
//

import SwiftUI

struct InfiniteArchiveView: View {
    @ObservedObject private var viewModel: ViewModel
    init(archiveDataController: ArchiveDataController) {
        viewModel = ViewModel(archiveDataController: archiveDataController)
    }
    var body: some View {
        ScrollView {
            LazyVStack {
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

struct InfiniteArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        InfiniteArchiveView(archiveDataController: ArchiveDataController())
            .preferredColorScheme(.light)
    }
}

