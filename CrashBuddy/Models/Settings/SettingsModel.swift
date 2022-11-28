//
//  SettingModel.swift
//  CrashBuddy
//
//  Created by Joshua An on 11/16/22.
//

import SwiftUI

class SettingsModel: Codable {
    let debugModel: DebugModel
    let activityProfilesModel: ActivityProfilesModel
    let emergencyContactsModel: EmergencyContactsModel
    
    init(debugModel: DebugModel = DebugModel(), activityProfilesModel: ActivityProfilesModel = ActivityProfilesModel(), emergencyContactsModel: EmergencyContactsModel = EmergencyContactsModel()) {
        self.debugModel = debugModel
        self.activityProfilesModel = activityProfilesModel
        self.emergencyContactsModel = emergencyContactsModel
    }

}
