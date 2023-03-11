//
//  Player.swift
//  WAV
//
//  Created by thomas on 11/03/2023.
//  https://stackoverflow.com/a/60362141/147163
//

import MediaPlayer

class Player: AVPlayer, ObservableObject {
    @Published var isPlaying: Bool = false
    private var playerContext = 0

    override init() {
        super.init()
        addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: &playerContext)
    }

    deinit {
        removeObserver(self, forKeyPath: "timeControlStatus")
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {

        guard context == &playerContext else { // give super to handle own cases
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        if self.timeControlStatus == .playing {
            self.isPlaying = true
        } else {
            self.isPlaying = false
        }
    }
}
