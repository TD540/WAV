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
        TabView {
            RadioView(radio: radio)
                .tabItem {
                    Label("Radio", systemImage: "radio")
                }
            WeekSchedule()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
            Text("Coming (back) soon")
                .tabItem {
                    Label("Archive", systemImage: "waveform.path")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Radio.shared)
    }
}


