//
//  ContentView.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 9/12/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack() {
                NavigationLink(
                    destination: SettingsView(),
                    label: {
                        SettingsButton()
                    }
                )
                
                NavigationLink(
                    destination: ActivityLogView(),
                    label: {
                        ActivityLogButton()
                            
                    }
                )
            }
            .navigationTitle("Home")
        }
    }
}

struct SettingsButton: View {
    var body: some View {
        Text("Settings")
            .padding()
            .frame(width: /*@START_MENU_TOKEN@*/300.0/*@END_MENU_TOKEN@*/, height: 50.0)
    }
}

struct ActivityLogButton: View {
    var body: some View {
        Text("Show More")
            .padding()
            .frame(width: /*@START_MENU_TOKEN@*/300.0/*@END_MENU_TOKEN@*/, height: 50.0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
