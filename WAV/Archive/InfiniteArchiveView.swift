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
            LazyVStack(spacing: 20) {
                ForEach(viewModel.records.indices, id: \.self) { index in
                    let record = viewModel.records[index]
                    VStack(alignment: .leading, spacing: 4) {
                        Button {
                            viewModel.play(record)
                        } label: {
                            if let pictureURL = record.pictureURL {
                                AsyncImage(url: pictureURL) { image in
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
                        }
                        ShowTitle(string: record.name.uppercased())
                    }
                    .padding(.horizontal)
                    .onAppear(perform: viewModel.records.last == record ? viewModel.loadNext : nil)
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
