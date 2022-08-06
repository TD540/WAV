//
//  Radio.swift
//  WAV
//
//  Created by Thomas on 22/07/2022.
//

import SwiftUI

struct RadioView: View {
    @StateObject var radio: Radio

    var body: some View {
        VStack {
            Button {
                if radio.isPlaying {
                    radio.stop()
                } else {
                    radio.play()
                }
            } label: {
                Image(radio.isPlaying ? "pause" : "play")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }
            Group {
                if let title = radio.title {
                    let cleanTitle = title.applyingTransform(.stripDiacritics, reverse: false)!
                    Text(cleanTitle)
                } else {
                    Text("...")
                }
            }
            .font(Font.custom("pixelmix", size: 30))
            .lineSpacing(15)
            .padding()
        }
        .onAppear {
            radio.updateTitle()
        }
        .onDisappear {
            radio.cancelUpdateUnlessPlaying()
        }
    }
}

struct RadioView_Previews: PreviewProvider {
    static var previews: some View {
        let radio = Radio.shared
        return RadioView(radio: radio)
    }
}
