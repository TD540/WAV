//
//  WeekSchedule.swift
//  WAV
//
//  Created by Thomas on 08/10/2022.
//

import SwiftUI
import WebView
import WebKit

struct WeekSchedule: View {
    @StateObject var webViewStore = WebViewStore()

    var body: some View {
        WebView(webView: webViewStore.webView)
            .onAppear {
                webViewStore.webView.load(URLRequest(url: URL(string: "https://wearevarious.com/week-schedule")!))

                let css = "* { border: 1px solid red !important; }"
                let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
                webViewStore.webView.evaluateJavaScript(js, completionHandler: nil)
            }
    }
}

struct WeekSchedule_Previews: PreviewProvider {
    static var previews: some View {
        WeekSchedule()
    }
}
