//
//  DebugView.swift
//  CrashBuddy
//
//  Created by Joshua An on 10/16/22
//

import SwiftUI

struct DebugView: View {
    var body: some View {


        NavigationView {
            Form {
                Section {
                    Toggle(isOn: .constant(false),
                            label: {Text("Debug")
                            })
                }

                //TODO change from toggle
                // how exactly do we determine whether this is on or not
                // Does this display only if debug mode is on? or always is it always on display
                Section {
                    Toggle(isOn: .constant(false),
                            label: {Text("Sensor Status")
                            })

                    Toggle(isOn: .constant(false),
                            label: {Text("Memory Status")
                            })

                    Toggle(isOn: .constant(false),
                            label: {Text("Power Status")
                            })
                }
            }
        }        
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Crash Sensitivity").font(.headline)
                    }
                }
            }  
    }
}
