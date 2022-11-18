//
//  PeripheralViewModel.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 10/23/22.
//

import Foundation

class HomepageViewModel: ObservableObject {
    
    @Published private(set) var settings: SettingModel
    @Published private(set) var crashes: [CrashDataModel]
    @Published private(set) var peripheralDataModel: PeripheralDataModel
    
    init(crashes: [CrashDataModel]){
        self.crashes = crashes
        
        self.peripheralDataModel = PeripheralDataModel()
        self.peripheralDataModel.newCrashHandler = appendCrash
    }
    
    // Peripheral Data Model Method
    func appendCrash(crash: CrashDataModel) {
        self.crashes.append(crash)
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
