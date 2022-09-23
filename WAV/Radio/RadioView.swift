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
                        .fill(.red)
                        .aspectRatio(contentMode: .fit)
                }
            }
            if let title = radio.title {
                let cleanTitle = title.applyingTransform(.stripDiacritics, reverse: false)!
                MarqueeText(
                    text: cleanTitle,
                    font: UIFont(name: "pixelmix", size: 38)!,
                    leftFade: 0,
                    rightFade: 0,
                    startDelay: 2
                )
                .padding()
            }
            Button {
                if radio.isPlaying {
                    radio.stop()
                } else {
                    radio.play()
                }
            } label: {
                PixelButton(isPlaying: $radio.isPlaying)
                    .frame(maxWidth: 100)
            }
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
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
