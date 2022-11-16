//
//  SettingDebugModel.swift
//  CrashBuddy
//
//  Created by user229036 on 11/16/22.
//


import SwiftUI


enum DebugKeyValue: String {
    case persistentDebugStatus, persistentSensorStatus, presistentMemoryStatus, persistentPowerStatus
}


class DebugModel {
    
    @AppStorage(DebugKeyValue.persistentDebugStatus.rawValue) private var debugOn: Bool = true
    @AppStorage(DebugKeyValue.persistentSensorStatus.rawValue) private var sensorStatus: Bool = true
    @AppStorage(DebugKeyValue.presistentMemoryStatus.rawValue) private var memoryStatus: Bool = true
    
    init(debugOn: Bool, sensorStatus: Bool, memoryStatus: Bool) {
        self.debugOn = debugOn
        self.sensorStatus = sensorStatus
        self.memoryStatus = memoryStatus
    }
    
    func setDebugStatus(status: Bool) {
        self.debugOn = status
    }
    
    func getDebugStatus() -> Bool {
        return self.debugOn
    }
    
    func setSensortatus(status: Bool) {
        self.sensorStatus = status
    }
    
    func getSensorStatus() -> Bool {
        return self.sensorStatus
    }
    
    func setMemoryStatus(status: Bool) {
        self.memoryStatus = status
    }
    
    func getMemoryStatus() -> Bool {
        return self.memoryStatus
    }
    
}
