//
//  ArchivePlayerView.swift
//  WeAreVarious
//
//  Created by Thomas on 16/04/2021.
//

import SwiftUI
import WebView

struct ArchivePlayerView: View {
    @EnvironmentObject var dataController: DataController

    var body: some View {
        WebView(webView: dataController.webViewStore.webView)
            .frame(height: 60)
            .onAppear {
                if let selectedShow = dataController.selectedShow {
                    dataController.webViewStore.webView.load(
                        URLRequest(url: selectedShow.mixcloudWidget)
                    )
                }
            }
            .onDisappear {
                dataController.webViewStore.webView.loadHTMLString("", baseURL: nil)
            }
            .onChange(of: dataController.selectedShow) { selectedShow in
                if let selectedShow {
                    dataController.webViewStore.webView.load(
                        URLRequest(url: selectedShow.mixcloudWidget)
                    )
                } else {
                    dataController.webViewStore.webView.loadHTMLString("", baseURL: nil)
                }
            }
    }

}

struct WebPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = DataController()
        controller.selectedShow = WAVShow.preview
        return VStack {
            Spacer()
            ArchivePlayerView()
                .environmentObject(controller)
        }
    }
}
