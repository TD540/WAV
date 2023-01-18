//
//  ArchiveView.swift
//  WeAreVarious
//
//  Created by Thomas on 10/05/2021.
//

import SwiftUI

struct ArchiveView: View {
    @StateObject var archiveDataController: ArchiveDataController

    @Environment(\.safeAreaInsets) private var safeAreaInsets

    var tabBarSize: CGSize

    var body: some View {
        ZStack(alignment: .bottom) {
            InfiniteView(archiveDataController: archiveDataController)
            ArchivePlayerView(archiveDataController: archiveDataController)
                .padding(.bottom, safeAreaInsets.bottom + tabBarSize.height)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView(
            archiveDataController: ArchiveDataController.preview,
            tabBarSize: .zero
        )
    }
}
