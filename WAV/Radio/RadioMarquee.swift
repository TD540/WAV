//
//  RadioMarquee.swift
//  WAV
//
//  Created by Thomas on 20/11/2022.
//

import SwiftUI
import MarqueeText

struct RadioMarquee: View {
    let text: String?
    let size: CGFloat
    var body: some View {
        if let text = text {
            let cleanTitle = text.applyingTransform(.stripDiacritics, reverse: false)!.uppercased()
            MarqueeText(
                text: "  " + cleanTitle + "  ",
                font: UIFont(name: "pixelmix", size: size)!,
                leftFade: 60,
                rightFade: 60,
                startDelay: 1
            )
            .foregroundColor(.accentColor)
        }
    }
}

struct RadioMarquee_Previews: PreviewProvider {
    static var previews: some View {
        RadioMarquee(text: "This is the Radio Marquee. This is the Radio Marquee.", size: 18)
    }
}
