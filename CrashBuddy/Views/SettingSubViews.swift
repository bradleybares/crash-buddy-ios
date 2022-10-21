//
//  SettingSubViews.swift
//  CrashBuddy
//
//  Created by Joshua An on 10/17/22.
//

import SwiftUI

class Sport: Identifiable {
    
    
    var id: String = UUID().uuidString	
    var name: String
    var isSelected: Bool
//    var sportText: NSMutableAttributedString
    	
    init(name: String) {
        self.name = name
        self.isSelected = false
//        self.sportText = NSMutableAttributedString(string: name)
    }
    
//    func updateSportsText() {
//        if isSelected {
//            // create our NSTextAttachment
//            let image1Attachment = NSTextAttachment()
//            image1Attachment.image = UIImage(systemName: "checkmark")
//
//            // wrap the attachment in its own attributed string so we can append it
//            let image1String = NSAttributedString(attachment: image1Attachment)
//
//            // add the NSTextAttachment wrapper to our full string, then add some more text.
//            sportText.append(image1String)
//
//        }
//        else {
//            self.sportText = NSMutableAttributedString(string: name)
//        }
//    }
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
    @State private var selectedItem = ""
    
    
    func addContact(name: String, phoneNumber: String, address: String, relationship: String) {
        contacts.append(EmergencyContact(name: name, phoneNumber: phoneNumber, address: address, relationship: relationship))
    }
    
    var body: some View {
        Form {
            Section {
                VStack {
                    List {
                        ForEach(contacts, id: \.self)
                        { index in
                            HStack {
                                
                                Text("\(index.name)")
                                Spacer()
                            }
                            
                            .swipeActions(edge: .trailing) {
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
                .swipeActions(edge: .trailing) {
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
                .swipeActions(edge: .trailing) {
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
    @State private var selectedSportLabel = ""
    @State private var selectedSport: Sport = Sport(name: "Skiing")
    
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
                    List {
                        ForEach(sports)
                        { sport in
                            HStack {
                                Text("\(sport.name)")
                                    .frame(alignment: .leading)
                                Spacer()
                                if sport.isSelected {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color.blue)
                                        .frame(alignment: .trailing)
                                }
                                
                            }
                            .onTapGesture {
                                selectedSport = sport
                                selectedSport.isSelected = true
                            }
                            .swipeActions(edge: .trailing) {
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
                Text("Selected sport: \(selectedSport.name)")
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


