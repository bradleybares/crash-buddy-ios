//
//  SettingEmergencyContactSubView.swift
//  CrashBuddy
//
//  Created by Joshua An on 11/1/22.
//


import SwiftUI


struct SettingsEmergencyContactsView: View {
    
    @StateObject var emergencyContactsViewModel: SettingsEmergencyContactsViewModel
    
    var body: some View {
        Form {
            Section {
                List {
                    ForEach(emergencyContactsViewModel.emergencyContacts)
                    { emergencyContact in
                        EmergencyContactCard(emergencyContact: emergencyContact)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            HStack {
                                Button("Edit") {
                                    emergencyContactsViewModel.editingEmergencyContact = emergencyContact
                                    emergencyContactsViewModel.isShowingContactSheet = true
                                }
                                .tint(.blue)
                                
                                Button("Delete", role: .destructive) {
                                    emergencyContactsViewModel.deleteContact(id: emergencyContact.id)
                                }
                            }
                        }
                    }
                }
            }
            Button("Add Emergency Contact") {
                emergencyContactsViewModel.isShowingContactSheet = true
            }
        }
        .navigationTitle("Emergency Contacts")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $emergencyContactsViewModel.isShowingContactSheet,
               onDismiss: {emergencyContactsViewModel.editingEmergencyContact = nil}) {
            EmergencyContactSheet(emergencyContactsViewModel: emergencyContactsViewModel)
        }
    }
}


struct EmergencyContactCard: View {
    
    let emergencyContact: EmergencyContact
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(emergencyContact.name)
                    .font(.headline)
                Text("\(emergencyContact.relationship)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("+\(emergencyContact.phoneNumber)")
                .font(.system(size: 24))
        }
    }
}


struct EmergencyContactSheet: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var contactName: String = ""
    @State private var contactPhoneNumber: String = ""
    @State private var contactAddress: String = ""
    @State private var contactRelationship: String = ""
    
    let emergencyContactsViewModel: SettingsEmergencyContactsViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section("Name") {
                    TextField(
                        "Required",
                        text: $contactName
                    )
                    .disableAutocorrection(true)
                }
                Section("Number") {
                    TextField(
                        "Required",
                        text: $contactPhoneNumber
                    )
                    .disableAutocorrection(true)
                }
                Section("Address") {
                    TextField(
                        "Optional",
                        text: $contactAddress
                    )
                    .disableAutocorrection(true)
                }
                Section("Relationship") {
                    TextField(
                        "Optional",
                        text: $contactRelationship
                    )
                    .disableAutocorrection(true)
                }
            }
            .navigationBarTitle((emergencyContactsViewModel.editingEmergencyContact != nil) ? "Edit Profile" : "Add Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button((emergencyContactsViewModel.editingEmergencyContact != nil) ? "Done" : "Add") {
                        if let editingEmergencyContact = emergencyContactsViewModel.editingEmergencyContact {
                            emergencyContactsViewModel.editContact(id: editingEmergencyContact.id, newName: contactName, newPhoneNumber: contactPhoneNumber, newAddress: contactAddress, newRelationship: contactRelationship)
                            
                        } else {
                            emergencyContactsViewModel.addContact(
                                newName: contactName,
                                newPhoneNumber: contactPhoneNumber,
                                newAddress: contactAddress,
                                newRelationship: contactRelationship
                            )
                        }
                        dismiss()
                    }
                    .disabled(contactName == "" || contactPhoneNumber == "")
                }
            }
            .onAppear() {
                if let editingEmergencyContact = emergencyContactsViewModel.editingEmergencyContact {
                    contactName = editingEmergencyContact.name
                    contactPhoneNumber = editingEmergencyContact.phoneNumber
                    contactAddress = editingEmergencyContact.address
                    contactRelationship = editingEmergencyContact.relationship
                }
            }
        }
    }
}

struct SettingsEmergencyContactsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsEmergencyContactsView(emergencyContactsViewModel: SettingsEmergencyContactsViewModel(emergencyContactsModel: EmergencyContactsModel()))
    }
}
