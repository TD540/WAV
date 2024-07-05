//
//  ContentView.swift
//  WAV
//
//  Created by Thomas on 19/07/2022.
//

import SwiftUI
import SwiftUIIntrospect

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    @State var tab: WAVTab = .live

    var body: some View {
        ZStack {
            
            TabView(selection: $tab) {
                Radio()
                    .tag(WAVTab.live)
                    .padding(.top, Constants.marqueeHeight)
                    .padding(.bottom,
                             dataController.selectedShow != nil ? 
                             dataController.selectedShow!.isSoundcloud ? 100 : 60 : 0
                    )
                Text("coming soon")
                    .tag(WAVTab.waves)
                Archive()
                    .tag(WAVTab.archive)
                Schedule()
                    .tag(WAVTab.schedule)
                Search()
                    .tag(WAVTab.search)
            }
            .introspect(.tabView, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { UITabBarController in
                UITabBarController.tabBar.isHidden = true
            }

            // Top
            VStack(spacing: 0) {
                RadioMarquee()
                    .shadow(color: .black.opacity(0.4), radius: 15)
                Spacer()
            }

            // Tabbar
            VStack(spacing: 0) {
                Spacer()
                VStack(spacing: 0) {
                    if dataController.selectedShow != nil {
                        ArchivePlayerView()
                            .background {
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: Color.black.opacity(0.0), location: 0.0),
                                        .init(color: Color.black.opacity(1.0), location: 1.0)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            }
                    }
                    WAVTabBar(tab: $tab)
                        .shadow(color: .black.opacity(0.9), radius: 10)
                }
            }

        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            dataController.updateRadioMarquee()
        }
    }
}

#Preview {
    let dataController = DataController()
    dataController.radioTitle = "Title"
    dataController.selectedShow = WAVShow.preview
    dataController.radioIsOffAir = false
    return ContentView(tab: .archive)
        .environmentObject(dataController)
}
