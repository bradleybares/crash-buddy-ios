//
//  SettingSensitivityModel.swift
//  CrashBuddy
//
//  Created by user229036 on 11/16/22.
//

import SwiftUI


class CrashSensitivity: Identifiable, Equatable, ObservableObject, Codable {
    static func == (lhs: CrashSensitivity, rhs: CrashSensitivity) -> Bool {
        lhs.value == rhs.value
    }

    var id: String = UUID().uuidString
    var value: String
    var isSelected: Bool

    init(value: String) {
        self.value = value
        self.isSelected = false
    }

}

class SensitivitiesModel: ObservableObject, Codable {
    
    let id: UUID
    var selectedSensitivity: CrashSensitivity
    var previousSensitivity: CrashSensitivity
    var selectEditSensitivity: CrashSensitivity
    var alreadyAdded: Bool
    var sensitivities: [CrashSensitivity]
    
    init() {
        id = UUID()
        selectedSensitivity = CrashSensitivity(value: "0")
        previousSensitivity = CrashSensitivity(value: "0")
        selectEditSensitivity = CrashSensitivity(value: "0")
        
        alreadyAdded = false
        sensitivities = [CrashSensitivity(value: "0"), CrashSensitivity(value: "50"), CrashSensitivity(value: "100")]
    }
    
    func addSensitivity(value: String) {
        sensitivities.append(CrashSensitivity(value: value))
    }
    
    func selectUpdatedSensitivity(sensitivity: CrashSensitivity) {
        previousSensitivity = selectedSensitivity
        selectedSensitivity = sensitivity
        previousSensitivity.isSelected = false
        selectedSensitivity.isSelected = true
    }
    
    func deleteSensitivity(sensitivity: CrashSensitivity, selectedIndex: Int) {
        
        if sensitivity.isSelected {
            selectedSensitivity = CrashSensitivity(value: "")
        }
        sensitivities.remove(at: selectedIndex)
    }
    
    func editSensitivity(selectEditIndex: Int, value: String) {
        sensitivities[selectEditIndex].value = value
    }
    
    func checkDuplicateEntry(sensitivity: CrashSensitivity) -> Bool {
        alreadyAdded = false
        for existingSensitivity in sensitivities {
            if (sensitivity.value == existingSensitivity.value) {
                alreadyAdded = true
            }
        }
        return alreadyAdded
    }
    
    func getAlreadyAdded() -> Bool {
        return alreadyAdded
    }
}


