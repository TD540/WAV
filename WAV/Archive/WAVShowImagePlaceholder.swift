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
        Rectangle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [Color.accentColor.opacity(0.5), Color.accentColor.opacity(0.0)]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 300
                )
            )
            .background(.black)
            .overlay(
                VStack {
                    Image("WAV")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.accentColor.opacity(0.3))
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                    ProgressView(value: loaded, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle())
                }
                .scaleEffect(0.5)
            )
    }
}

#Preview {
    WAVShowImagePlaceholder(loaded: 0.5)
        .aspectRatio(100/66.7, contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
}
