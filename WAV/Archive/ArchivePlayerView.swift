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
    @State var height: CGFloat = 0

    func setHeight() {
            if let isSoundcloud = dataController.selectedShow?.isSoundcloud {
                height = isSoundcloud ? 100 : 60
            } else {
                height = 0
            }
    }

    var body: some View {
        WebView(webView: dataController.webViewStore.webView)
            .frame(height: height)
            .onAppear {
                setHeight()
                if let widgetURL = dataController.selectedShow?.widgetURL {
                    dataController.webViewStore.webView.load(
                        URLRequest(url: widgetURL)
                    )
                }
            }
            .onDisappear {
                dataController.webViewStore.webView.loadHTMLString("", baseURL: nil)
            }
            .onChange(of: dataController.selectedShow) { selectedShow in
                setHeight()
                if let widgetURL = selectedShow?.widgetURL {
                    dataController.webViewStore.webView.load(
                        URLRequest(url: widgetURL)
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
