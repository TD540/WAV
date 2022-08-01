//
//  Radio.swift
//  WAV
//
//  Created by Thomas on 22/07/2022.
//

import SwiftUI

struct RadioView: View {
    @StateObject var radio = Radio.shared

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
            if let title = radio.currentShowTitle {
                let cleanTitle = title.applyingTransform(.stripDiacritics, reverse: false)!
                Text(cleanTitle)
                    .font(Font.custom("pixelmix", size: 30))
                    .lineSpacing(15)
                    .padding()
            }
        }
        .task() {
            await radio.updateCurrentShowTitle()
        }
    }
}

struct RadioView_Previews: PreviewProvider {
    static var previews: some View {
        Radio.shared.currentShowTitle = "preview title..."
        return RadioView()
    }
}
