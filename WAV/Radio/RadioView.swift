//
//  RadioView.swift
//  WAV
//
//  Created by Thomas on 22/07/2022.
//

import SwiftUI
import MarqueeText

struct RadioView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var radio: Radio
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                if let artURL = radio.artURL {
                    AsyncImage(url: artURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ZStack {
                            Rectangle()
                                .fill(Color.accentColor)
                                .scaledToFit()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                    }
                } else {
                    Image("Globe")
                        .resizable()
                        .scaledToFit()
                }
            }
            // .rotation3DEffect(.degrees(-10), axis: (x: -1, y: 0, z: 0), perspective: 0.3)
            .shadow(color: .black.opacity(0.4), radius: 10, x: 0.0, y: 25.0)
            if let title = radio.title {
                let cleanTitle = title.applyingTransform(.stripDiacritics, reverse: false)!
                MarqueeText(
                    text: cleanTitle,
                    font: UIFont(name: "pixelmix", size: 16)!,
                    leftFade: 0,
                    rightFade: 0,
                    startDelay: 2
                )
                .padding(10)
                .foregroundColor(.white)
                .background(.black)
                .padding(.top, 15)
            }
            Spacer()
            Button {
                if radio.isPlaying {
                    radio.stop()
                } else {
                    radio.play()
                }
            } label: {
                PixelButton(isPlaying: $radio.isPlaying)
                    .frame(maxWidth: 130)
            }
            Spacer()
        }
        .padding()
        .onAppear {
            radio.updateTitle()
        }
    }
}

struct NoButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

struct RadioView_Previews: PreviewProvider {
    static var previews: some View {
        let radio = Radio.shared
        radio.title = "Title"
        return RadioView(radio: radio)
    }
}
