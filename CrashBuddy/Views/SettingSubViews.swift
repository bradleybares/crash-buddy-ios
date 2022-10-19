//
//  SettingSubViews.swift
//  CrashBuddy
//
//  Created by Joshua An on 10/17/22.
//

import SwiftUI

struct Sport: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

struct EmergencyContact: Identifiable, Hashable {
    let id = UUID()
    
    let name: String
    let phoneNumber: String
    let address: String
    let relationship: String
}

struct EmergencyContactsView: View {
    
    @State var contacts = [
        EmergencyContact(name: "Contact 1", phoneNumber: "1234567689", address: "Address 1", relationship: "Friend"),
        EmergencyContact(name: "Contact 2", phoneNumber: "1112223333", address: "Address 2", relationship: "Sibling"),
        EmergencyContact(name: "Contact 3", phoneNumber: "4445556666", address: "Address 3", relationship: "Mother")
    ]
    //@State private var contact: EmergencyContact = contacts[0]
    @State private var showingAlert = false
    @State private var addedName = ""
    @State private var addedPhoneNumber = ""
    @State private var addedAddress = ""
    @State private var addedRelationship = ""
    
    
    func addContact(name: String, phoneNumber: String, address: String, relationship: String) {
        contacts.append(EmergencyContact(name: name, phoneNumber: phoneNumber, address: address, relationship: relationship))
    }
    
    var body: some View {
        Form {
            Section {
                ForEach(contacts, id: \.self) {
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
                        Text("Emergency Contacts").font(.headline)
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Add") {
                        showingAlert = true
                    }
                    .alert("Add Emergency Contact", isPresented:$showingAlert, actions:
                            
                        {
                        TextField("Name", text: $addedName)
                        TextField("Phone Number", text: $addedPhoneNumber)
                        TextField("Address", text: $addedAddress)
                        TextField("Relationship", text: $addedRelationship)

                        Button("Cancel", role: .cancel, action: {})
                        Button("Add", action: {
                            addContact(name: addedName, phoneNumber: addedPhoneNumber, address: addedAddress, relationship: addedRelationship)
                            addedName = ""
                            addedPhoneNumber = ""
                            addedAddress = ""
                            addedRelationship = ""
                        })
                        
                    })
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

    @State private var sensitivity = 100
    @State private var showingAlert = false
    @State private var addedSensitivity = ""
    
    @State var sensitivities = ["0", "50", "100"]
    
    func addSensitivity(sensitivity: String) {
        sensitivities.append(sensitivity)
    }
    var body: some View {
        
        Form {
            Section {
                ForEach(sensitivities, id: \.self) {
                    Text($0)
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
                        Text("Crash Sensitivity").font(.headline)
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Add") {
                        showingAlert = true
                    }
                    .alert("Add Crash Sensitivity in G", isPresented:$showingAlert, actions:
                            
                        {
                        TextField("Sensitivity", text: $addedSensitivity)
                        Button("Cancel", role: .cancel, action: {})
                        Button("Add", action: {
                            addSensitivity(sensitivity: addedSensitivity)
                            addedSensitivity = ""
                        })
                    })
                }
                
            }
    }
}

struct HardwareConnectivityView: View {
    
    @State private var showingAlert = false
    @State private var hardwares = ["Hardware 1", "Hardware 2"]

    var body: some View {
        
        Form {
            Section {
                ForEach(hardwares, id: \.self) {
                    Text($0)
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
                        Text("Hardware Connectivity").font(.headline)
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Add") {
                        showingAlert = true
                    }
                    .alert("Add Hardware", isPresented:$showingAlert, actions:
                            
                        {
                            Text("Bluetooth Logic here")
                        }
                    )
                }
            }
    }
}

struct SportsView: View {
    
    @State private var sport: Sport = Sport(name: "Skiing")
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
                            addedSport = ""
                        })
                    })
                }
            }
    }
}


