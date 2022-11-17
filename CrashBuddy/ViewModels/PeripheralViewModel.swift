//
//  PeripheralViewModel.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 10/23/22.
//

import Foundation
import os.log

enum PeripheralStatus {
    case notConnected, connected, tracking
}

class PeripheralViewModel: ObservableObject {
    
    @Published private(set) var status: PeripheralStatus = .notConnected
    @Published private(set) var activities: [ActivityData]
    @Published private(set) var settings: SettingModel
    @Published private(set) var receivingCrashData = false
    
    private var crashDataDateTime: Date?
    
    private let dataChannel = DataCommunicationChannel()

    let logger = os.Logger(subsystem: "com.crash-buddy.peripheral", category: "PeripheralViewModel")
    
    init(activities: [ActivityData], settings: SettingModel) {
        self.activities = activities
        self.settings = settings
        
        // Prepare the data communication channel.
        self.dataChannel.accessoryConnectedHandler = accessoryConnected
        self.dataChannel.accessoryDisconnectedHandler = accessoryDisconnected
        self.dataChannel.accessoryDataAvailableHandler = accessoryDataAvailable
        self.dataChannel.accessoryCrashDataHandler = accessoryCrashData
        self.dataChannel.start()
        
        logger.info("Scanning for accessories")
    }
    
    func updateTrackingStatus() {
        if status == .connected {
            logger.info("Starting Tracking")
            setThreshold(40)
            status = .tracking
        } else {
            logger.info("Stopping Tracking")
            setThreshold(0)
            status = .connected
        }
    }
    
    // MARK: - Data channel methods
    
    func accessoryConnected() {
        self.status = .connected
        logger.info("Accessory Connected")
    }
    
    func accessoryDisconnected() {
        self.status = .notConnected
        logger.info("Accessory Disconnected")
    }
    
    func accessoryDataAvailable() {
        logger.info("Crash Data Available")
        receivingCrashData = true
        crashDataDateTime = Date()
    }
    
    func accessoryCrashData(crashData: [CrashDataReader.DataPoint]) {
        logger.info("Received \(crashData.count) Data Points")
        if let crashDataDateTime = self.crashDataDateTime, let lastAccessoryDataPoint = crashData.last {
            let appDataPointsFromAccessoryDataPoints: [ActivityData.DataPoint] = crashData.map { accessoryDataPoint in
                let clockTimeDifference = lastAccessoryDataPoint.clockTime - accessoryDataPoint.clockTime
                let appDateTime = Date(timeIntervalSinceReferenceDate: crashDataDateTime.timeIntervalSinceReferenceDate - Double(clockTimeDifference)/1000)
                let appAccelerometerValue: Float = Float(accessoryDataPoint.accelerometerValue)/10
                return ActivityData.DataPoint(dateTime: appDateTime, accelerometerReading: appAccelerometerValue)
            }
            activities.append(ActivityData(dataPoints: appDataPointsFromAccessoryDataPoints))
        }
        receivingCrashData = false
    }
}

// MARK: - Bluetooth Helpers.

extension PeripheralViewModel {
    
    func setThreshold(_ threshold: Int) {
        do {
            try dataChannel.writeThresholdCharacteristic(threshold)
        } catch {
            logger.info("Failed to send data to accessory: \(error)")
        }
    }
    
}

// MARK: - View Helpers.

extension PeripheralViewModel {
    
    var statusString: String {
        switch self.status {
        case .notConnected:
            return "Not Connected"
        case .connected:
            return "Connected"
        case .tracking:
            return "Tracking"
        }
    }
    
}
