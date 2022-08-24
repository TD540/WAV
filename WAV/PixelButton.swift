//
//  PixelButton.swift
//  WAV
//
//  Created by Thomas on 17/08/2022.
//

import SwiftUI

struct PixelButton: View {
    @Binding var isPlaying: Bool
    @State var currentGrid = [[Int]]()
    @State var transition = [[[Int]]]()
    var color = Color.accentColor
    let pauseGrid = [
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1]
    ]
    let playGrid = [
        [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
        [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    ]
    private func createRandomGrid(from firstGrid: [[Int]], and secondGrid: [[Int]]) ->  [[Int]] {
        var randomGrid = [[Int]]()
        var index = 0
        for line in firstGrid {
            var pIndex = 0
            var nextLine = [Int]()
            for pixel in line {
                let newPixel = secondGrid[index][pIndex]
                if pixel == newPixel {
                    nextLine.append(pixel)
                } else {
                    let odds = Int.random(in: 0...100)
                    nextLine.append(
                        odds < 20 ? newPixel : pixel
                    )
                }
                pIndex += 1
            }
            randomGrid.append(nextLine)
            index += 1
        }
        return randomGrid
    }
    private func newRandomTransition() -> [[[Int]]] {
        let startGrid = isPlaying ? playGrid : pauseGrid
        let endGrid = isPlaying ?  pauseGrid : playGrid
        let randomGrid1 = createRandomGrid(from: startGrid, and: endGrid)
        let randomGrid2 = createRandomGrid(from: randomGrid1, and: endGrid)
        let randomGrid3 = createRandomGrid(from: randomGrid2, and: endGrid)
        let randomGrid4 = createRandomGrid(from: randomGrid3, and: endGrid)
        let randomGrid5 = createRandomGrid(from: randomGrid4, and: endGrid)
        let randomGrid6 = createRandomGrid(from: randomGrid5, and: endGrid)
        return [
            startGrid,
            randomGrid1,
            randomGrid2,
            randomGrid3,
            randomGrid4,
            randomGrid5,
            randomGrid6,
            endGrid
        ]
    }
    var body: some View {
        VStack(spacing: 0) {
            ForEach(currentGrid, id:\.self) { line in
                HStack(spacing: 0) {
                    ForEach(line, id:\.self) { pixel in
                        Rectangle()
                            .fill(pixel == 1 ? color : .clear)
                    }
                    .aspectRatio(1, contentMode: .fit)
                }
            }
        }
        .onChange(of: isPlaying, perform: { _ in
            transition = newRandomTransition()
            var runCount = 0
            Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { timer in
                currentGrid = transition[runCount]
                runCount += 1
                if runCount == transition.count {
                    timer.invalidate()
                }
            }
        })
        .onAppear {
            currentGrid = isPlaying ? pauseGrid : playGrid
        }
    }
}

//struct PixelButton_Previews: PreviewProvider {
//    static var previews: some View {
//        PixelButton(isPlaying: false)
//    }
//}
