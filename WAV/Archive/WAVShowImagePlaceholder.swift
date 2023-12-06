//
//  WAVShowImagePlaceholder.swift
//  WAV
//
//  Created by thomas on 30/11/2023.
//

import SwiftUI

import SwiftUI

struct WAVShowImagePlaceholder: View {
    let loaded: CGFloat
    var body: some View {
        Color.gray.opacity(0.15)
            .overlay(
                VStack(spacing: 30) {
                    Image("WAV")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color.accentColor)
                    ProgressView(value: loaded, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle())
                }
                .padding(60)
            )
    }
}

#Preview {
    WAVShowImagePlaceholder(loaded: 0.5)
        .aspectRatio(100/66.7, contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
}
