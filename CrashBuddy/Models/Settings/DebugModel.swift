//
//  SettingDebugModel.swift
//  CrashBuddy
//
//  Created by Joshua An on 11/16/22.
//


import SwiftUI


class DebugModel: ObservableObject, Codable {
    
    var debugOn: Bool = false
    var sensorStatus: Bool = false
    var memoryStatus: Bool = false
    
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
