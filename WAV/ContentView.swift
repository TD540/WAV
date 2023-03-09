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
    
    var body: some View {
        VStack(spacing: 0) {
            RadioMarquee(text: radio.title, isOffAir: $radio.isOffAir)
            TabView(selection: $tab) {
                RadioView(radio: radio, archiveDataController: archiveDataController)
                    .tag(Tab.live)
                InfiniteView(archiveDataController: archiveDataController)
                    .tag(Tab.archive)
                Schedule()
                    .tag(Tab.schedule)
            }
            .introspectTabBarController { UITabBarController in
                UITabBarController.tabBar.isHidden = true
            }
            ArchivePlayerView(archiveDataController: archiveDataController)
                .shadow(radius: 20)
            CustomTabBar(tab: $tab)
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
