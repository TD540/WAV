//
//  RecordBoxView.swift
//  Shared
//
//  Created by Thomas Decrick on 17/01/2021.
//

import SwiftUI

struct RecordBoxView: View {
    @ObservedObject private var viewModel: ViewModel
    init(dataController: DataController) {
        viewModel = ViewModel(dataController: dataController)
    }
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.records.indices, id: \.self) { index in
                    let record = viewModel.records[index]
                    Button {
                        viewModel.play(record)
                    } label: {
                        VStack {
                            if let pictureURL = record.pictureURL {
                                AsyncImage(url: pictureURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .padding()
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            Text(record.name)
                                .font(.custom("pixelmix", size: 18))
                                .foregroundColor(.accentColor)
                        }
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
        RecordBoxView(dataController: DataController())
            .preferredColorScheme(.light)
    }
}
