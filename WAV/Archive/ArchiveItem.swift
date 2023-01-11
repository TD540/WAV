//
//  ArchiveItem.swift
//  WAV
//
//  Created by Thomas on 27/12/2022.
//

import SwiftUI

struct ArchiveItem: View {
    @Environment(\.colorScheme) var colorScheme
    var infiniteViewModel: InfiniteView.ViewModel
    let index: Int
    var wavShow: WAVShow {
        infiniteViewModel.wavShows[index]
    }
    var isPlayingBinding: Binding<Bool> {
        Binding {
            wavShow == infiniteViewModel.archiveDataController.state.selectedShow
            &&
            infiniteViewModel.archiveDataController.state.isPlaying
        } set: { _ in }
    }
    let spacing: Double = 5
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Button {
                if infiniteViewModel.archiveDataController.state.selectedShow != wavShow {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    infiniteViewModel.archiveDataController.state.selectedShow = wavShow
                    print("WAV: now loading \(wavShow.mixcloudWidget)")
                } else {
                    infiniteViewModel.archiveDataController.state.playPause.toggle()
                }
            } label: {
                image()
            }
            archiveItemInfo()
        }
    }
    func image() -> some View {
        ZStack {
            AsyncImage(url: wavShow.pictureURL) { image in
                image
                    .centerCropped()
                    .aspectRatio(100/66.7, contentMode: .fit)
                    .overlay {
                        PixelButton(isPlaying: isPlayingBinding)
                            .blendMode(.hardLight)
                            .frame(maxWidth: 60, maxHeight: 90)
                    }
            } placeholder: {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(1.5, contentMode: .fit)
                    .background(.black.opacity(0.1))
            }
        }
    }
    func archiveItemInfo() -> some View {
        VStack(alignment: .leading, spacing: spacing) {
            Group {
                Group {
                    Text(wavShow.name.uppercased())
                }
                .frame(alignment: .leading)
                .padding(8)
                .foregroundColor(.white)
                .background(.black)
                Text(wavShow.dateFormatted.uppercased())
                    .padding(.horizontal, 8)
            }
            .lineSpacing(8)
            .font(.custom("pixelmix", size: 14))
        }
    }
}

struct ArchiveItem_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveItem(
            infiniteViewModel: InfiniteView.ViewModel.preview,
            index: 0
        )
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white.opacity(0.15))
        .preferredColorScheme(.dark)
    }
}
