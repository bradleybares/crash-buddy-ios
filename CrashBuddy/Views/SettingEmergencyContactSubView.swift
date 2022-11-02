//
//  SettingEmergencyContactSubView.swift
//  CrashBuddy
//
//  Created by Joshua An on 11/1/22.
//
import SwiftUI

class EmergencyContacts: ObservableObject {
    
    @Published var emergencyContacts: [EmergencyContact]
    
    init() {
        self.emergencyContacts = []
    }
}

class EmergencyContact: Identifiable, Equatable, ObservableObject {
    static func == (lhs: EmergencyContact, rhs: EmergencyContact) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String = UUID().uuidString

    var name: String
    var phoneNumber: String
    var address: String
    var relationship: String
    var isSelected: Bool

    init(name: String, phoneNumber: String, address: String, relationship: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.address = address
        self.relationship = relationship
        self.isSelected = false
    }
    
}

struct EmergencyContactsView: View {
    
    @StateObject var contactsObj = EmergencyContacts()
    
    @State private var initializeView = false
    @State private var showingAddContact = false
    @State private var showingEditContact = false

    @State private var addedContact = ""
    @State private var editedContact = ""
    
    @State private var selectedContact: EmergencyContact = EmergencyContact(name: "Contact 1", phoneNumber: "1234567689", address: "Address 1", relationship: "Friend")
    @State private var previousContact: EmergencyContact = EmergencyContact(name: "Contact 1", phoneNumber: "1234567689", address: "Address 1", relationship: "Friend")
    @State private var selectEditContact: EmergencyContact = EmergencyContact(name: "Contact 1", phoneNumber: "1234567689", address: "Address 1", relationship: "Friend")
    
    
    func addContact(name: String, phoneNumber: String, address: String, relationship: String) {
        contactsObj.emergencyContacts.append(EmergencyContact(name: name, phoneNumber: phoneNumber, address: address, relationship: relationship))
    }
    
    var body: some View {
        Form {
            Section {
                List {
                    ForEach(contactsObj.emergencyContacts)
                    { contact in
                        HStack {
                            Text("\(contact.name)")
                                .frame(alignment: .leading)
                            Spacer()
                            if contact.isSelected {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color.blue)
                                    .frame(alignment: .trailing)
                            }
                            
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            previousContact = selectedContact
                            selectedContact = contact
                            previousContact.isSelected = false
                            selectedContact.isSelected = true
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            
                            HStack {
                                Button("View") {
                                    selectEditContact = contact
                                    showingEditContact = true

                                    contactsObj.emergencyContacts = contactsObj.emergencyContacts.reversed()
                                    contactsObj.emergencyContacts = contactsObj.emergencyContacts.reversed()

                                }
                                .tint(.blue)
                                
                                
                                Button("Delete", role: .destructive) {
                                    let selectedIndex = contactsObj.emergencyContacts.firstIndex(of: contact )
                                    
                                    if contact.isSelected {
                                        selectedContact = EmergencyContact(name: "", phoneNumber: "", address: "", relationship: "")
                                        
                                    }
                                    contactsObj.emergencyContacts.remove(at: selectedIndex!)
                                }
                            }
                        }
                        .sheet(isPresented: $showingEditContact) {
                            ContactEditView(contactsObj: contactsObj, existingContact: selectEditContact)
                            
                        }
                    }
                }
                
                Section {
                    Text("Selected contact: \(selectedContact.name)")
                }
            }
        }
        .onAppear(){
            if (!initializeView) {
                addContact(name: "Temp 1", phoneNumber: "1234567689", address: "Address 1", relationship: "Friend")
                addContact(name: "Temp 2", phoneNumber: "1112223333", address: "Address 2", relationship: "Sibling")
                addContact(name: "Temp 3", phoneNumber: "4445556666", address: "Address 3", relationship: "Mother")
            }
            initializeView = true
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
                    .sheet(isPresented: $showingAddContact) {
                        ContactAddView(contactsObj: contactsObj, name: "", phoneNumber: "", address: "", relationship: "")
                        
                    }
                }
            }
        }
    }
}


struct ContactAddView: View {
    
    @StateObject var contactsObj = EmergencyContacts()
    
    @State var name: String
    @State var phoneNumber: String
    @State var address: String
    @State var relationship: String
    
    @State var showingAddAlert = false
    @State var showView = false
    @Environment(\.presentationMode) var presentationMode
    
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
                        checkDuplicates()
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
        .environmentObject(contactsObj)
    }
    
    
    
    func checkDuplicates() {
        var alreadyAdded = false
        for existingContact in contactsObj.emergencyContacts {
            if (name == existingContact.name &&
                phoneNumber == existingContact.phoneNumber &&
                address == existingContact.address &&
                relationship == existingContact.relationship) {
                alreadyAdded = true
            }
        }
        
        if (!alreadyAdded) {
            contactsObj.emergencyContacts.append(EmergencyContact(name: name, phoneNumber: phoneNumber, address: address, relationship: relationship))
            presentationMode.wrappedValue.dismiss()
            
        }
        
        else {
            showingAddAlert = true
        }
        name = ""
        phoneNumber = ""
        address = ""
        relationship = ""
        
    }
}

struct ContactEditView: View {
    
    @StateObject var contactsObj = EmergencyContacts()
    
    @State var editName: String = ""
    @State var editPhoneNumber: String = ""
    @State var editAddress: String = ""
    @State var editRelationship: String = ""

    @State var existingContact: EmergencyContact

    @State var showingAddAlert = false
    @State var showView = false
    @Environment(\.presentationMode) var presentationMode
    
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
                        checkEditDuplicates()
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
        .environmentObject(contactsObj)
        .onAppear() {
            editName = existingContact.name
            editPhoneNumber = existingContact.phoneNumber
            editAddress = existingContact.address
            editRelationship = existingContact.relationship
            
        }
    }
    

    func checkEditDuplicates() {
        var alreadyAdded = false
        for existingContact in contactsObj.emergencyContacts {
            
            if (editName == existingContact.name &&
                editPhoneNumber == existingContact.phoneNumber &&
                editAddress == existingContact.address &&
                editRelationship == existingContact.relationship) {
                alreadyAdded = true
            }
        }
        
        if (!alreadyAdded) {
            
            var contactIndex: Int {
                contactsObj.emergencyContacts.firstIndex(where: { $0.name == existingContact.name })!}

            contactsObj.emergencyContacts[contactIndex].name = editName
            contactsObj.emergencyContacts[contactIndex].phoneNumber = editPhoneNumber
            contactsObj.emergencyContacts[contactIndex].address = editAddress
            contactsObj.emergencyContacts[contactIndex].relationship = editRelationship

            contactsObj.emergencyContacts = contactsObj.emergencyContacts.reversed()
            contactsObj.emergencyContacts = contactsObj.emergencyContacts.reversed()
            
            presentationMode.wrappedValue.dismiss()
            
        }
        
        else {
            showingAddAlert = true
        }
    }
}

