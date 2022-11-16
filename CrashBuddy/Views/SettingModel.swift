//
//  SettingModel.swift
//  CrashBuddy
//
//  Created by user229036 on 11/16/22.
//

import SwiftUI

class SettingModel {
    let debugModel: DebugModel
    let sportsModel: SportModel
    let sensitivitiesModel: SensitivitiesModel
    let contactsModel: ContactsModel
    
    init(debugModel: DebugModel, sportsModel: SportModel, sensitivitiesModel: SensitivitiesModel, contactsModel: ContactsModel) {
        self.debugModel = debugModel
        self.sportsModel = sportsModel
        self.sensitivitiesModel = sensitivitiesModel
        self.contactsModel = contactsModel
    }
}
