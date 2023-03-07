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
            HStack(spacing: 0) {
                Text("NOW PLAYING:")
                    .font(.custom("Helvetica Neue Bold", size: 14))
                MarqueeText(
                    text: cleanTitle,
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
                    .fill(.white.opacity(0.9))
                    .padding(.top, safeAreaInsets.top)
            }
            .background(Material.regular)
            .border(width: 2, edges: [.bottom], color: .secondary.opacity(0.3))
        }
    }
}

struct RadioMarquee_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RadioMarquee(text: "This is the Radio Marquee. This is the Radio Marquee. ")
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}
