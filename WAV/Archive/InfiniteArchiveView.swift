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
                    let record = viewModel.records[index]
                    VStack(alignment: .leading) {
                        Button {
                            viewModel.play(record)
                        } label: {
                            archiveItemButtonLabel(record: record)
                        }
                        archiveItemInfo(record: record)
                    }
                    .padding(.horizontal)
                    .onAppear(perform: viewModel.records.last == record ? viewModel.loadNext : nil)
                }
            }
        }
        .background(.black.opacity(0.1))
        .onAppear(perform: viewModel.loadNext)
    }
    func archiveItemButtonLabel(record: WAVPost) -> some View {
        AsyncImage(url: record.pictureURL) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(1.5, contentMode: .fit)
                .background(.black.opacity(0.1))
        }
    }
    func archiveItemInfo(record: WAVPost) -> some View {
        VStack(alignment: .leading) {
            ShowTitle(string: record.name)
            ShowTitle(string: record.dateFormatted)
        }
    }
}

struct InfiniteArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        InfiniteArchiveView(archiveDataController: ArchiveDataController())
            .preferredColorScheme(.light)
    }
}
