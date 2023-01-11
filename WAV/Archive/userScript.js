function elementReady(selector) {
    return new Promise((resolve, reject) => {
        let el = document.querySelector(selector)
        if (el) {
            resolve(el)
        }
        new MutationObserver((mutationRecords, observer) => {
            Array.from(document.querySelectorAll(selector)).forEach((element) => {
                resolve(element)
                observer.disconnect()
            })
        }).observe(document.documentElement, {
            childList: true,
            subtree: true,
        })
    })
}

window.webAudioPromise = elementReady("audio").then((webAudioElement) => {
    window.webAudioElement = webAudioElement
    webAudioElement.onplay = function() {
        window.webkit.messageHandlers.isPlaying.postMessage(webAudioElement.paused)
    }
    webAudioElement.onpause = function() {
        window.webkit.messageHandlers.isPlaying.postMessage(webAudioElement.paused)
    }
})

window.onload = function() {
    var style = document.createElement('style');
    style.innerHTML = '.restricted-message-overlay { display: none !important }';
    document.head.appendChild(style);
}
