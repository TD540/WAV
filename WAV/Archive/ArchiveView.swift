//
//  ArchiveView.swift
//  WeAreVarious
//
//  Created by Thomas on 10/05/2021.
//

import SwiftUI

struct ArchiveView: View {
    @StateObject var archiveDataController: ArchiveDataController

    var body: some View {
        ScrollViewReader { scrollProxy in
            ZStack(alignment: .bottom) {
                InfiniteView(archiveDataController: archiveDataController, scrollProxy: scrollProxy)
                ArchivePlayerView(archiveDataController: archiveDataController, scrollProxy: scrollProxy)
            }
        }
    }
}

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView(archiveDataController: ArchiveDataController.preview)
            .preferredColorScheme(.dark)
    }
}
