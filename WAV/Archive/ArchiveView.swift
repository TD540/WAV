//
//  ContentView.swift
//  WeAreVarious
//
//  Created by Thomas on 10/05/2021.
//

import SwiftUI

struct ArchiveView: View {
    @StateObject var dataController: DataController

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
        ArchiveView(dataController: DataController(disableAPI: false, previewPlaying: false))
            .preferredColorScheme(.light)
    }
}
