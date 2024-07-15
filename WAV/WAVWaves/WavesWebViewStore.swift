//
//  WavesWebViewStore.swift
//  WAV
//

import WebKit

class WavesWebViewStore: WebViewStore {
    init() {
        super.init()
        let script = """
            function getWavesWebContent() {
                const content = document.querySelector('.vc_custom_1687967564696');
                const copy = content.cloneNode(true);
                copy.removeAttribute('style');
                copy.className = '';
                const divs = document.body.querySelectorAll('div');
                divs.forEach(div => div.remove());
                document.body.appendChild(copy);
            }
            getWavesWebContent();
            const wavesObserver = new MutationObserver(getWavesWebContent);
            wavesObserver.observe(document.body, { childList: true, subtree: true });
        """
        let userScript = WKUserScript(
            source: script,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true,
            in: .world(name: "app")
        )
        self.webView.configuration.userContentController.addUserScript(userScript)
        self.webView.isOpaque = false
        self.webView.backgroundColor = .clear
        self.webView.scrollView.backgroundColor = .clear
        if let url = URL(string: "https://wearevarious.com") {
            self.webView.load(URLRequest(url: url))
        }
    }
}
