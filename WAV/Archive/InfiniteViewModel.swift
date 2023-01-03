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

        static var preview: ViewModel = {
            ViewModel(archiveDataController: ArchiveDataController.preview)
        }()
        
        var archiveDataController: ArchiveDataController

        init(archiveDataController: ArchiveDataController) {
            self.archiveDataController = archiveDataController
        }

        var records: [WAVPost] {
            archiveDataController.state.wavPosts
        }

        func loadNext() {
            archiveDataController.loadNextPageIfPossible()
        }

        func isPlaying(_ record: WAVPost) -> Bool {
            archiveDataController.state.selectedPost == record
        }

        

//        func playToggle(_ record: WAVPost) {
//            UINotificationFeedbackGenerator().notificationOccurred(.success)
//            archiveDataController.playToggle(record)
//        }
    }
}
