//
//  WeekSchedule.swift
//  WAV
//
//  Created by Thomas on 08/10/2022.
//

import SwiftUI
import WebView
import WebKit

struct Schedule: View {
    @StateObject var webViewStore: WebViewStore // check Extensions > WebView for more 
    init() {
        let hideEverythingExceptContentStyle = "body > :not(.box-wrapper), .menu-wrapper, .main-container > :not(.page-wrapper), #page-header {display: none !important} .main-container .row-container .row-parent { padding: 16px 36px }"
        let appendStyle = "var style = document.createElement('style'); style.innerHTML = '\(hideEverythingExceptContentStyle)'; document.head.appendChild(style)"
        let userScript = WKUserScript(
            source: appendStyle,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true,
            in: .world(name: "app")
        )
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        let store = WebViewStore(webView: WKWebView(frame: .zero, configuration: configuration))
        _webViewStore = StateObject(wrappedValue: store)
    }
    var body: some View {
        VStack {
            Image("WAV")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.accentColor)
                .scaledToFit()
                .frame(maxHeight: 30)
                .padding(.top, 20)
            WebView(webView: webViewStore.webView)
                .onAppear {
                    webViewStore.webView.load(URLRequest(url: URL(string: "https://wearevarious.com/week-schedule")!))
                }
        }
    }
}

struct WeekSchedule_Previews: PreviewProvider {
    static var previews: some View {
        Schedule()
    }
}
