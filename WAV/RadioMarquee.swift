//
//  RadioMarquee.swift
//  WAV
//
//  Created by Thomas on 20/11/2022.
//

import SwiftUI

struct RadioMarquee: View {
    let text: String?
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.safeAreaInsets) var safeAreaInsets
    
    var body: some View {
        if let text = text {
            let cleanTitle = text.applyingTransform(.stripDiacritics, reverse: false)!.uppercased()
            MarqueeText(
                text: cleanTitle,
                font: UIFont(name: "pixelmix", size: 14)!,
                leftFade: 60,
                rightFade: 60,
                startDelay: 2
            )
            .padding(.top, safeAreaInsets.top)
            .padding(.vertical)
            .padding(.bottom, 5)

            .foregroundColor(.primary)
            .background(Material.thin)
            .background(.white.opacity(0.1))
            .border(width: 1, edges: [.bottom], color: .secondary.opacity(0.3))

        }
    }
}

struct RadioMarquee_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RadioMarquee(text: "This is the Radio Marquee. This is the Radio Marquee. ")
            Spacer()
        }
    }
}
