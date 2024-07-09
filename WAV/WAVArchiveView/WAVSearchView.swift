//
//  WAVSearchView.swift
//

import SwiftUI

struct WAVSearchView: View {
    @EnvironmentObject var dataController: DataController
    @State var searchQuery = ""
    @FocusState private var isFocused: Bool

    @State var validQuery: String?

    var suggestedQueries = ["FOCUS ON", "AMBIENT", "LIVE FROM BOSBAR ", "PLUS-ONE GALLERY", "DISCO", "INTERNATIONAL GUESTS"]

    func reset() {
        searchQuery = ""
        validQuery = nil
    }

    func performSearch(with query: String) {
        if query.isEmpty {
            reset()
            return
        }
        if query.rangeOfCharacter(from: .letters) == nil {
            reset()
            return
        }
        validQuery = String("\"\(query)\"").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }

    var body: some View {
        VStack(spacing: 0) {

            // Field
            HStack(spacing: 20) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 25, height: 25)
                TextField("", text: $searchQuery) {
                    performSearch(with: searchQuery)
                }
                .disableAutocorrection(true)
                .keyboardType(.webSearch)
                .autocapitalization(.allCharacters)
                .focused($isFocused)
                .font(.custom("pixelmix", size: 18))
                .foregroundStyle(.white)
                .placeholder(when: searchQuery.isEmpty && !isFocused) {
                    Text("SEARCH VARIOUS")
                        .font(.custom("pixelmix", size: 16))
                        .lineLimit(1)
                }
                if !searchQuery.isEmpty {
                    Button {
                        reset()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                }
            }
            .padding(.top, Constants.marqueeHeight)
            .onTapGesture {
                isFocused = true
            }
            .padding(20)
            .accentColor(.white)
            .foregroundStyle(.white)
            .background(.black)
            .border(width: 2, edges: [.bottom], color: .white.opacity(0.2))

            if let validQuery = validQuery {
                NavigationStack {
                    WAVArchiveView(searchQuery: validQuery, topPadding: 20)
                }
            } else {
                VStack(spacing: 20) {
                    Text("VARIOUS SUGGESTIONS")
                        .font(.custom("Helvetica Neue Bold", size: 14))
                        .foregroundStyle(.white)
                    ForEach(suggestedQueries, id: \.self) { listQuery in
                        Button(listQuery) {
                            searchQuery = listQuery
                            performSearch(with: searchQuery)
                        }
                    }
                    .font(.custom("pixelmix", size: 18))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom,
                         dataController.selectedShow != nil ?
                         dataController.selectedShow!.isSoundcloud ? 100 : 60 : 0
                )
                .background(.black)
                .onTapGesture {
                    isFocused = false
                }
            }
        }

    }
}


#Preview {
    WAVSearchView()
        .environmentObject(DataController())
        .background(.black)
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
