//
//  SettingSubViews.swift
//  CrashBuddy
//
//  Created by Joshua An on 10/17/22.
//

import SwiftUI

struct EmergencyContactsView: View {
    var body: some View {
        NavigationView {
            Text("Emergency Contacts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Emergency Contacts").font(.headline)
                        }
                    }
                }
        }
    }
}

struct DebugView: View {

    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero

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
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
                self.mode.wrappedValue.dismiss()
            }){
                Image(systemName: "arrow.left")
            })
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Crash Sensitivity").font(.headline)
                    }
                }
            }
    }
}

struct CrashSensitivityView: View {
    var body: some View {
        NavigationView {
        
            Text("Crash Sensitivity")
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
}

struct HardwareConnectivityView: View {
    var body: some View {
        NavigationView {
            
            Text("Hardware Connectivity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Hardware Connectivity").font(.headline)
                        }
                    }
                }
        }
    }
}



