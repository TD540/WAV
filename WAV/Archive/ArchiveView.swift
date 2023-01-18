//
//  ArchiveView.swift
//  WeAreVarious
//
//  Created by Thomas on 10/05/2021.
//

import SwiftUI

struct ArchiveView: View {
    @StateObject var archiveDataController: ArchiveDataController

    var tabBarSize: CGSize

    var body: some View {
        ZStack(alignment: .bottom) {
            InfiniteView(archiveDataController: archiveDataController)
            ArchivePlayerView(archiveDataController: archiveDataController)
                .padding(.bottom, tabBarSize.height)
                .shadow(radius: 20)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        WAVShow.autoplay = false
        return ArchiveView(
            archiveDataController: ArchiveDataController.preview,
            tabBarSize: .zero
        )
    }
}
