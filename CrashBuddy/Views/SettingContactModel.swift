//
//  SettingContactModel.swift
//  CrashBuddy
//
//  Created by user229036 on 11/16/22.
//

import SwiftUI


class EmergencyContact: Identifiable, Equatable, ObservableObject, Codable {
    static func == (lhs: EmergencyContact, rhs: EmergencyContact) -> Bool {
        ((lhs.phoneNumber == rhs.phoneNumber) && (lhs.name == rhs.name) && (lhs.relationship == rhs.relationship) && (lhs.address == rhs.address))
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

class ContactsModel: ObservableObject, Codable {
    
    let id: UUID
    var selectEditContact: EmergencyContact
    var alreadyAdded: Bool
    var contacts: [EmergencyContact]
    
    init() {
        id = UUID()
        selectEditContact = EmergencyContact(name: "", phoneNumber: "", address: "", relationship: "")
        
        alreadyAdded = false
        contacts = []
    }
    
    func addContact(name: String, phoneNumber: String, address: String, relationship: String) {
        contacts.append(EmergencyContact(name: name, phoneNumber: phoneNumber, address: address, relationship: relationship))
    }
    
    func deleteContact(selectedIndex: Int) {
        contacts.remove(at: selectedIndex)
    }
    
    func editContact(selectEditIndex: Int, name: String, phoneNumber: String, address: String, relationship: String) {
        contacts[selectEditIndex].name = name
        contacts[selectEditIndex].phoneNumber = phoneNumber
        contacts[selectEditIndex].address = address
        contacts[selectEditIndex].relationship = relationship
    }
    
    func checkDuplicateEntry(contact: EmergencyContact) -> Bool {
        alreadyAdded = false
        for existingContact in contacts {
            if (contact == existingContact) {
                alreadyAdded = true
            }
        }
        return alreadyAdded
    }
    
    func getAlreadyAdded() -> Bool {
        return alreadyAdded
    }
}


