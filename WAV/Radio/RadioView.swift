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
        Group {
        VStack(spacing: 0) {
            Button {
                if radio.isPlaying {
                    radio.stop()
                } else {
                    radio.play()
                }
            } label: {
                PixelButton(isPlaying: $radio.isPlaying)

            }
            if let title = radio.title {
                let cleanTitle = title.applyingTransform(.stripDiacritics, reverse: false)!
                Text(cleanTitle)
                    .font(Font.custom("pixelmix", size: 28))
                    .lineSpacing(4)
                    .padding(.top)
            }
        }
        }
        .frame(maxWidth: 300)
        .onAppear {
            radio.updateTitle()
        }
        .onDisappear {
            radio.cancelUpdateUnlessPlaying()
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
