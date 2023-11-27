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
    case search = "SEARCH"
}

struct CustomTabBar: View {
    @Binding var tab: Tab
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @Environment(\.scenePhase) var scenePhase

    @State private var barOpacity = 0.0
    @State private var barOffset = 10.0
    @State private var barHeight: CGFloat? = 0.0

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Spacer()
            tabButton(.live)
            Spacer()
            tabButton(.archive)
            Spacer()
            tabButton(.search)
            Spacer()
            tabButton(.schedule)
            Spacer()
        }
        .background(.black.opacity(0.9))
        .shadow(color: .black.opacity(0.6), radius: 10, y: -20)
        .frame(maxWidth: .infinity, maxHeight: barHeight)
        .border(width: 1, edges: [.top], color: .secondary.opacity(0.3))
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                withAnimation {
                    barOpacity = 1.0
                    barOffset = 0.0
                    barHeight = nil
                }
            } else {
                withAnimation {
                    barOpacity = 0.0
                    barOffset = 6
                    barHeight = 0.0
                }
            }
        }
        .onAppear {
            barOpacity = 1.0
            barOffset = 0.0
        }
        .offset(y: barOffset)
        .opacity(barOpacity)
    }

    func tabButton(_ tab: Tab) -> some View {
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
                .padding(.top, 15)
                .padding(.horizontal, 6)
                .padding(.bottom,
                         safeAreaInsets.bottom == 0.0
                         ? 20
                         : safeAreaInsets.bottom
                )
        }

    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            CustomTabBar(tab: .constant(.search))
        }
        .background(.black)
        .edgesIgnoringSafeArea(.bottom)
    }
}
