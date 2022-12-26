//
//  RecordBoxViewModel.swift
//  WeAreVarious
//
//  Created by Thomas on 24/05/2021.
//

import Foundation
import UIKit // ?

extension RecordBoxView {
    class ViewModel: ObservableObject {
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
            archiveDataController.state.playing == record
        }

        func play(_ record: WAVPost) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            archiveDataController.play(record)
        }
    }
}
