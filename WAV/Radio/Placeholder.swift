//
//  Placeholder.swift
//  WAV
//
//  Created by Thomas on 16/11/2022.
//

import SwiftUI

struct Placeholder: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.accentColor)
                .scaledToFit()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
        }
    }
}

struct Placeholder_Previews: PreviewProvider {
    static var previews: some View {
        Placeholder()
    }
}
