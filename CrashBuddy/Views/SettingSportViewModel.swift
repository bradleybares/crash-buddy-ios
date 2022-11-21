//
//  SettingSportViewModel.swift
//  CrashBuddy
//
//  Created by user229036 on 11/16/22.
//
import Combine
import SwiftUI

class SettingSportViewModel : ObservableObject {
    
    internal let objectWillChange = ObservableObjectPublisher()

    let sportModel: SportModel
    var editSportString = ""
    var selectEditSport = Sport(name: "")
    
    @Environment(\.presentationMode) var presentationMode

    init(sportModel: SportModel) {
        self.sportModel = sportModel
    }

    func updateSelectedSport(sport: Sport) {
        self.sportModel.selectUpdatedSport(sport: sport)
    }
    
    func deleteSport(sport: Sport, index: Int) {
        self.sportModel.deleteSport(sport: sport, selectedIndex: index)
    }
    
    func checkAddDuplicates(potentialString: String) {
        let alreadyAdded = self.sportModel.checkDuplicateEntry(sport: Sport(name: potentialString))

        if (!alreadyAdded) {
            self.sportModel.addSport(name: potentialString)
        }
    }
    
    func checkEditDuplicates(editString: String) {
        let alreadyAdded = self.sportModel.checkDuplicateEntry(sport: Sport(name: editString))
        
        if (!alreadyAdded) {
            let sportIndex = self.sportModel.sports.firstIndex(where: {$0.name == selectEditSport.name})!
            
            self.sportModel.sports[sportIndex].name = editString
        }
    }
    
    func updateUI() {
        objectWillChange.send()
    }
}
