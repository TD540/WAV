//
//  View-fadeIn.swift
//  WAV
//

import SwiftUI

import SwiftUI
struct FadeInModifier: ViewModifier {
    @State private var opacity: Double = 0

    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .onAppear {
                withAnimation {
                    opacity = 1
                }
            }
    }
}

extension View {
    func fadeIn() -> some View {
        modifier(FadeInModifier())
    }
}



struct View_fadeIn: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct View_fadeIn_Previews: PreviewProvider {
    static var previews: some View {
        View_fadeIn()
            .fadeIn()
    }
}
