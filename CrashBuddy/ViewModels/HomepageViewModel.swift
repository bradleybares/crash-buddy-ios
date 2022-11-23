//
//  PeripheralViewModel.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 10/23/22.
//

import Foundation
import Combine

class HomepageViewModel: ObservableObject {
        
    @Published private(set) var crashes: [CrashDataModel] = []
    private(set) var settings: SettingsModel = SettingsModel()
    
    @Published var isShowingTrackingSheet: Bool = false
    @Published var isShowingCrashAlert: Bool = false
    
    let emergencyContactDelay: Int = 30
    
    var selectedActivity: ActivityProfile?
    var selectedContact: EmergencyContact?
    
    private(set) var peripheralDataModel: PeripheralDataModel = PeripheralDataModel()
    
    // Test Data Initializer
    init(crashes: [CrashDataModel], settings: SettingsModel){

        self.peripheralDataModel.newCrashHandler = emergencyContactProtocol
        self.peripheralDataModel.crashDataHandler = addCrashData
        
        self.crashes = crashes
        self.settings = settings
    }
    
    // Persitent Data Initializer
    init(crashStore: CrashStore, settingsStore: SettingsStore){

        self.peripheralDataModel.newCrashHandler = emergencyContactProtocol
        self.peripheralDataModel.crashDataHandler = addCrashData
        
        CrashStore.load { result in
            switch result {
            case .failure(let error):
                fatalError(error.localizedDescription)
            case .success(let crashes):
                self.crashes = crashes
            }
        }
        
        SettingsStore.load { result in
            switch result {
            case .failure(let error):
                fatalError(error.localizedDescription)
            case .success(let settings):
                self.settings = settings
            }
        }
    }
    
    // Peripheral Data Model Methods
    func emergencyContactProtocol() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(emergencyContactDelay)) {
            if let selectedContact = self.selectedContact, self.isShowingCrashAlert {
                TextEmergencyContact.sendText(selectedContact)
            }
        }
        self.isShowingCrashAlert = true
    }
    
    func addCrashData(crashDataPoints: [CrashDataModel.DataPoint]) {
        if let selectedActivity = self.selectedActivity {
            self.crashes.append(CrashDataModel(dataPoints: crashDataPoints, activityProfile: selectedActivity))
        }
    }
    
    func updateTrackingStatus() {
        peripheralDataModel.updateTrackingStatus()
    }
    
    
    // MARK: - Computed View Vars
    var receivingCrashData: Bool {
        return peripheralDataModel.receivingCrashData
    }
    
    var peripheralStatus: PeripheralStatus {
        return peripheralDataModel.status
    }
    
    var peripheralStatusString: String {
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
