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
    let tabs = ["radio", "archive", "schedule", "chat"]
    var tabSelected: [Int] {
        var ts = [0, 0, 0, 0]
        ts[tab-1] = 1
        return ts
    }
    let iconHeight: CGFloat
    var color: Color {
        if colorScheme == .light {
            return .black.opacity(0.7)
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
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                return VStack {
                    Image("tab-\(tabs[index])")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: iconHeight)
                    Text("\(tabs[index].uppercased())")
                        .lineLimit(1)
                        .font(.custom("pixelmix", size: 12))
                }
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity)
                .scaleEffect(tabSelected[index] == 1 ? 1 : 0.9)
                .foregroundColor(tabSelected[index] == 1 ? selectedColor : color)
                .onTapGesture {
                    withAnimation(.linear(duration: 0.1)) {
                        tab = index + 1
                    }
                }
            }
        }
        .background(.thinMaterial)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
            CustomTabBar(tab: .constant(1), iconHeight: 30)
    }
}
