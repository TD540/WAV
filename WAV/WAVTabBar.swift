//
//  WAVTabBar.swift
//  WAV
//
//  Created by Thomas on 16/01/2023.
//

import SwiftUI

enum WAVTab: String {
    case live = "(( LIVE ))"
    case archive = "ARCHIVE"
    case schedule = "SCHEDULE"
    case search = "SEARCH"
}

struct WAVTabBar: View {
    @Binding var tab: WAVTab
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Spacer()
            tabButton(.live)
            Spacer()
            tabButton(.archive)
            Spacer()
            tabButton(.schedule)
            Spacer()
            tabButton(.search)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background {
            ZStack {
                BlurView(style: .dark)
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.black.opacity(0.1), location: 0.0),
                        .init(color: Color.black.opacity(0.8), location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
        .border(width: 1, edges: [.top], color: .white.opacity(0.2))
    }

    func tabButton(_ tab: WAVTab) -> some View {
        let isSelected = self.tab == tab
        return Button(action: {
            withAnimation(.linear(duration: 0.05)) {
                self.tab = tab
            }
        }) {
            Text(tab.rawValue)
                .font(.custom("Helvetica Neue Medium", size: 16))
                .foregroundColor(isSelected ?  .white : .accentColor)
                .lineLimit(1)
                .minimumScaleFactor(0)
                .padding(.top, 20)
                .padding(.horizontal, 6)
                .padding(.bottom,
                         safeAreaInsets.bottom == 0.0
                         ? 20 : safeAreaInsets.bottom
                )
                .padding(.bottom, 5)
        }
    }
}

#Preview {
    VStack {
        Spacer()
        WAVTabBar(tab: .constant(.archive))
    }
    .background(.black.opacity(0.6))
}
