//
//  LoadingView.swift
//  WAV
//
//  Created by thomas on 28/11/2023.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        Text("LOADING VARIOUS")
            .multilineTextAlignment(.center)
            .lineSpacing(10.0)
            .wavBlack() // Assuming this is a custom modifier you've defined
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LoadingView()
        .background(.black)
}
