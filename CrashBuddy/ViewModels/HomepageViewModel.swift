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
    @Published private(set) var status: PeripheralStatus
    
    private var peripheralDataModel: PeripheralDataModel = PeripheralDataModel()
    
    init(crashes: [CrashDataModel]){
        self.crashes = crashes
        
        self.status = self.peripheralDataModel.status
        
        self.peripheralDataModel.newCrashHandler = appendCrash
        self.peripheralDataModel.statusUpdateHandler = updateStatus
    }
    
    // Peripheral Data Model Method
    func appendCrash(crash: CrashDataModel) {
        self.crashes.append(crash)
    }
    
    func updateStatus(newStatus: PeripheralStatus) {
        self.status = newStatus
    }
    
    func updateTrackingStatus() {
        peripheralDataModel.updateTrackingStatus()
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
