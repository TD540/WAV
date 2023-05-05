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
