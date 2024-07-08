//
//  WAVPlaceholderView.swift
//  WAV
//

import SwiftUI

struct WAVPlaceholderView: View {
    var body: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaledToFit()
    }
}

struct Placeholder_Previews: PreviewProvider {
    static var previews: some View {
        WAVPlaceholderView()
    }
}
