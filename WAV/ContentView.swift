//
//  ContentView.swift
//

import SwiftUI
import SwiftUIIntrospect

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    typealias tab = WAVTabbarView.tab
    @State var currentTab = tab.live
    
    var body: some View {
        ZStack {
            TabView(selection: $currentTab) {
                WAVLiveView()
                    .tag(tab.live)
                    .padding(.top, Constants.marqueeHeight)
                    .padding(.bottom,
                             dataController.selectedShow != nil ?
                             dataController.selectedShow!.isSoundcloud ? 100 : 60 : 0
                    )
                WAVWavesView()
                    .tag(tab.waves)
                    .padding(.top, Constants.marqueeHeight)
                WAVArchiveView()
                    .tag(tab.archive)
                WAVScheduleView()
                    .tag(tab.schedule)
                WAVSearchView()
                    .tag(tab.search)
            }
            .introspect(.tabView, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { UITabBarController in
                UITabBarController.tabBar.isHidden = true
            }

            WAVMarqueeView()
                .shadow(color: .black.opacity(0.4), radius: 15)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            // WAVTabView
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
                    WAVTabbarView(tab: $currentTab)
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
    dataController.radioTitle = "We Are Preview"
    dataController.selectedShow = WAVShow.preview
    dataController.radioIsOffAir = false
    return ContentView(currentTab: .archive)
        .environmentObject(dataController)
}
