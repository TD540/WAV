//
//  Waves.swift
//  WAV
//
//  Created by Thomas on 05/07/2024.
//

import SwiftUI

struct Waves: View {
    @EnvironmentObject var dataController: DataController


    var body: some View {
        WebView(webView: dataController.wavesWebViewStore.webView)
    }
}


#Preview {
    Waves()
}
