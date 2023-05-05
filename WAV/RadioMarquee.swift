//
//  RadioMarquee.swift
//  WAV
//
//  Created by Thomas on 20/11/2022.
//

import SwiftUI

struct RadioMarquee: View {
    let text: String?
    var isOffAir: Bool
    @Environment(\.safeAreaInsets) var safeAreaInsets

    var body: some View {
        if let text = text {
            let cleanTitle = text.applyingTransform(.stripDiacritics, reverse: false)!.uppercased()
            HStack {
                MarqueeText(
                    text: (isOffAir ? "" : "NOW PLAYING: ") + cleanTitle,
                    font: UIFont(name: "Helvetica Neue Medium", size: 14)!,
                    leftFade: 0,
                    rightFade: 0,
                    startDelay: 2
                )
            }
            .padding(.top, safeAreaInsets.top)
            .padding()
            .foregroundColor(.black)
            .background {
                Rectangle()
                    .fill(.white)
                    .padding(.top, safeAreaInsets.top)
            }
            .background(.black.opacity(0.95))
            .border(width: 1, edges: [.bottom], color: .secondary.opacity(0.3))
        }
    }
}

struct RadioMarquee_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RadioMarquee(text: "This is the Radio Marquee. This is the Radio Marquee.", isOffAir: true)
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}
