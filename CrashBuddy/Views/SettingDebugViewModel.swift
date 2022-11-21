//
//  SettingDebugViewModel.swift
//  CrashBuddy
//
//  Created by user229036 on 11/16/22.
//

import SwiftUI
import Combine

class SettingDebugViewModel : ObservableObject {
    
    internal let objectWillChange = ObservableObjectPublisher()

    let debugModel: DebugModel


    init(debugModel: DebugModel) {
        self.debugModel = debugModel
    }

    func updateUI() {
        objectWillChange.send()
    }
}
