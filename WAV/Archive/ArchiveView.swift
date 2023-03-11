//
//  ArchiveView.swift
//  WAV
//
//  Created by thomas on 11/03/2023.
//

import SwiftUI

struct ArchiveView: View {
    var body: some View {
        NavigationStack {
            InfiniteView()
        }
    }
}

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView()
            .environmentObject(DataController())
    }
}
