//
//  SettingViewModel.swift
//  CrashBuddy
//
//  Created by user229036 on 11/19/22.
//

import Combine
import SwiftUI

class SettingsViewModel : ObservableObject {
    
    internal let objectWillChange = ObservableObjectPublisher()

    let settingsModel: SettingModel
    
    init(settingsModel: SettingModel) {
        self.settingsModel = settingsModel
    }
    
    func updateUI() {
        objectWillChange.send()
    }
}
