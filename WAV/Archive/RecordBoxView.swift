//
//  RecordBoxView.swift
//  Shared
//
//  Created by Thomas Decrick on 17/01/2021.
//

import SwiftUI

struct RecordBoxView: View {
    @ObservedObject private var viewModel: ViewModel
    init(archiveDataController: ArchiveDataController) {
        viewModel = ViewModel(archiveDataController: archiveDataController)
    }
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.records.indices, id: \.self) { index in
                    let record = viewModel.records[index]
                    Button {
                        viewModel.play(record)
                    } label: {
                        VStack(alignment: .leading) {
                            if let pictureURL = record.pictureURL {
                                AsyncImage(url: pictureURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            ShowTitle(string: record.name.uppercased())
                        }
                        .padding()
                    }
                    .onAppear(perform: viewModel.records.last == record ? viewModel.loadNext : nil)
                }
            }
        }
        .onAppear(perform: viewModel.loadNext)
    }
}

struct RecordBoxView_Previews: PreviewProvider {
    static var previews: some View {
        RecordBoxView(archiveDataController: ArchiveDataController())
            .preferredColorScheme(.light)
    }
}
