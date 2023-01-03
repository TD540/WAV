//
//  ContentView.swift
//  WAV
//
//  Created by Thomas on 19/07/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var radio: Radio
    @EnvironmentObject var archiveDataControllerroller: ArchiveDataController
    @State private var tabSelection = 1

    var body: some View {
        TabView(selection: $tabSelection) {
            RadioView(radio: radio)
                .tabItem {
                    Label(
                        radio.isLive ? "LIVE" : "RADIO",
                        systemImage: radio.isLive ?
                        "dot.radiowaves.left.and.right" : "radio"
                    )
                }
                .tag(1)
            ArchiveView(archiveDataController: archiveDataControllerroller)
                .tabItem {
                    Label("ARCHIVE", systemImage: "square.stack")
                }
                .tag(2)
            Schedule()
                .tabItem {
                    Label("SCHEDULE", systemImage: "calendar.badge.clock")
                }
                .tag(3)
            Chat()
                .tabItem {
                    Label("CHAT", systemImage: "message")
                }
                .tag(4)
        }
        .onAppear {
            tabSelection = radio.isOffAir ? 2 : 1
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Radio())
            .environmentObject(ArchiveDataController())
    }
}
