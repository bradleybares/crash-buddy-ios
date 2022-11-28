//
//  SettingSportModel.swift
//  CrashBuddy
//
//  Created by Joshua An on 11/16/22.
//

import SwiftUI


struct ActivityProfile: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var emoji: String
    var threshold: Int
    
    var thresholdString: String {
        "\(threshold)"
    }
}

extension ActivityProfile {
    static let sampleProfile = ActivityProfile(name: "Skiing", emoji: "⛷", threshold: 70)
    
    static let sampleProfiles = [
        sampleProfile,
        ActivityProfile(name: "Snowboarding", emoji: "🏂", threshold: 80),
        ActivityProfile(name: "Cycling", emoji: "🚴", threshold: 40),
        ActivityProfile(name: "Climbing", emoji: "🧗", threshold: 20)
    ]
}

class ActivityProfilesModel: Codable {
    
    private(set) var profiles: [ActivityProfile]
    
    init(profiles: [ActivityProfile] = ActivityProfile.sampleProfiles) {
        self.profiles = profiles
    }
    
    func addProfile(name: String, emoji: String, threshold: Int) {
        self.profiles.append(ActivityProfile(name: name, emoji: emoji, threshold: threshold))
    }
    
    func deleteProfile(id: UUID) {
        if let deletableIndex = self.indexOfProfileId(id) {
            self.profiles.remove(at: deletableIndex)
        }
    }
    
    func editProfile(id: UUID, newName: String, newEmoji: String, newThreshold: Int) {
        if let editableIndex = self.indexOfProfileId(id) {
            self.profiles[editableIndex].name = newName
            self.profiles[editableIndex].emoji = newEmoji
            self.profiles[editableIndex].threshold = newThreshold
        }
        
    }
    
    func indexOfProfileId(_ id: UUID) -> Int? {
        return self.profiles.firstIndex(where: {$0.id == id})
    }
    
//    func isValidNewProfile(_ profile: ActivityProfile) -> Bool {
//        for existingProfile in self.profiles {
//            if (profile == existingProfile) {
//                return true
//            }
//        }
//        return false
//    }
}

