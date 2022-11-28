//
//  SettingsViewModel.swift
//  CrashBuddy
//
//  Created by Joshua An on 11/19/22.
//

import Combine
import SwiftUI

class SettingsViewModel : ObservableObject {
    
    internal let objectWillChange = ObservableObjectPublisher()

    let settingsModel: SettingsModel
    
    init(settingsModel: SettingsModel) {
        self.settingsModel = settingsModel
    }
    
    func updateUI() {
        objectWillChange.send()
    }
}
