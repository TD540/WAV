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
        VStack(alignment: .center) {
            Image("WAVLogo")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(.accentColor)
                .scaledToFit()
                .padding()


            Button {
                dataController.radioIsPlaying == false ?
                dataController.playRadio() :
                dataController.stopRadio()
            } label: {
                WAVGlobe(
                    isPlaying: $dataController.radioIsPlaying,
                    isLive: .constant(dataController.radioIsOffAir == false)
                )
                .overlay {
                    Circle()
                        .fill(
                            colorScheme == .light ?
                                .white.opacity(0.6) :
                                    .black.opacity(0.6)
                        )
                        .scaleEffect(0.65)
                }
                .overlay {
                    PixelButton(isPlaying: Binding { dataController.radioIsPlaying })
                        .scaleEffect(0.25)
                }
            }

        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
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
