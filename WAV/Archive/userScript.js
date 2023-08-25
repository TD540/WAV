window.onload = function() {
    var style = document.createElement('style');
    style.innerHTML = '.restricted-message-overlay, .compactSound__artwork, .privacyPolicy, .soundHeader__rightRow { display: none !important }';
    document.head.appendChild(style);
}
