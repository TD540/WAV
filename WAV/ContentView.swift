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
                    Image(systemName: "radio")
                    Text("Radio")
                }
            WeekSchedule()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Week Schedule")
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


