//
//  ContentView.swift
//  WAV
//
//  Created by Thomas on 19/07/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var radio: Radio
    var body: some View {
        RadioView(radio: radio)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


