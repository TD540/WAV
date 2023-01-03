//
//  ArchiveItem.swift
//  WAV
//
//  Created by Thomas on 27/12/2022.
//

import SwiftUI

struct ArchiveItem: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var infiniteViewModel: InfiniteView.ViewModel
    let index: Int
    var record: WAVPost {
        infiniteViewModel.records[index]
    }
    var isPlayingBinding: Binding<Bool> {
        Binding {
            record == infiniteViewModel.archiveDataController.state.selectedPost
            &&
            infiniteViewModel.archiveDataController.state.isPlaying
        } set: { _ in }
    }
    let spacing: Double = 5
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Button {
                infiniteViewModel.play(infiniteViewModel.records[index])
            } label: {
                archiveItemButtonLabel()
            }
            archiveItemInfo()
        }
    }
    func archiveItemButtonLabel() -> some View {
        ZStack {
            AsyncImage(url: record.pictureURL) { image in
                image
                    .centerCropped()
                    .aspectRatio(100/66.7, contentMode: .fit)
            } placeholder: {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(1.5, contentMode: .fit)
                    .background(.black.opacity(0.1))
            }

//            BlurView(style: .systemThinMaterial)
//                .mask {
//                    PixelButton(isPlaying: isPlayingBinding)
//                }
//                .opacity(0.9)
//                .frame(maxWidth: 100)

            PixelButton(isPlaying: isPlayingBinding)
                .frame(maxWidth: 150)
                .blendMode(.colorBurn)

        }
    }
    func archiveItemInfo() -> some View {
        VStack(alignment: .leading, spacing: spacing) {
            Group {
                Text(record.name.uppercased())
                    .frame(alignment: .leading)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(colorScheme == .dark ? Color.accentColor : .black)
                Text(record.dateFormatted.uppercased())
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
    }
}

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
    }
}
