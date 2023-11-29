//
//  PlaceholderView.swift
//  WAV
//
//  Created by thomas on 28/11/2023.
//

import SwiftUI

struct PlaceholderView: View {
    var body: some View {
        Text("NOTHING VARIOUS")
            .font(.custom("pixelmix", size: 20))
    }
}

#Preview {
    PlaceholderView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
}
