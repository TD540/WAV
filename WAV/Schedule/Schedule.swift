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
    @StateObject var webViewStore = WebViewStore(webView: WKWebView(frame: .zero))

    func modifySchedulePageCSS() {
        let css = """
            * {
                background-color: transparent !important
            }
            body > :not(.box-wrapper),
            .menu-wrapper,
            .main-container > :not(.page-wrapper),
            #page-header {
                display: none !important
            }
            .main-container .row-container .row-parent {
                padding: 16px 36px
            }
            @media (prefers-color-scheme: dark) {
              #main-page-id * {
                color: white !important;
                border-color: white !important;
              }
            }
            """
        let script = """
            var style = document.createElement('style');
            style.innerHTML = `\(css)`;
            document.head.appendChild(style)
            alert("hello")
            """
        let userScript = WKUserScript(
            source: script,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true,
            in: .world(name: "app")
        )
        webViewStore.configuration.userContentController.addUserScript(userScript)
        webViewStore.webView.isOpaque = false
        webViewStore.webView.backgroundColor = .clear
        webViewStore.webView.scrollView.backgroundColor = .clear
    }

    var body: some View {
        WebView(webView: webViewStore.webView)
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                modifySchedulePageCSS()
                webViewStore.webView.load(URLRequest(url: URL(string: "https://wearevarious.com/week-schedule")!))
            }
    }
}

struct Schedule_Previews: PreviewProvider {
    static var previews: some View {
        Schedule()
    }
}
