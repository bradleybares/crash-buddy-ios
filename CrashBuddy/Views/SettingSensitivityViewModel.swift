//
//  SettingSensitivityViewModel.swift
//  CrashBuddy
//
//  Created by user229036 on 11/17/22.
//
import Combine
import SwiftUI

class SettingSensitivityViewModel : ObservableObject {
    
    internal let objectWillChange = ObservableObjectPublisher()

    let sensitivityModel: SensitivitiesModel
    var editSensitivityString = ""
    var selectEditSensitivity = CrashSensitivity(value: "0")
    
    @Environment(\.presentationMode) var presentationMode

    init(sensitivityModel: SensitivitiesModel) {
        self.sensitivityModel = sensitivityModel
    }

    func updateSelectedSensitivity(sensitivity: CrashSensitivity) {
        self.sensitivityModel.selectUpdatedSensitivity(sensitivity: sensitivity)
    }
    
    func deleteSport(sensitivity: CrashSensitivity, index: Int) {
        self.sensitivityModel.deleteSensitivity(sensitivity: sensitivity, selectedIndex: index)
    }
    
    func checkAddDuplicates(potentialString: String) {
        let alreadyAdded = self.sensitivityModel.checkDuplicateEntry(sensitivity: CrashSensitivity(value: potentialString))

        if (!alreadyAdded) {
            self.sensitivityModel.addSensitivity(value: potentialString)
        }
        //shuffleSportsList()
    }
    
    func checkEditDuplicates(editString: String) {
        let alreadyAdded = self.sensitivityModel.checkDuplicateEntry(sensitivity: CrashSensitivity(value: editString))
        
        if (!alreadyAdded) {
            let sensitivityIndex = self.sensitivityModel.sensitivities.firstIndex(where: {$0.value == selectEditSensitivity.value})!
            
            self.sensitivityModel.sensitivities[sensitivityIndex].value = editString
//            shuffleSportsList()
        }
    }
    
    func updateUI() {
        objectWillChange.send()
    }
    
    func checkInput(sensitivity: String) -> Bool {
        let testValid = Int(sensitivity) ?? -1

        return testValid < 0
    }
}
