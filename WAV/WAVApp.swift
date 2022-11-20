//
//  WAVApp.swift
//  WAV
//
//  Created by Thomas on 19/07/2022.
//

import SwiftUI

@main
struct WAVApp: App {
    @StateObject var radio = Radio()
    @StateObject var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(radio)
                .environmentObject(dataController)
        }
    }
}
