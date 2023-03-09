//
//  CustomTabBar.swift
//  WAV
//
//  Created by Thomas on 16/01/2023.
//

import SwiftUI

enum Tab: String {
    case live = "(( LIVE ))"
    case archive = "ARCHIVE"
    case schedule = "SCHEDULE"
}

struct CustomTabBar: View {
    @Binding var tab: Tab
    @Environment(\.safeAreaInsets) var safeAreaInsets

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            tabButton(.live)
            Spacer()
            tabButton(.archive)
            Spacer()
            tabButton(.schedule)
        }
        .frame(maxWidth: .infinity)
        .background(.black)
        .border(width: 2, edges: [.top], color: .secondary.opacity(0.3))
    }

    func tabButton(_ tab: Tab) -> some View {
        let isSelected = self.tab == tab
        return Button(action: {
            withAnimation(.linear(duration: 0.05)) {
                self.tab = tab
            }
        }) {
            Text(tab.rawValue)
                .font(.custom("Helvetica Neue Medium", size: 18))
                .foregroundColor(isSelected ?  .white : .accentColor)
                .lineLimit(1)
                .minimumScaleFactor(0)
                .padding(.top)
                .padding(.horizontal, 15)
                .padding(.bottom,
                         safeAreaInsets.bottom == 0.0
                         ? 18
                         : safeAreaInsets.bottom
                )
        }

    }
}


struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            CustomTabBar(tab: .constant(.live))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
