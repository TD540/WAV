//
//  ContentView.swift
//  WAV
//
//  Created by Thomas on 19/07/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var radio: Radio

    init() {
     UITabBarItem
            .appearance()
            .setTitleTextAttributes(
                [
                    NSAttributedString.Key.font:
                        UIFont.init(
                            name: "pixelmix",
                            size: 9
                        )!
                ],
                for: .normal
            )
    }
    
    var body: some View {
        TabView {
            RadioView(radio: radio)
                .tabItem {
                    Label("LIVE", systemImage: "dot.radiowaves.left.and.right")
                }
            Schedule()
                .tabItem {
                    Label("SCHEDULE", systemImage: "calendar.badge.clock")
                }
            Archive()
                .tabItem {
                    Label("ARCHIVE", systemImage: "square.stack")
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


