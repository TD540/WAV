//
//  Search.swift
//  WAV
//
//  Created by thomas on 11/03/2023.
//

import SwiftUI

struct Search: View {
    @State var searchQuery = ""
    @FocusState private var isFocused: Bool

    @State var validQuery: String?

    var suggestedQueries = ["LIVE FROM BOSBAR", "PODCAST", "TECHNO", "MEAKUSMA", "AMBIENT"]

    var placeholder = "SEARCH VARIOUS"

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
                    Text(placeholder)
                        .font(.custom("pixelmix", size: 16))
                        .lineLimit(1)
                        .opacity(0.5)
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
            .padding()
            .accentColor(.primary)
            .border(width: 2, edges: [.bottom], color: .primary.opacity(0.2))
            .shadow(color: .black.opacity(0.1), radius: 3, y: 3)

            if !isFocused && searchQuery.isEmpty {
                Spacer()
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
                Spacer()
            } else {

                if let validQuery = validQuery {
                    NavigationStack {
                        InfiniteView(searchQuery: validQuery)
                    }
                } else {
                    Spacer()
                    VStack {
                        Text(placeholder)
                            .font(.custom("Helvetica Neue Bold", size: 14))
                        Image("WAV")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.accentColor)
                            .scaledToFit()
                            .frame(maxWidth: 150)
                            .padding()
                    }
                    Spacer()
                }
            }
        }
        .background(.black.opacity(0.1))
        .onTapGesture {
            isFocused = false
        }
    }
}


#Preview {
    Search()
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
