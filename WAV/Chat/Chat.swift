//
//  WeekSchedule.swift
//  WAV
//
//  Created by Thomas on 08/10/2022.
//

import SwiftUI
import WebView
import WebKit

struct Chat: View {
    @StateObject var webViewStore = WebViewStore(webView: WKWebView(frame: .zero))
    var body: some View {
        ZStack(alignment: Alignment.top) {
            WebView(webView: webViewStore.webView)
                .onAppear {
                    webViewStore.webView.load(URLRequest(url: URL(string: "https://organizations.minnit.chat/151853736330934/Main")!))
                }
        }
    }
}

struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        Chat()
    }
}
