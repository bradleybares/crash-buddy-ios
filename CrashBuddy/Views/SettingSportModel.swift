//
//  SettingSportModel.swift
//  CrashBuddy
//
//  Created by user229036 on 11/16/22.
//


import SwiftUI

class Sport: Identifiable, Equatable, ObservableObject, Codable {
    static func == (lhs: Sport, rhs: Sport) -> Bool {
        lhs.name == rhs.name
    }
    
    var id: String = UUID().uuidString
    var name: String
    var isSelected: Bool
    
    init(name: String) {
        self.name = name
        self.isSelected = false
    }
}


class SportModel: ObservableObject, Codable {
    
    let id: UUID
    var selectedSport: Sport
    var previousSport: Sport
    var selectEditSport: Sport
    var alreadyAdded: Bool
    var sports: [Sport]
    
    init() {
        id = UUID()
        selectedSport = Sport(name: "Skiing")
        previousSport = Sport(name: "Skiing")
        selectEditSport = Sport(name: "Skiing")
        alreadyAdded = false
        sports = [Sport(name: "Skiing"), Sport(name: "Cycling"), Sport(name: "Snowboarding")]
    }
    
    func addSport(name: String) {
        sports.append(Sport(name: name))
    }
    
    func selectUpdatedSport(sport: Sport) {
        previousSport = selectedSport
        selectedSport = sport
        previousSport.isSelected = false
        selectedSport.isSelected = true
    }
    
    func deleteSport(sport: Sport, selectedIndex: Int) {
        
        if sport.isSelected {
            selectedSport = Sport(name: "")
        }
        sports.remove(at: selectedIndex)
    }
    
    func editSport(selectEditIndex: Int, name: String) {
        sports[selectEditIndex].name = name
    }
    
    func checkDuplicateEntry(sport: Sport) -> Bool {
        alreadyAdded = false
        for existingSport in sports {
            if (sport.name == existingSport.name) {
                alreadyAdded = true
            }
        }
        return alreadyAdded
    }
    
    func getAlreadyAdded() -> Bool {
        return alreadyAdded
    }
}

