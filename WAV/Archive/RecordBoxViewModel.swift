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
        var dataController: DataController

        init(dataController: DataController) {
            self.dataController = dataController
        }

        var records: [WAVPost] {
            dataController.state.wavCasts
        }

        func loadNext() {
            dataController.loadNextPageIfPossible()
        }

        func isPlaying(_ record: WAVPost) -> Bool {
            dataController.state.playing == record
        }

        func play(_ record: WAVPost) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            dataController.play(record)
        }
    }
}
