//
//  SettingContactViewModel.swift
//  CrashBuddy
//
//  Created by Joshua An on 11/17/22.
//

import SwiftUI

class SettingsEmergencyContactsViewModel : ObservableObject {
    
    @Published private var emergencyContactsModel: EmergencyContactsModel
    
    @Published var isShowingContactSheet: Bool = false
    var editingEmergencyContact: EmergencyContact?
    
    var emergencyContacts: [EmergencyContact] {
        return self.emergencyContactsModel.contacts
    }

    init(emergencyContactsModel: EmergencyContactsModel) {
        self.emergencyContactsModel = emergencyContactsModel
    }
    
    func deleteContact(id: UUID) {
        self.emergencyContactsModel.deleteContact(id: id)
    }
    
    func addContact(newName: String, newPhoneNumber: String, newAddress: String, newRelationship: String) {
        self.emergencyContactsModel.addContact(name: newName, phoneNumber: newPhoneNumber, address: newAddress, relationship: newRelationship)
    }
    
    func editContact(id: UUID, newName: String, newPhoneNumber: String, newAddress: String, newRelationship: String) {
        self.emergencyContactsModel.editContact(id: id, name: newName, phoneNumber: newPhoneNumber, address: newAddress, relationship: newRelationship)
    }
}
