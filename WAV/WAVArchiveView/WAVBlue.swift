//
//  WAVBlue.swift
//  WAV
//

import SwiftUI

struct WAVBlueModifier: ViewModifier {
    let size: CGFloat
    let padding: CGFloat
    func body(content: Content) -> some View {
        content
            .padding(.vertical, padding)
            .padding(.horizontal, 4)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .font(.custom("pixelmix", size: size))
            .lineSpacing(4)
    }
}
extension View {
    func wavBlue(size: CGFloat = 14, vPadding: CGFloat = 8) -> some View {
        self.modifier(WAVBlueModifier(size: size, padding: vPadding))
    }
}

struct WAVBlue_Previews: PreviewProvider {
    static var previews: some View {
        Text(".wavBlue(size: 20)")
            .wavBlue(size: 20)
    }
}
