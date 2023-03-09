//
//  ContentView.swift
//  WAV
//
//  Created by Thomas on 19/07/2022.
//

import SwiftUI
import Introspect

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    @State var tab: Tab = .live
    

    var body: some View {
        VStack(spacing: 0) {
            RadioMarquee(text: dataController.radioTitle, isOffAir: dataController.radioIsOffAir)
            TabView(selection: $tab) {
                RadioView()
                    .tag(Tab.live)
                InfiniteView()
                    .tag(Tab.archive)
                Schedule()
                    .tag(Tab.schedule)
            }
            .introspectTabBarController { UITabBarController in
                UITabBarController.tabBar.isHidden = true
            }
            if dataController.state.selectedShow != nil {
                ArchivePlayerView(dataController: dataController)
                    .shadow(radius: 20)
            }
            CustomTabBar(tab: $tab)
        }
        .edgesIgnoringSafeArea(.all)
        .onChange(of: dataController.state.wavShowIsPlaying) { isPlaying in
            if dataController.radioIsPlaying {
                dataController.stopRadio()
            }
        }
        .onChange(of: dataController.radioIsPlaying) { isPlaying in
            if isPlaying {
                dataController.state.playPause.toggle()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(tab: .live)
            .environmentObject(DataController())
    }
}
