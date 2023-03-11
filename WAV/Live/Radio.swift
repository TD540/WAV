//
//  RadioView.swift
//  WAV
//
//  Created by Thomas on 22/07/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct Radio: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            Image("WAVLogo")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.accentColor)
                .scaledToFit()
                .padding()
                .padding(.horizontal, 30)

            if dataController.radioIsOffAir == false || dataController.DEBUG_radio {
                Button {
                    dataController.radioIsPlaying == false ?
                    dataController.playRadio() :
                    dataController.stopRadio()
                } label: {
                    PixelButton(isPlaying: Binding { dataController.radioIsPlaying })
                }
                .shadow(color: .black.opacity(0.1), radius: 3, y: 7)
                .padding()
            }
        }
        .padding()
        .onReceive(dataController.radioPlayer.$isPlaying) { isPlaying in
            dataController.radioIsPlaying = isPlaying
        }
    }
}

struct NoButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

struct Radio_Previews: PreviewProvider {
    static var previews: some View {
        let dataController = DataController()
        // radio.artURL = URL(string: "https://thumbnailer.mixcloud.com/unsafe/288x288/extaudio/5/4/b/2/b201-d6f9-4688-b1e5-efcc63dc8100")
        dataController.radioTitle = "Title"
        return Radio()
            .environmentObject(dataController)
    }
}
