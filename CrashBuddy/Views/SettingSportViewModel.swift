//
//  SettingSportViewModel.swift
//  CrashBuddy
//
//  Created by user229036 on 11/16/22.
//

import SwiftUI

class SettingSportViewModel {
    
    let sportModel: SportModel
    var addedSport = ""
    var editedSport = ""
    var showingAddSport = false
    var showingEditSport = false

    init(sportModel: SportModel) {
        self.sportModel = sportModel
    }

    
}
