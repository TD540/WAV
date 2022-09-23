//
//  RadioView.swift
//  WAV
//
//  Created by Thomas on 22/07/2022.
//

import SwiftUI

struct RadioView: View {
    @StateObject var radio: Radio
    var body: some View {
        VStack {
            if let artURL = radio.artURL {
                AsyncImage(url: artURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {}
            }
            if let title = radio.title {
                let cleanTitle = title.applyingTransform(.stripDiacritics, reverse: false)!
                Text(cleanTitle)
                    .font(Font.custom("pixelmix", size: 28))
                    .lineSpacing(4)
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
