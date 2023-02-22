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

    // Computed properties
    var tabSelected: [Int] {
        var ts = [0, 0, 0]
        ts[tab-1] = 1
        return ts
    }

    var body: some View {
        HStack(alignment: .center, spacing: 5) {

            ForEach(0..<tabs.count, id: \.self) { index in
                let isSelected = tabSelected[index] == 1
                Button("\(tabs[index].uppercased())") {
                    withAnimation(.linear(duration: 0.05)) {
                        tab = index + 1
                    }
                }
                .minimumScaleFactor(0.3)
                .foregroundColor(
                    isSelected ? .accentColor
                    : colorScheme == .dark ? .white : .black
                )
                .lineLimit(1)
                .font(.custom("pixelmix", size: isSelected ? 25 : 15))
                .offset(y: isSelected ? 0 : 2)
                .padding(.top, 15)
                .padding(.horizontal, 10)
                .padding(.bottom,
                         safeAreaInsets.bottom == 0.0
                         ? 20
                         : safeAreaInsets.bottom
                )
            }
        }
        .frame(maxWidth: .infinity)
        .background(Material.thick)
        .border(width: 1, edges: [.top], color: .secondary.opacity(0.3))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(tab: .constant(1))
    }
}
