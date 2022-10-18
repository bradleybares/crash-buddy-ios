//
//  SettingSubViews.swift
//  CrashBuddy
//
//  Created by Joshua An on 10/17/22.
//

import SwiftUI

struct EmergencyContactsView: View {
    var body: some View {
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

struct CrashSensitivityView: View {
    var body: some View {
        
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

struct HardwareConnectivityView: View {
    var body: some View {
        
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

struct SportsView: View {
    
    @State private var sport: Sport = Sport(name: "Skiing")
    @State private var crash_sensitivity: Int = 100
    @State private var showingAlert = false
    @State private var addedSport = ""
    
    @State var sports = [
        Sport(name: "Skiing"),
        Sport(name: "Biking"),
        Sport(name: "Snowboarding")
    ]
    
    func addSport(name: String) {
        sports.append(Sport(name: name))
    }
    
    var body: some View {
        
        Form {
            Section {
                ForEach(sports, id: \.self) {
                    Text($0.name)
                }
                .swipeActions(edge: .leading) {
                    Button("Edit") {
                        print("Edit")
                    }
                    .tint(.blue)
                    Button("Delete", role: .destructive) {
                        print("Delete")
                    }
                }
            }
        }
        
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Sports").font(.headline)
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Add") {
                        showingAlert = true
                    }
                    .alert("Add Sport", isPresented:$showingAlert, actions:
                            
                        {
                        TextField("", text: $addedSport)
                        Button("Cancel", role: .cancel, action: {})
                        Button("Add", action: {
                            addSport(name: addedSport)
                        })
                    })
                    
                }
            }
    }
}


