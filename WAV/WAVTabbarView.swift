//
//  WAVTabbarView.swift
//

import SwiftUI

struct WAVTabbarView: View {
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @Environment(\.scenePhase) var scenePhase
    
    @Binding var tab: tab
    enum tab: String {
        case live = "LIVE"
        case waves = "WAVES"
        case archive = "ARCHIVE"
        case schedule = "SCHEDULE"
        case search = "SEARCH"
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Spacer()
            tabButton(.live)
            Spacer()
            tabButton(.waves)
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

    func tabButton(_ tab: tab) -> some View {
        let isSelected = self.tab == tab
        return Button(action: {
            withAnimation(.linear(duration: 0.05)) {
                self.tab = tab
            }
        }) {
            Text(tab.rawValue)
                .font(.custom("Helvetica Neue Medium", size: 14))
                .foregroundColor(isSelected ?  .white : .accentColor)
                .lineLimit(1)
                .minimumScaleFactor(0)
                .padding(.top, 20)
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
        WAVTabbarView(tab: .constant(.archive))
    }
    .background(.black.opacity(0.6))
}
