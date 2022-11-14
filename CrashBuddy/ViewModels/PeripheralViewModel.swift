//
//  PeripheralViewModel.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 10/23/22.
//

import Foundation
import os.log

enum Status {
    case notConnected, connected, tracking
}

enum MessageId: UInt8 {
    // Messages from the accessory.
    case accessoryData = 0x1
    case crashDetected = 0x2
    
    // Messages to the accessory.
    case initialize = 0xA
    case startTracking = 0xB
    case stopTracking = 0xC
    
}

class PeripheralViewModel: ObservableObject {
    private var dataChannel = DataCommunicationChannel()
        
    @Published private(set) var status: Status = .notConnected

    let logger = os.Logger(subsystem: "com.crash-buddy.peripheral", category: "PeripheralViewModel")
    
    init() {
        // Prepare the data communication channel.
        self.dataChannel.accessoryConnectedHandler = accessoryConnected
        self.dataChannel.accessoryDisconnectedHandler = accessoryDisconnected
        self.dataChannel.accessoryDataHandler = accessorySharedData
        self.dataChannel.start()
        
        logger.info("Scanning for accessories")
    }
    
    func updateTrackingStatus() {
        if status == .connected {
            sendDataToAccessory(Data([MessageId.startTracking.rawValue]))
            status = .tracking
        } else {
            sendDataToAccessory(Data([MessageId.stopTracking.rawValue]))
            status = .connected
        }
    }
    
    func startSession() {
        logger.info("Requesting configuration data from accessory")
        sendDataToAccessory(Data([MessageId.initialize.rawValue]))
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
    
    func accessorySharedData(data: Data, accessoryName: String) {
        // The accessory begins each message with an identifier byte.
        // Ensure the message length is within a valid range.
        if data.count < 1 {
            logger.info("Accessory shared data length was less than 1.")
            return
        }
        
        // Assign the first byte which is the message identifier.
        guard let messageId = MessageId(rawValue: data.first!) else {
            fatalError("\(data.first!) is not a valid MessageId.")
        }
        
        // Handle the data portion of the message based on the message identifier.
        switch messageId {
        case .accessoryData:
            // Access the message data by skipping the message identifier.
            assert(data.count > 1)
            //let message = data.advanced(by: 1)
        case .crashDetected:
            logger.info("Test transmission received: \(data.count)bytes")
        case .initialize:
            fatalError("Accessory should not send 'initialize'.")
        case .startTracking:
            fatalError("Accessory should not send 'startTracking'.")
        case .stopTracking:
            fatalError("Accessory should not send 'stopTracking'.")
        }
    }
}

// MARK: - Bluetooth Helpers.

extension PeripheralViewModel {
    
    func sendDataToAccessory(_ data: Data) {
        do {
            try dataChannel.sendData(data)
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
