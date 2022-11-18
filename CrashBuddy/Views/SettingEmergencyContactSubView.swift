//
//  SettingEmergencyContactSubView.swift
//  CrashBuddy
//
//  Created by Joshua An on 11/1/22.
//
import SwiftUI


struct EmergencyContactsView: View {
    
    @ObservedObject var contactViewModel: SettingContactViewModel
    @ObservedObject var contactModel: ContactsModel
    
    init(contactViewModel: SettingContactViewModel) {
        self.contactViewModel = contactViewModel
        self.contactModel = contactViewModel.contactModel
    }
    
    @State private var showingAddContact = false
    @State private var showingEditContact = false
    
    var body: some View {
        Form {
            Section {
                List {
                    ForEach(contactModel.contacts)
                    { contact in
                        HStack {
                            Text("\(contact.name)")
                                .frame(alignment: .leading)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            
                            HStack {
                                Button("View") {
                                    showingEditContact = true
                                    
                                    contactViewModel.selectEditContact = contact
                                    
                                }
                                .tint(.blue)
                                
                                
                                Button("Delete", role: .destructive) {
                                    let selectedIndex = contactViewModel.contactModel.contacts.firstIndex(of: contact )
                                    
                                    contactViewModel.deleteContact(index: selectedIndex ?? 0
                                    )
                                    
                                }
                            }
                        }
                        .sheet(isPresented: $showingEditContact,
                               onDismiss: contactViewModel.updateUI) {
                            ContactEditView(contactViewModel: contactViewModel)
                            
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
                ZStack {
                    
                    Button("Add") {
                        showingAddContact = true
                    }
                    .sheet(isPresented: $showingAddContact,
                           onDismiss: contactViewModel.updateUI) {
                        ContactAddView(contactViewModel: contactViewModel)
                    }
                }
            }
        }
    }
}


struct ContactAddView: View {
    
    
    @State var name: String = ""
    @State var phoneNumber: String = ""
    @State var address: String = ""
    @State var relationship: String = ""
    
    @State var showingAddAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    let contactViewModel: SettingContactViewModel
    
    init(contactViewModel: SettingContactViewModel) {
        self.contactViewModel = contactViewModel
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Enter name", text: $name)
                    TextField("Enter phone number", text: $phoneNumber)
                    TextField("Enter address", text: $address)
                    TextField("Enter relationship", text: $relationship)
                }
                Section {
                    Button("Add") {
                        contactViewModel.checkAddDuplicates(potentialName: name, potentialPhoneNumber: phoneNumber, potentialAddress: address, potentialRelationship: relationship)
                        
                        if (!contactViewModel.contactModel.getAlreadyAdded()) {
                            presentationMode.wrappedValue.dismiss()
                        }
                        else {
                            showingAddAlert = true
                        }
                    }
                    Button("Cancel", role: .cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .tint(.red)
                }
                
            }
        }
        .alert(isPresented: $showingAddAlert) {
            Alert(title: Text("Duplicate Entry"), message: Text("Entry already present and will not be added"))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Add Emergency Contact").font(.headline)
            }
            
        }
    }
    
}

struct ContactEditView: View {
    
    
    @State var editName: String = ""
    @State var editPhoneNumber: String = ""
    @State var editAddress: String = ""
    @State var editRelationship: String = ""
        
    @State var showingAddAlert = false

    @Environment(\.presentationMode) var presentationMode
    
    let contactViewModel: SettingContactViewModel
    
    init(contactViewModel: SettingContactViewModel) {
        self.contactViewModel = contactViewModel
    }
    
    
    var body: some View {
        
        NavigationView {
            
            Form {
                Section {
                    TextField("Name", text: $editName)
                    TextField("Phone Number", text: $editPhoneNumber)
                    TextField("Address", text: $editAddress)
                    TextField("Relationship", text: $editRelationship)
                }
                Section {
                    Button("Done Editing") {
                        contactViewModel.checkEditDuplicates(editPotentialName: editName, editPotentialPhoneNumber: editPhoneNumber, editPotentialAddress: editAddress, editPotentialRelationship: editRelationship)
                        
                        if (!contactViewModel.contactModel.getAlreadyAdded()) {
                            presentationMode.wrappedValue.dismiss()
                        }
                        else {
                            showingAddAlert = true
                        }
                    }
                    Button("Exit", role: .cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .tint(.red)
                }
                
            }
        }
        .alert(isPresented: $showingAddAlert) {
            Alert(title: Text("Duplicate Entry"), message: Text("Entry already present and will not be added"))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Contact").font(.headline)
            }
            
        }
        .onAppear() {
            editName = contactViewModel.selectEditContact.name
            editPhoneNumber = contactViewModel.selectEditContact.phoneNumber
            editAddress = contactViewModel.selectEditContact.address
            editRelationship = contactViewModel.selectEditContact.relationship
        }
    }
}

