//
//  SettingContactModel.swift
//  CrashBuddy
//
//  Created by Joshua An on 11/16/22.
//

import SwiftUI


struct EmergencyContact: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var phoneNumber: String
    var address: String
    var relationship: String
}

extension EmergencyContact {
    static let sampleEmergencyContact = EmergencyContact(name: "Josh An", phoneNumber: "‭16265600283‬", address: "", relationship: "Teammate")
    
    static let sampleEmergencyContacts = [
        sampleEmergencyContact,
        EmergencyContact(name: "Matt Chan", phoneNumber: "16507147079‬", address: "", relationship: "Teammate")
    ]
}

class EmergencyContactsModel: Codable {
    
    private(set) var contacts: [EmergencyContact]
    
    init(contacts: [EmergencyContact] = EmergencyContact.sampleEmergencyContacts) {
        self.contacts = contacts
    }
    
    func addContact(name: String, phoneNumber: String, address: String, relationship: String) {
        self.contacts.append(EmergencyContact(name: name, phoneNumber: phoneNumber, address: address, relationship: relationship))
    }
    
    func deleteContact(id: UUID) {
        if let deletableIndex = self.indexOfContactId(id) {
            self.contacts.remove(at: deletableIndex)
        }
    }
    
    func editContact(id: UUID, name: String, phoneNumber: String, address: String, relationship: String) {
        if let editableIndex = self.indexOfContactId(id) {
            self.contacts[editableIndex].name = name
            self.contacts[editableIndex].phoneNumber = phoneNumber
            self.contacts[editableIndex].address = address
            self.contacts[editableIndex].relationship = relationship
        }
    }
    
    func indexOfContactId(_ id: UUID) -> Int? {
        return self.contacts.firstIndex(where: {$0.id == id})
    }
    
//    func checkDuplicateEntry(contact: EmergencyContact) -> Bool {
//        alreadyAdded = false
//        for existingContact in contacts {
//            if (contact == existingContact) {
//                alreadyAdded = true
//            }
//        }
//        return alreadyAdded
//    }
}


