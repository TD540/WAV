//
//  ContentView.swift
//  WeAreVarious
//
//  Created by Thomas on 10/05/2021.
//

import SwiftUI

struct ArchiveView: View {
    @StateObject var archiveDataController: ArchiveDataController

    var body: some View {
        ZStack(alignment: .bottom) {
            RecordBoxView(archiveDataController: archiveDataController)
            WebPlayerView(archiveDataController: archiveDataController)
        }
        // BUG: Adding .edgesIgnoringSafeArea(.all) causes RecordBoxView's scrollViewProxy.scrollTo to scroll wrong.
    }
}

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView(archiveDataController: ArchiveDataController())
            .preferredColorScheme(.light)
    }
}
