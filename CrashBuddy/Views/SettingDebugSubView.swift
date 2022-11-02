//
//  SettingDebugSubView.swift
//  CrashBuddy
//
//  Created by Joshua An on 11/1/22.
//

import SwiftUI

struct DebugView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    @State private var debugOn = true
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $debugOn,
                           label: {Text("Debug")
                    })
                }
                
                //TODO change from toggle
                // how exactly do we determine whether this is on or not
                // Does this display only if debug mode is on? or always is it always on display
                Section {
                    Toggle(isOn: $debugOn,
                           label: {Text("Sensor Status")
                    })
                    
                    Toggle(isOn: $debugOn,
                           label: {Text("Memory Status")
                    })
                    
                    Toggle(isOn: $debugOn,
                           label: {Text("Power Status")
                    })
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Debug").font(.headline)
                }
            }
        }
    }
}
