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

    var archivePlayerHeight: CGFloat {
        dataController.selectedShow != nil ? 120.0 : 0.0
    }

    var body: some View {
        VStack(spacing: 0) {
            RadioMarquee(text: dataController.radioTitle, isOffAir: dataController.radioIsOffAir)
            ZStack(alignment: .bottom) {
                TabView(selection: $tab) {
                    Radio()
                        .padding(.bottom, archivePlayerHeight)
                        .tag(Tab.live)
                    Archive()
                        .tag(Tab.archive)
                    Search()
                        .tag(Tab.search)
                    Schedule()
                        .tag(Tab.schedule)
                }
                .introspectTabBarController { UITabBarController in
                    UITabBarController.tabBar.isHidden = true
                }
                if dataController.selectedShow != nil {
                    ArchivePlayerView()
                }
            }
            CustomTabBar(tab: $tab)
        }
        .background(.black)
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
