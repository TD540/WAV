//
//  WavesWebViewStore.swift
//  WAV
//
//  Created by Thomas on 05/07/2024.
//

import Foundation
import WebKit

class WavesWebViewStore: WebViewStore {
    init() {
        super.init()

        let script = """
            function removeElements() {
                const elementsToRemove = [
                    'button#waves-logo',
                    'div#waves-bar',
                    'div#waves-text-overlay'
                ];
                elementsToRemove.forEach(selector => {
                    const element = document.querySelector(selector);
                    if (element) element.remove();
                });
            }
            removeElements();
            // In case the content loads dynamically, we'll observe for changes
            const observer = new MutationObserver(removeElements);
            observer.observe(document.body, { childList: true, subtree: true });
        """

        let userScript = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        self.webView.configuration.userContentController.addUserScript(userScript)

        // Load the page
        if let url = URL(string: "https://wearevarious.com/waves/") {
            self.webView.load(URLRequest(url: url))
        }
    }
}
