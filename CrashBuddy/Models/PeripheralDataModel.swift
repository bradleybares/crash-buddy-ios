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

class PeripheralDataModel {
    private(set) var status: PeripheralStatus = .notConnected
    private(set) var receivingCrashData = false
    
    private var crashDataDateTime: Date?
    
    var newCrashHandler: ((CrashDataModel) -> Void)?
    
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
        if let lastAccessoryDataPoint = crashData.last, let crashDataDateTime = self.crashDataDateTime, let newCrashHandler = self.newCrashHandler {
            let appDataPointsFromAccessoryDataPoints: [CrashDataModel.DataPoint] = crashData.map { accessoryDataPoint in
                let clockTimeDifference = lastAccessoryDataPoint.clockTime - accessoryDataPoint.clockTime
                let appDateTime = Date(timeIntervalSinceReferenceDate: crashDataDateTime.timeIntervalSinceReferenceDate - Double(clockTimeDifference)/1000)
                let appAccelerometerValue: Float = Float(accessoryDataPoint.accelerometerValue)/10
                return CrashDataModel.DataPoint(dateTime: appDateTime, accelerometerReading: appAccelerometerValue)
            }
            newCrashHandler(CrashDataModel(dataPoints: appDataPointsFromAccessoryDataPoints))
        }
        self.receivingCrashData = false
    }
    
    // MARK: - To Peripheral
    func updateTrackingStatus() {
        if self.status == .connected {
            logger.info("Starting Tracking")
            setThreshold(10)
            self.status = .tracking
        } else {
            logger.info("Stopping Tracking")
            setThreshold(0)
            self.status = .connected
        }
    }
    
    func setThreshold(_ threshold: Int) {
        do {
            try dataChannel.writeThresholdCharacteristic(threshold)
        } catch {
            logger.info("Failed to send data to accessory: \(error)")
        }
    }
}


