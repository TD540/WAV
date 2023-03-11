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
    @State var tab: Tab = .archive

    var body: some View {
        VStack(spacing: 0) {
            RadioMarquee(text: dataController.radioTitle, isOffAir: dataController.radioIsOffAir)
            TabView(selection: $tab) {
                RadioView()
                    .tag(Tab.live)
                ArchiveView()
                    .tag(Tab.archive)
                Schedule()
                    .tag(Tab.schedule)
            }
            .introspectTabBarController { UITabBarController in
                UITabBarController.tabBar.isHidden = true
            }
            if dataController.selectedShow != nil {
                ArchivePlayerView()
            }
            CustomTabBar(tab: $tab)
        }
        .onAppear {
            dataController.updateRadioMarquee()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(tab: .live)
            .environmentObject(DataController())
    }
}
