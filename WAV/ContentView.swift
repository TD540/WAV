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
    @State var tab: Tab = .live
    @Environment(\.colorScheme) var colorScheme
    @State var topPadding = 0.0
    @State var bottomPadding = 0.0

    var body: some View {
        ZStack {
            TabView(selection: $tab) {
                RadioView(radio: radio)
                    .tag(Tab.live)
                    .padding(.top, topPadding)
                    .padding(.bottom, bottomPadding)
                    .edgesIgnoringSafeArea(.all)
                InfiniteView(archiveDataController: archiveDataController)
                    .tag(Tab.archive)
                Schedule()
                    .tag(Tab.schedule)
            }
            .introspectTabBarController { UITabBarController in
                UITabBarController.tabBar.isHidden = true
            }
            VStack(spacing: 0) {
                RadioMarquee(text: radio.title)
                    .readSize { size in
                        topPadding = size.height
                    }
                Spacer()
                VStack(spacing: 0) {
                    ArchivePlayerView(archiveDataController: archiveDataController)
                        .shadow(radius: 20)
                    CustomTabBar(tab: $tab)
                }
                .readSize { size in
                    bottomPadding = size.height
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
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
        ContentView(tab: .live)
            .environmentObject(Radio())
            .environmentObject(ArchiveDataController())
    }
}
