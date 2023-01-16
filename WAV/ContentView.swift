//
//  ContentView.swift
//  WAV
//
//  Created by Thomas on 19/07/2022.
//

import SwiftUI
import Introspect

struct ContentView: View {
    @StateObject var radio = Radio()
    @StateObject var archiveDataController = ArchiveDataController()

    @State var tab = 1

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $tab) {
                RadioView(radio: radio)
                    .tabItem {
                        Image(radio.isLive ? "tab-radio-live" : "tab-radio")
                        Text(radio.isLive ? "LIVE" : "RADIO")
                    }
                    .tag(1)
                ArchiveView(
                    archiveDataController: archiveDataController
                )
                .tabItem {
                    Image("tab-archive")
                    Text("ARCHIVE")
                }
                .tag(2)
                Schedule()
                    .tabItem {
                        Image("tab-schedule")
                        Text("SCHEDULE")
                    }
                    .tag(3)
                Chat()
                    .tabItem {
                        Image("tab-chat")
                        Text("CHAT")
                    }
                    .tag(4)
            }
            .introspectTabBarController { (UITabBarController) in
                UITabBarController.tabBar.isHidden = true
            }

            CustomTabBar(tab: $tab, iconHeight: 44)

        }
        .onAppear {
            tab = radio.isOffAir ? 2 : 1
        }
        .onChange(of: archiveDataController.state.isPlaying) { isPlaying in
            if isPlaying {
                radio.stop()
            }
        }
        .onChange(of: radio.isPlaying) { isPlaying in
            if isPlaying {
                archiveDataController.state.playPause.toggle()
            }
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
