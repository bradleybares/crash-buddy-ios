//
//  SettingContactViewModel.swift
//  CrashBuddy
//
//  Created by user229036 on 11/17/22.
//

import Combine
import SwiftUI

class SettingContactViewModel : ObservableObject {
    
    internal let objectWillChange = ObservableObjectPublisher()

    let contactModel: ContactsModel
    var editContactString = ""
    var selectEditContact = EmergencyContact(name: "", phoneNumber: "", address: "", relationship: "")
    
    @Environment(\.presentationMode) var presentationMode

    init(contactModel: ContactsModel) {
        self.contactModel = contactModel
    }
    
    func deleteContact(index: Int) {
        self.contactModel.deleteContact(selectedIndex: index)
    }
    
    func checkAddDuplicates(potentialName: String, potentialPhoneNumber: String, potentialAddress: String, potentialRelationship: String) {
        let alreadyAdded = self.contactModel.checkDuplicateEntry(contact: EmergencyContact(name: potentialName, phoneNumber: potentialPhoneNumber, address: potentialAddress, relationship: potentialRelationship))

        if (!alreadyAdded) {
            self.contactModel.addContact(name: potentialName, phoneNumber: potentialPhoneNumber, address: potentialAddress, relationship: potentialRelationship)
        }
    }
    
    func checkEditDuplicates(editPotentialName: String, editPotentialPhoneNumber: String, editPotentialAddress: String, editPotentialRelationship: String) {
        let alreadyAdded = self.contactModel.checkDuplicateEntry(contact: EmergencyContact(name: editPotentialName, phoneNumber: editPotentialPhoneNumber, address: editPotentialAddress, relationship: editPotentialRelationship))
        
        if (!alreadyAdded) {
            let contactIndex = self.contactModel.contacts.firstIndex(where: {$0.name == selectEditContact.name})!
            
            self.contactModel.contacts[contactIndex].name = editPotentialName
            self.contactModel.contacts[contactIndex].phoneNumber = editPotentialPhoneNumber
            self.contactModel.contacts[contactIndex].address = editPotentialAddress
            self.contactModel.contacts[contactIndex].relationship = editPotentialRelationship
        }
    }
    
    func updateUI() {
        objectWillChange.send()
    }
}
