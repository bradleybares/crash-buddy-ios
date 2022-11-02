//
//  SettingEmergencyContactSubView.swift
//  CrashBuddy
//
//  Created by Joshua An on 11/1/22.
//
import SwiftUI

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

