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
    private var locationManager: LocationManager = LocationManager()
    
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
            if self.isShowingCrashAlert {
                self.locationManager.requestLocation()
                if let selectedContact = self.selectedContact, let location = self.locationManager.location {
                    TextEmergencyContact.sendText(emergencyContact: selectedContact, location: location)
                }
            }
        }
        self.isShowingCrashAlert = true
    }
    
    func addCrashData(crashDataPoints: [CrashDataModel.DataPoint]) {
        if let selectedActivity = self.selectedActivity, let crashLocation = self.locationManager.location {
            self.crashes.append(CrashDataModel(dataPoints: crashDataPoints, activityProfile: selectedActivity, location: crashLocation))
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
