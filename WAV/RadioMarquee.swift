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

            Marquee(targetVelocity: 50, spacing: 30) {
                HStack {
                    if isOffAir == false {
                        Text("NOW PLAYING:")
                            .foregroundColor(.black)
                    }
                    Text(cleanTitle)
                        .foregroundColor(isOffAir ? .black.opacity(0.6) : .accentColor)
                }
                .font(.custom("Helvetica Neue Medium", size: 14))
                .frame(height: Constants.marqueeHeight)
            }
            .padding(.top, safeAreaInsets.top)

            .background {
                ZStack {
                    BlurView(style: .dark)
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.black.opacity(0.8), location: 0.0),
                            .init(color: Color.black.opacity(0.1), location: 1.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: safeAreaInsets.top)
                    .edgesIgnoringSafeArea(.all)

                    Color.white
                        .padding(.top, safeAreaInsets.top)
                }
            }
            .shadow(radius: 30)
            .edgesIgnoringSafeArea(.top)
        }
    }
}

#Preview {
    VStack {
        RadioMarquee(text: "This is the Radio Marquee.", isOffAir: true)
        Spacer()
    }
    .background(.gray)

}
