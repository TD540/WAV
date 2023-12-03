//
//  TempView.swift
//  WAV
//
//  Created by thomas on 03/12/2023.
//

import SwiftUI

struct TempView: View {
    var body: some View {
        ZStack {
            Text("Top Text")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            Text("Left Text")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            Text("Bottom Text")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            Text("Right Text")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        }
    }
}


#Preview {
    TempView()
}
