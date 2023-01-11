//
//  InfiniteViewModel.swift
//  WeAreVarious
//
//  Created by Thomas on 24/05/2021.
//

import Foundation
import UIKit // ?

extension InfiniteView {
    class ViewModel: ObservableObject {
        var archiveDataController: ArchiveDataController
        init(archiveDataController: ArchiveDataController) {
            self.archiveDataController = archiveDataController
        }
        var wavShows: WAVShows {
            archiveDataController.state.wavShows
        }
        func loadNext() {
            archiveDataController.loadNextPageIfPossible()
        }
        func isPlaying(_ wavShow: WAVShow) -> Bool {
            archiveDataController.state.selectedShow == wavShow
        }
        static var preview: ViewModel = {
            ViewModel(archiveDataController: ArchiveDataController.preview)
        }()
    }
}
