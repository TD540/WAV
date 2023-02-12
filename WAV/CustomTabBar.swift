//
//  CustomTabBar.swift
//  WAV
//
//  Created by Thomas on 16/01/2023.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var tab: Int

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    let tabs = ["radio", "archive", "schedule"] //, "chat"]
    let iconHeight: CGFloat

    // Computed properties
    var tabSelected: [Int] {
        var ts = [0, 0, 0, 0]
        ts[tab-1] = 1
        return ts
    }
    var color: Color {
        if colorScheme == .light {
            return .black.opacity(0.6)
        } else {
            return .white.opacity(0.5)
        }
    }
    var selectedColor: Color {
        if colorScheme == .light {
            return Color("WAVBlue")
        } else {
            return .white
        }
    }

    var body: some View {
        HStack(spacing: 15) {
            ForEach(0..<tabs.count, id: \.self) { index in
                let isSelected = tabSelected[index] == 1
                Text("\(tabs[index].uppercased())")
                    .lineLimit(1)
                    .font(.custom("pixelmix", size: 22))
                    .shadow(color: isSelected ? .accentColor.opacity(0.3) : .black.opacity(0.4), radius: isSelected ? 2.0 : 5.0, y: isSelected ? 5 : 10)
                    .foregroundColor(isSelected ? selectedColor : color)
                    .onTapGesture {
                        withAnimation(.linear(duration: 0.1)) {
                            tab = index + 1
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 15)
        .padding(.bottom, safeAreaInsets.bottom == 0.0 ? 20 : safeAreaInsets.bottom)
        .background(.regularMaterial)
        .border(width: 1, edges: [.top], color: .secondary.opacity(0.2))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(
            tab: .constant(1),
            iconHeight: 50)
    }
}
