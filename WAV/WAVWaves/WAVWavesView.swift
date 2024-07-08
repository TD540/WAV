//
//  WAVWavesView.swift
//

import SwiftUI

struct WAVWavesView: View {
    @EnvironmentObject var dataController: DataController

    var body: some View {
        WebView(webView: dataController.wavesWebViewStore.webView)
    }
}


#Preview {
    WAVWavesView()
}
