//
//  WavesWebViewStore.swift
//  WAV
//

import Foundation
import WebKit

class WavesWebViewStore: WebViewStore {
    init() {
        super.init()

        let script = """
            function removeElements() {
                const elementsToRemove = [
                    '.menu-wrapper',
                    '#home_continuous_padding',
                    '.post-content > :not(:first-child)',
                    '.site-footer'
                ];
                elementsToRemove.forEach(selector => {
                    const element = document.querySelector(selector);
                    if (element) element.remove();
                });
            }
            removeElements();
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
