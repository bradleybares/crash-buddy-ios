//
//  SettingDebugModel.swift
//  CrashBuddy
//
//  Created by user229036 on 11/16/22.
//


import SwiftUI


class DebugModel: ObservableObject, Codable {
    
    var debugOn: Bool = true
    var sensorStatus: Bool = true
    var memoryStatus: Bool = true
    
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
