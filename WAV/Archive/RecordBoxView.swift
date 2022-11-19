//
//  RecordBoxView.swift
//  Shared
//
//  Created by Thomas Decrick on 17/01/2021.
//

import SwiftUI

struct RecordBoxView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @ObservedObject private var viewModel: ViewModel
    init(dataController: DataController) {
        viewModel = ViewModel(dataController: dataController)
    }
    var body: some View {
        GeometryReader { scrollGeometryProxy in
            let scrollHeight = scrollGeometryProxy.size.height
            let skipLine = scrollGeometryProxy.size.height / 5
            ScrollViewReader { scrollViewProxy in
                ScrollView(showsIndicators: false) {
                    Color.clear // used as "inner padding", and pushes albums up
                        .frame(height: skipLine * 3.7)
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.records.indices, id: \.self) { index in
                            let record = viewModel.records[index]
                            let isFirstRecord = index == 0
                            GeometryReader { coverGeometryProxy in
                                let coverFrame = coverGeometryProxy.frame(in: .named("scrollViewSpace"))
                                let state: CoverViewButtonStyle.State =
                                    coverFrame.minY > skipLine ? .skipped :
                                    coverFrame.maxY >= skipLine && coverFrame.minY < skipLine ? .selected :
                                    coverFrame.maxY < skipLine && !isFirstRecord ? .preSelected :
                                    isFirstRecord ? .selected : .skipped
                                let buttonStyle = CoverViewButtonStyle(
                                    pictureURL: record.pictureURL,
                                    index: index,
                                    state: state,
                                    coverGeometryProxy: coverGeometryProxy
                                )
                                CoverView(
                                    pictureURL: record.pictureURL,
                                    buttonStyle: buttonStyle
                                ) {
                                    if state == .selected {
                                        viewModel.play(record)
                                    } else { // scroll record into position
                                        let coverHeight = coverGeometryProxy.size.height
                                        let yPosition = (1 - skipLine / scrollHeight) - (coverHeight / scrollHeight)
                                        withAnimation {
                                            scrollViewProxy.scrollTo(index, anchor: UnitPoint(x: 0, y: yPosition))
                                        }
                                    }
                                }
                                .onAppear(perform: viewModel.records.last == record ? viewModel.loadNext : nil)
                            }
                            .rotationEffect(.degrees(180))
                            .aspectRatio(8, contentMode: .fit)
                            .zIndex(Double(viewModel.records.count - index))
                        }
                    }
                    .frame(maxWidth: 500)
                    Color.clear.aspectRatio(1.7, contentMode: .fit) // PADDING
                }
                .rotationEffect(.degrees(180))
            }
        }
        .background(backgroundView)
        .edgesIgnoringSafeArea(.all)
        .coordinateSpace(name: "scrollViewSpace")
        .onAppear(perform: viewModel.loadNext)
    }
    var backgroundView: some View {
        LinearGradient(
            gradient:
                Gradient(
                    stops:
                        colorScheme == .light ?
                        [.init(color: Color.white, location: 0.5),
                         .init(color: Color("Pink"), location: 1)]
                        :
                        [.init(color: .white.opacity(0.17), location: 0.5),
                         .init(color: .white.opacity(0.0), location: 1)]
                ),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct CoverView: View {
    let pictureURL: URL?
    let buttonStyle: CoverViewButtonStyle
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if let pictureURL = pictureURL {
                    AsyncImage(url: pictureURL) { image in
                        image
                            .resizable()
                    } placeholder: {
                        Color.white
                    }
                    .aspectRatio(contentMode: .fill)
                    .background(Color.white.padding(2))
                } else {
                    Image("WAVRecord")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
        }
        .buttonStyle(buttonStyle)
    }
}

struct CoverViewButtonStyle: ButtonStyle {
    enum State {
        case preSelected, selected, skipped
    }
    let pictureURL: URL?
    let index: Int
    let state: State
    let coverGeometryProxy: GeometryProxy
    var minY: CGFloat {
        coverGeometryProxy.frame(in: .named("scrollViewSpace")).minY
    }
    var height: CGFloat {
        coverGeometryProxy.size.height
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        ZStack {
            RecordView(pictureURL: pictureURL)
                .offset(x: state == .selected ? 40 : 0)
            configuration.label
        }
        .overlay( // Shading
            state == .selected ? nil :
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(
                            color: Color.black.opacity(0.1),
                            location: 0
                        ),
                        .init(
                            color: Color.black.opacity(0.6),
                            location: 0.3
                        )
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
        )
        .padding(.horizontal, 40)
        .rotationEffect(
            Angle(degrees: state == .selected ? -1 : 0),
            anchor: .bottomLeading
        )
        .rotation3DEffect(
            .degrees(
                state == .preSelected ? -Double(minY / 4) :
                    state == .selected ? -Double(minY / 5) :
                    -Double(minY / 3).clamped(to: 0.0...75.0) // skipped
            ),
            axis: (x: 1, y: 0, z: 0),
            anchor: .bottom,
            anchorZ: 28,
            perspective: 0.2
        )
        .offset(x: state == .selected ? -10 : 0)
        .offset(y: state == .skipped ? height * 1.5  : 0)
        .offset(y: configuration.isPressed && state != .selected ? -40 : 0)
        .onChange(of: state == .skipped) { _ in
            UISelectionFeedbackGenerator().selectionChanged()
        }
        .animation(.default, value: state)
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

struct RecordBoxView_Previews: PreviewProvider {
    static var previews: some View {
        RecordBoxView(dataController: DataController(disableAPI: true))
            .preferredColorScheme(.light)
    }
}
