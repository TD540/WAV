//
//  WAVShowView.swift
//  WAV
//
//  Created by thomas on 28/11/2023.
//

import SwiftUI

struct WAVShowView: View {
    var wavShow: WAVShow
    var category: WAVCategory?
    var tag: WAVTag?

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            WAVShowImage(wavShow: wavShow)

            Text(wavShow.name.uppercased())
                .wavBlack(size: 13, vPadding: 6)
                .lineSpacing(5)
                .padding(.horizontal)

            if category == nil {
                WAVShowCategories(wavShow: wavShow, hideCategory: category)
                    .padding(.horizontal)
            }

            Text(wavShow.dateFormatted.uppercased())
                .foregroundColor(.white)
                .padding(.vertical, 2)
                .padding(.horizontal, 4)
                .font(Font.custom("Helvetica Neue Medium", size: 13))
                .background(Color.black)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                if tag == nil {
                    WAVShowTags(wavShow: wavShow, hideTag: tag)
                        .padding(.horizontal)
                        .padding(.trailing, 50)
                }
            }
            .mask(
                LinearGradient(gradient: Gradient(stops: [
                    .init(color: .white, location: 0),
                    .init(color: .white, location: 0.80),
                    .init(color: .clear, location: 0.98)
                ]), startPoint: .leading, endPoint: .trailing)
                .frame(height: 100)
            )
        }
    }
}

//#Preview {
//    WAVShowView(wavShow: WAVShow.preview)
//}
