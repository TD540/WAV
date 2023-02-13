//
//  Globe.swift
//  WAV
//
//  Created by Thomas on 16/11/2022.
//

import SwiftUI

struct RadioViewHeader: View {
    var body: some View {
        Image("WAVLogo")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(.accentColor)
            .scaledToFit()
            .padding()
    }
}

struct RadioViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        RadioViewHeader()
    }
}
