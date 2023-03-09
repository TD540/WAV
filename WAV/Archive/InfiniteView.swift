//
//  InfiniteView.swift
//  Shared
//
//  Created by Thomas Decrick on 17/01/2021.
//

import SwiftUI

struct InfiniteView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedShow: WAVShow?
    
    var wavShows: WAVShows {
        dataController.state.wavShows
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(wavShows) { wavShow in
                    ArchiveItemView(
                        wavShow: wavShow
                    ) {
                        if dataController.state.selectedShow == wavShow {
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                            dataController.state.playPause.toggle()
                        } else {
                            dataController.state.selectedShow = wavShow
                        }
                    }
                    .onAppear(perform: wavShows.last == wavShow ? dataController.loadNextPageIfPossible : nil)
                }
            }
            .padding()
        }
        .background(colorScheme == .light ? .black.opacity(0.1) : .white.opacity(0.1))
        .onAppear(perform: dataController.loadNextPageIfPossible)
    }
}


struct InfiniteView_Previews: PreviewProvider {
    static var previews: some View {
        InfiniteView()
            .environmentObject(DataController())
    }
}
