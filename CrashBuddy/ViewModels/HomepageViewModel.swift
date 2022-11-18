//
//  PeripheralViewModel.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 10/23/22.
//

import Foundation

class HomepageViewModel: ObservableObject {
    
    @Published private(set) var activities: [ActivityDataModel]
    @Published private(set) var settings: SettingModel
    @Published private(set) var peripheralDataModel: PeripheralDataModel
    
    init(activities: [ActivityDataModel]){
        self.activities = activities
        
        self.peripheralDataModel = PeripheralDataModel()
        self.peripheralDataModel.newActivityHandler = appendActivity
    }
    
    // Peripheral Data Model Method
    func appendActivity(activity: ActivityDataModel) {
        self.activities.append(activity)
    }
    
    func updateTrackingStatus() {
        peripheralDataModel.updateTrackingStatus()
    }
    
    // MARK: - View Getters
    var status: PeripheralStatus {
        peripheralDataModel.status
    }
    
    var statusString: String {
        switch self.peripheralDataModel.status {
        case .notConnected:
            return "Not Connected"
        case .connected:
            return "Connected"
        case .tracking:
            return "Tracking"
        }
    }
}
