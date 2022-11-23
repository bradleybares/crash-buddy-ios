//
//  SettingSportViewModel.swift
//  CrashBuddy
//
//  Created by Joshua An on 11/16/22.
//
import SwiftUI

class SettingsActivityProfilesViewModel : ObservableObject {
    
    @Published private var activitiesProfilesModel: ActivityProfilesModel
    
    @Published var isShowingActivityProfileSheet: Bool = false
    var editingActivityProfile: ActivityProfile?
    
    var activityProfiles: [ActivityProfile] {
        return self.activitiesProfilesModel.profiles
    }
    
    init(activitiesProfilesModel: ActivityProfilesModel) {
        self.activitiesProfilesModel = activitiesProfilesModel
    }
    
    func deleteProfile(id: UUID) {
        self.activitiesProfilesModel.deleteProfile(id: id)
    }
    
    func addProfile(newName: String, newEmoji: String, newThreshold: Int) {
        self.activitiesProfilesModel.addProfile(name: newName, emoji: newEmoji, threshold: newThreshold)
    }
    
    func editProfile(id: UUID, newName: String, newEmoji: String, newThreshold: Int) {
        self.activitiesProfilesModel.editProfile(id: id, newName: newName, newEmoji: newEmoji, newThreshold: newThreshold)
    }
}
