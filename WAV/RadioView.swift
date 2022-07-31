//
//  Radio.swift
//  WAV
//
//  Created by Thomas on 22/07/2022.
//

import SwiftUI

struct RadioView: View {
    @StateObject var radio = Radio.shared
    @State var title: String?

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
            if (title != nil) {
                Text(title!)
                    .font(Font.custom("pixelmix", size: 30))
                    .lineSpacing(15)
                    .padding()
            }
        }
        .task() {
            title = await RadioState.title()
        }
    }
}

struct RadioView_Previews: PreviewProvider {
    static var previews: some View {
        RadioView(title: "preview title")
    }
}
