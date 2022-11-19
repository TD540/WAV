//
//  ContentView.swift
//  WeAreVarious
//
//  Created by Thomas on 10/05/2021.
//

import SwiftUI

struct ArchiveView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack(alignment: .bottom) {
            RecordBoxView(dataController: dataController)
            WebPlayerView(dataController: dataController)
        }
        // BUG: Adding .edgesIgnoringSafeArea(.all) causes RecordBoxView's scrollViewProxy.scrollTo to scroll wrong.
    }
}

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView()
            .environmentObject(DataController(disableAPI: false, previewPlaying: false))
            .preferredColorScheme(.light)
    }
}
