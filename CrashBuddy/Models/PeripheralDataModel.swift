//
//  PeripheralDataModel.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 11/17/22.
//

import Foundation
import os.log

enum PeripheralStatus {
    case notConnected, connected, tracking
}

class PeripheralDataModel: ObservableObject {
    @Published private(set) var status: PeripheralStatus = .notConnected
    @Published private(set) var receivingCrashData = false
    
    private var crashDataDateTime: Date?
    
    var newCrashHandler: (() -> Void)?
    var crashDataHandler: (([CrashDataModel.DataPoint]) -> Void)?
    var statusUpdateHandler: ((PeripheralStatus) -> Void)?
    
    private let dataChannel = DataCommunicationChannel()

    let logger = os.Logger(subsystem: "com.crash-buddy.peripheral", category: "PeripheralDataModel")
    
    init() {
        
        // Prepare the data communication channel.
        self.dataChannel.accessoryConnectedHandler = accessoryConnected
        self.dataChannel.accessoryDisconnectedHandler = accessoryDisconnected
        self.dataChannel.accessoryDataAvailableHandler = accessoryDataAvailable
        self.dataChannel.accessoryCrashDataHandler = accessoryCrashData
        self.dataChannel.start()
        
        logger.info("Scanning for accessories")
    }
    
    // MARK: - From Peripheral
    func accessoryConnected() {
        updateStatus(newStatus: .connected)
        logger.info("Accessory Connected")
    }
    
    func accessoryDisconnected() {
        updateStatus(newStatus: .notConnected)
        logger.info("Accessory Disconnected")
    }
    
    func accessoryDataAvailable() {
        logger.info("Crash Data Available")
        receivingCrashData = true
        crashDataDateTime = Date()
    }
    
    func accessoryCrashData(crashData: [CrashDataReader.DataPoint]) {
        logger.info("Received \(crashData.count) Data Points")
        if let lastAccessoryDataPoint = crashData.last, let crashDataDateTime = self.crashDataDateTime, let crashDataHandler = self.crashDataHandler {
            let appDataPointsFromAccessoryDataPoints: [CrashDataModel.DataPoint] = crashData.map { accessoryDataPoint in
                let clockTimeDifference = lastAccessoryDataPoint.clockTime - accessoryDataPoint.clockTime
                let appDateTime = Date(timeIntervalSinceReferenceDate: crashDataDateTime.timeIntervalSinceReferenceDate - Double(clockTimeDifference)/1000)
                let appAccelerometerValue: Float = Float(accessoryDataPoint.accelerometerValue)/10
                return CrashDataModel.DataPoint(dateTime: appDateTime, accelerometerReading: appAccelerometerValue)
            }
            crashDataHandler(appDataPointsFromAccessoryDataPoints)
        }
        self.receivingCrashData = false
    }
    
    // MARK: - To Peripheral
    func updateTrackingStatus() {
        if self.status == .connected {
            logger.info("Starting Tracking")
            do {
                try dataChannel.writeThresholdCharacteristic(10)
                updateStatus(newStatus: .tracking)
            } catch {
                logger.info("Failed to Start Tracking: \(error)")
            }
        } else {
            logger.info("Stopping Tracking")
            do {
                try dataChannel.writeThresholdCharacteristic(0)
                updateStatus(newStatus: .connected)
            } catch {
                logger.info("Failed to Stop Tracking: \(error)")
            }
        }
    }
    
    // MARK: - Helper Methods
    func updateStatus(newStatus: PeripheralStatus) {
        self.status = newStatus
        if let statusUpdateHandler = self.statusUpdateHandler {
            statusUpdateHandler(newStatus)
        }
    }
    
}


