//
//  SettingsView.swift
//  CrashBuddy
//
//  Edited by Joshua An on 10/16/22.
//

import SwiftUI

struct Sport: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

struct SettingsView: View {

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
        NavigationView {
            Form {
                Section {
                    // Debug Mode
                    NavigationLink(destination: DebugView(), label: {
                        Text("Debug Mode")

                    }
                    )
                    
                    // Sports
                    Picker(selection: $sport, label: Text("Sports")) {
                        // TODO add button here and add logic here
                        ForEach(sports, id: \.self) {
                            Text($0.name)
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
                    
                    
                    // Crash Sensitivity
                    Picker(selection: $crash_sensitivity, label: Text("Crash Sensitivity")) {
                        // TODO add button here and add logic here
                        
                    }
                    
                    // Emergency Contacts
                    NavigationLink(destination: EmergencyContactsView(), label: {
                        Text("Emergency Contacts")
                    }
                    )
                    
                    // "Hardware Connectivity
                    NavigationLink(destination: HardwareConnectivityView(), label: {
                        Text("Hardware Connectivity")

                    }
                    )
                    
                }.navigationTitle(Text("Settings"))
            }
            
        }
    }
}

