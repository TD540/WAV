//
//  WAVApp.swift
//  WAV
//
//  Created by Thomas on 19/07/2022.
//

import SwiftUI

@main
struct WAVApp: App {
    @StateObject var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .environmentObject(dataController)
        }
    }
}

struct Constants {
    static let loadLimit = 10.0
    static let marqueeHeight = 50.0
}
