//
//  PlaceholderView.swift
//  WAV
//
//  Created by thomas on 28/11/2023.
//

import SwiftUI

struct PlaceholderView: View {
    var body: some View {
        Text("Stay tuned, we'll be right back.")
            .multilineTextAlignment(.center)
            .lineSpacing(10.0)
            .wavBlack() // Assuming this is a custom modifier you've defined
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    PlaceholderView()
        .background(.black)
}
