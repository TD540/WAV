//
//  WebPlayerView.swift
//  WeAreVarious
//
//  Created by Thomas on 16/04/2021.
//

import SwiftUI
import WebView

struct WebPlayerView: View {
    @StateObject private var viewModel: ViewModel
    @Environment(\.colorScheme) var colorScheme

    init(archiveDataController: ArchiveDataController) {
        let viewModel = ViewModel(archiveDataController: archiveDataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            WebView(webView: viewModel.webViewStore.webView)
                .frame(width: 0, height: 0)
                .onChange(of: viewModel.playingRecord, perform: viewModel.onPlayingRecordChanging)

            HStack {
                Spacer()
                if let playingRecord = viewModel.playingRecord {
                    playingView(playingRecord: playingRecord)
                }
                Spacer()
            }
            .background(
                backgroundView()
            )
        }
    }

    func backgroundView() -> some View {
        ZStack {
            BlurView(style: .systemUltraThinMaterial)
            if viewModel.playingRecord != nil {
                if colorScheme == .light {
                    Color("Pink")
                        .blendMode(.multiply)
                } else {
                    Color.accentColor
                        .blendMode(.multiply)
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    func notPlayingView() -> some View {
        Text("WE ARE VARIOUS")
            .multilineTextAlignment(.center)
            .font(Font.custom("pixelmix", size: 16))
            .lineSpacing(16)
            .padding()
    }

    func playingView(playingRecord: WAVPost) -> some View {
        VStack {
            Button(action: viewModel.playToggle) {
                RecordView(pictureURL: playingRecord.pictureURL)
            }
            .frame(width: 256, height: 128)
            .buttonStyle(RotatingButtonStyle(isRotating: viewModel.isPlaying))
            .rotation3DEffect(.degrees(30), axis: (x: 0.1, y: 0, z: 0), perspective: 0.5)
            .shadow(color: .black.opacity(0.6), radius: 10, x: 0.0, y: 15.0)

            Text(playingRecord.name)
                .foregroundColor(.white)
                .textCase(.uppercase)
                .multilineTextAlignment(.center)
                .font(Font.custom("pixelmix", size: 10))
                .lineSpacing(8)
                .padding(10)
                .shadow(color: .black, radius: 5, x: 0, y: 5)
        }
    }
}

struct WebPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        WAVPost.autoplay = false
        return VStack {
            Spacer()
            WebPlayerView(archiveDataController: ArchiveDataController())
        }
        // .preferredColorScheme(.dark)
    }
}
