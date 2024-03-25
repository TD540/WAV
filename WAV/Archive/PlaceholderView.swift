//
//  PlaceholderView.swift
//  WAV
//
//  Created by thomas on 28/11/2023.
//

import SwiftUI

struct PlaceholderView: View {
    var message = "NOTHING VARIOUS"
    var body: some View {
        Text(message)
            .font(.custom("pixelmix", size: 20))
    }
}

#Preview {
    PlaceholderView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
}
