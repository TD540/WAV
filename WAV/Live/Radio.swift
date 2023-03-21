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

    @State private var tapped = false

    var body: some View {
        VStack(alignment: .center) {
            Image("WAVLogo")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(.accentColor)
                .scaledToFit()
                .padding()

            Spacer()

            WAVGlobe(
                isPlaying: $dataController.radioIsPlaying,
                isLive: .constant(dataController.radioIsOffAir == false)
            )
            .scaleEffect(tapped ? 1 : 0.98)
            .foregroundColor(.accentColor)
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
                if dataController.radioIsOffAir {
                    Text("OFF AIR")
                        .font(.custom("pixelmix", size: 12))
                        .padding(4)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                } else {
                    PixelButton(isPlaying: Binding { dataController.radioIsPlaying })
                        .scaleEffect(0.25)
                }

            }
            .padding(30)
            .onTapGesture {
                if dataController.radioIsOffAir == false || dataController.DEBUG_radio {
                    withAnimation(.spring()) {
                        tapped = true
                    }
                    dataController.radioIsPlaying == false ?
                    dataController.playRadio() :
                    dataController.stopRadio()
                    tapped = false
                }
            }

            Spacer()

        }
        .padding(30)
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
