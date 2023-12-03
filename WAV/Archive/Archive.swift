//
//  ArchiveView.swift
//  WAV
//
//  Created by thomas on 11/03/2023.
//

import SwiftUI

struct Archive: View {
    var body: some View {
        NavigationStack {
            InfiniteView(topPadding: Constants.marqueeHeight + 20)
        }
    }
}

struct Archive_Previews: PreviewProvider {
    static var previews: some View {
        Archive()
            .environmentObject(DataController())
    }
}
