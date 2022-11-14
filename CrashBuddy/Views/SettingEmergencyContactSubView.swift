//
//  SettingEmergencyContactSubView.swift
//  CrashBuddy
//
//  Created by Joshua An on 11/1/22.
//
import SwiftUI


enum ContactsKeyValue: String {
    case persistentContact, persistentContactList
}


struct PersistentEmergencyContact: Codable {
    let name: String
    let phoneNumber: String
    let address: String
    let relationship: String
}

class EmergencyContacts: ObservableObject {
    
    @Published var emergencyContacts: [EmergencyContact]
    
    init() {
        self.emergencyContacts = []
    }
}

class EmergencyContact: Identifiable, Equatable, ObservableObject {
    static func == (lhs: EmergencyContact, rhs: EmergencyContact) -> Bool {
        lhs.phoneNumber == rhs.phoneNumber
    }
    
    var id: String = UUID().uuidString

    var name: String
    var phoneNumber: String
    var address: String
    var relationship: String

    init(name: String, phoneNumber: String, address: String, relationship: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.address = address
        self.relationship = relationship
    }
    
}

struct EmergencyContactsView: View {
    
    @StateObject var contactsObj = EmergencyContacts()
    
    @State private var initializeView = false
    @State private var showingAddContact = false
    @State private var showingEditContact = false

    @State private var addedContact = ""
    @State private var editedContact = ""
    
    @State private var selectEditContact: EmergencyContact = EmergencyContact(name: "Contact 1", phoneNumber: "1234567689", address: "Address 1", relationship: "Friend")
    
    @AppStorage(ContactsKeyValue.persistentContactList.rawValue) var persistentContactList = [Data()]
    
    func addContact(name: String, phoneNumber: String, address: String, relationship: String) {
        contactsObj.emergencyContacts.append(EmergencyContact(name: name, phoneNumber: phoneNumber, address: address, relationship: relationship))
    }
        
    func createData(individualContact: EmergencyContact) -> Data {
        let tempContact = PersistentEmergencyContact(name: individualContact.name, phoneNumber: individualContact.phoneNumber, address: individualContact.address, relationship: individualContact.relationship)
        guard let tempContactData = try? JSONEncoder().encode(tempContact) else {return Data()}
        return tempContactData
    }
    
    func updatePersistentList() {
        for individualContact in contactsObj.emergencyContacts {
            var contains = false
            for tempData in persistentContactList {

                guard let decodedContact = try? JSONDecoder().decode(PersistentEmergencyContact.self, from: tempData) else {
                    continue}
                if decodedContact.phoneNumber == individualContact.phoneNumber {
                    contains = true
                }
            }

            if (!contains) {
                let tempContactData = createData(individualContact: individualContact)
                persistentContactList.append(tempContactData)
            }
                
        }
    }
    
    func updatePersistentListEdit() {
        for index in 0..<(contactsObj.emergencyContacts.count) {
            guard let decodedContact = try? JSONDecoder().decode(PersistentEmergencyContact.self, from: persistentContactList[index+1]) else {return}
            
            if (contactsObj.emergencyContacts[index].phoneNumber != decodedContact.phoneNumber
                || contactsObj.emergencyContacts[index].name != decodedContact.name
                || contactsObj.emergencyContacts[index].address != decodedContact.address
                || contactsObj.emergencyContacts[index].relationship != decodedContact.relationship) {
                persistentContactList[index] = createData(individualContact: contactsObj.emergencyContacts[index])
            }
        }
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
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            
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
                                    
                                    let persistentIndex = (selectedIndex ?? 0) + 1
                                    
                                    contactsObj.emergencyContacts.remove(at: selectedIndex!)
                                    persistentContactList.remove(at: persistentIndex)
                                }
                            }
                        }
                        .sheet(isPresented: $showingEditContact,
                        onDismiss: updatePersistentListEdit) {
                            ContactEditView(contactsObj: contactsObj, existingContact: selectEditContact)
                            
                        }
                    }
                }
                
                Section {
                    Text("Persisting sport List size: \(persistentContactList.count)")
                    Text("local sport list size \(contactsObj.emergencyContacts.count)")
                }
                
            }
        }
        .onAppear(){
            for tempData in persistentContactList {
                var contains = false
                guard let decodedContact = try? JSONDecoder().decode(PersistentEmergencyContact.self, from: tempData) else {
                    continue}
                
                for individualContact in contactsObj.emergencyContacts {


                    if decodedContact.phoneNumber == individualContact.phoneNumber {
                        contains = true
                    }
                }
                if !contains {
                    addContact(name: decodedContact.name, phoneNumber: decodedContact.phoneNumber, address: decodedContact.address, relationship: decodedContact.relationship)
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
                    onDismiss: updatePersistentList) {
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

