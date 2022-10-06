//
//  RadioView.swift
//  WAV
//
//  Created by Thomas on 22/07/2022.
//

import SwiftUI
import MarqueeText

struct RadioView: View {
    @StateObject var radio: Radio
    var body: some View {
        VStack {
            if let artURL = radio.artURL {
                AsyncImage(url: artURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Rectangle()
                        .fill(Color.secondary.opacity(0.2))
                        .scaledToFit()
                }
                .shadow(radius: 25)
                .padding()
            }
            if let title = radio.title {
                let cleanTitle = title.applyingTransform(.stripDiacritics, reverse: false)!
                MarqueeText(
                    text: cleanTitle,
                    font: UIFont(name: "pixelmix", size: 16)!,
                    leftFade: 0,
                    rightFade: 0,
                    startDelay: 2
                )
                .foregroundColor(.accentColor)

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
                    .frame(maxWidth: 150)
            }
            Spacer()
        }
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
        radio.title = "This is a very very very very very very long title"
        return RadioView(radio: radio)
    }
}
