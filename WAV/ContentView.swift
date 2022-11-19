//
//  ContentView.swift
//  WAV
//
//  Created by Thomas on 19/07/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var radio: Radio

    var body: some View {
        TabView {
            RadioView(radio: radio)
                .tabItem {
                    Label(
                        radio.isLive ? "LIVE" : "RADIO",
                        systemImage: radio.isLive ?
                        "dot.radiowaves.left.and.right" : "radio"
                    )
                }
            Schedule()
                .tabItem {
                    Label("SCHEDULE", systemImage: "calendar.badge.clock")
                }
            UnderConstruction()
                .tabItem {
                    Label("ARCHIVE", systemImage: "square.stack")
                }
            UnderConstruction()
                .tabItem {
                    Label("CHAT", systemImage: "message")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Radio.shared)
    }
}
