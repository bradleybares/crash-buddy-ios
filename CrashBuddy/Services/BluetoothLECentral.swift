//
//  BluetoothLECentral.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 10/23/22.
//

import Foundation
import CoreBluetooth
import os

struct TransferService {
    static func specificFromBaseUUID(_ shortUUID: String) -> CBUUID {
        return CBUUID(string: "0998\(shortUUID)-1280-49A1-BACF-965209262E66")
    }
    
    static let nameToShortUUID: [String: String] = [
        "service": "0000",
        "status": "0001",    // The Status of the Accelerometer
        "crashThreshold": "0003", // The Crash Threshold
        "dataAvailable": "0004",  // New Data Available
    ]
    
    static func specificToName(_ specificUUID: CBUUID) -> String {
        return nameToSpecificUUID.first(where: { $1 == specificUUID })?.key ?? "Unknown"
    }
    
    static let nameToSpecificUUID: [String: CBUUID] = nameToShortUUID.mapValues(specificFromBaseUUID(_:))
    
    static let numDataChars = 40
    
    static let firstDataCharShortUUID = "0010"
    
    static let firstDataCharShortUUIDInt = Int(firstDataCharShortUUID, radix: 16)!
    
    static let dataCharacteristicsUUIDs: [CBUUID] = (0..<numDataChars).map {
        specificFromBaseUUID(String(format: "%04X", firstDataCharShortUUIDInt + $0))
    }
    
    static let discoverableCharacteristics = nameToSpecificUUID.filter({$0.key != "service"}).values + dataCharacteristicsUUIDs
    
    static let serviceUUID = nameToSpecificUUID["service"]!
    
    static let crashThresholdCharacteristicUUID = nameToSpecificUUID["crashThreshold"]!
    
    static let dataAvailableCharacteristicUUID = nameToSpecificUUID["dataAvailable"]!
    
}

enum BluetoothLECentralError: Error {
    case noPeripheral
    case noCharacteristic
}

class DataCommunicationChannel: NSObject {
    var centralManager: CBCentralManager!
    var discoveredPeripheral: CBPeripheral?
    var discoveredPeripheralName: String?
    var crashThresholdCharacteristic: CBCharacteristic?
    var dataAvailableCharacteristic: CBCharacteristic?
    var crashDataCharacteristics: [CBCharacteristic] = []
    
    var connectionIterationsComplete = 0
    // The number of times to retry scanning for accessories.
    // Change this value based on your app's testing use case.
    let defaultIterations = 5
    
    // Characteristic Information Handlers
    var accessoryDataAvailableHandler: (() -> Void)?
    var accessoryCrashDataHandler: (([CrashDataReader.DataPoint]) -> Void)?
    
    var crashDataReader: CrashDataReader?
    
    // State Handlers
    var accessoryConnectedHandler: (() -> Void)?
    var accessoryDisconnectedHandler: (() -> Void)?
    
    var bluetoothReady = false
    var shouldStartWhenReady = false

    let logger = os.Logger(subsystem: "com.crash-buddy.ble-central", category: "BLECentral")

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }
    
    deinit {
        centralManager.stopScan()
        logger.info("Scanning stopped")
    }
    
    func start() {
        if bluetoothReady {
            retrievePeripheral()
        } else {
            shouldStartWhenReady = true
        }
    }
    
    func writeThresholdCharacteristic(_ threshold: Int) throws {
        if discoveredPeripheral == nil {
            throw BluetoothLECentralError.noPeripheral
        }
        
        guard let crashThresholdCharacteristic = self.crashThresholdCharacteristic
        else { throw BluetoothLECentralError.noCharacteristic }
        
        updateValueFor(characteristic: crashThresholdCharacteristic, data: withUnsafeBytes(of: UInt32(threshold*10)){ Data($0) })
    }

    // MARK: - Helper Methods.

    /*
     * Check for a connected peer and otherwise scan for peripherals by
     * using the service's 128bit CBUUID.
     */
    private func retrievePeripheral() {

        let connectedPeripherals: [CBPeripheral] = (centralManager.retrieveConnectedPeripherals(withServices: [TransferService.serviceUUID]))

        logger.info("Found connected Peripherals with transfer service: \(connectedPeripherals)")

        if let connectedPeripheral = connectedPeripherals.last {
            logger.info("Connecting to peripheral \(connectedPeripheral)")
            self.discoveredPeripheral = connectedPeripheral
            centralManager.connect(connectedPeripheral, options: nil)
        } else {
            logger.info("Not connected, starting to scan.")
            // Because the app isn't connected to the peer, start scanning for peripherals.
            centralManager.scanForPeripherals(withServices: [TransferService.serviceUUID],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }

    /*
     * Stops an erroneous or completed connection. Note, `didUpdateNotificationStateForCharacteristic`
     * cancels the connection if a subscriber exists.
     */
    private func cleanup() {
        // Don't do anything if we're not connected
        guard let discoveredPeripheral = discoveredPeripheral,
              case .connected = discoveredPeripheral.state else { return }

        for service in (discoveredPeripheral.services ?? [] as [CBService]) {
            for characteristic in (service.characteristics ?? [] as [CBCharacteristic]) {
                if characteristic.isNotifying {
                    // It is notifying, so unsubscribe
                    self.discoveredPeripheral?.setNotifyValue(false, for: characteristic)
                }
            }
        }

        // When a connection exists without a subscriber, only disconnect.
        centralManager.cancelPeripheralConnection(discoveredPeripheral)
    }
    
    // Write data to characteristic.
    private func updateValueFor(characteristic: CBCharacteristic, data: Data) {

        guard let discoveredPeripheral = discoveredPeripheral
        else { return }

        let mtu = discoveredPeripheral.maximumWriteValueLength(for: .withResponse)

        let bytesToCopy: size_t = min(mtu, data.count)

        var rawPacket = [UInt8](repeating: 0, count: bytesToCopy)
        
        // Reverse Byte Order
        let reversedData = Data(data.reversed())
        reversedData.copyBytes(to: &rawPacket, count: bytesToCopy)
        
        let packetData = Data(bytes: &rawPacket, count: bytesToCopy)

        let stringFromData = packetData.map { String(format: "0x%02x, ", $0) }.joined()
        logger.info("Writing \(bytesToCopy) bytes to \(TransferService.specificToName(characteristic.uuid)) (\(characteristic.uuid)): \(String(describing: stringFromData))")

        discoveredPeripheral.writeValue(packetData, for: characteristic, type: .withResponse)
    }
}

extension DataCommunicationChannel: CBCentralManagerDelegate {
    /*
     * When Bluetooth is powered, starts Bluetooth operations.
     *
     * The protocol requires a `centralManagerDidUpdateState` implementation.
     * Ensure you can use the Central by checking whether the its state is
     * `poweredOn`. Your app can check other states to ensure availability such
     * as whether the current device supports Bluetooth LE.
     */
    internal func centralManagerDidUpdateState(_ central: CBCentralManager) {

        switch central.state {
            
        // Begin communicating with the peripheral.
        case .poweredOn:
            logger.info("CBManager is powered on")
            bluetoothReady = true
            if shouldStartWhenReady {
                start()
            }
        // In your app, deal with the following states as necessary.
        case .poweredOff:
            logger.error("CBManager is not powered on")
            return
        case .resetting:
            logger.error("CBManager is resetting")
            return
        case .unauthorized:
            handleCBUnauthorized()
            return
        case .unknown:
            logger.error("CBManager state is unknown")
            return
        case .unsupported:
            logger.error("Bluetooth is not supported on this device")
            return
        @unknown default:
            logger.error("A previously unknown central manager state occurred")
            return
        }
    }

    // Reacts to the varying causes of Bluetooth restriction.
    internal func handleCBUnauthorized() {
        switch CBManager.authorization {
        case .denied:
            // In your app, consider sending the user to Settings to change authorization.
            logger.error("The user denied Bluetooth access.")
        case .restricted:
            logger.error("Bluetooth is restricted")
        default:
            logger.error("Unexpected authorization")
        }
    }

    // Reacts to transfer service UUID discovery.
    // Consider checking the RSSI value before attempting to connect.
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        logger.info("Discovered \( String(describing: peripheral.name)) at\(RSSI.intValue)")
        
        // Check if the app recognizes the in-range peripheral device.
        if discoveredPeripheral != peripheral {
            
            // Save a local copy of the peripheral so Core Bluetooth doesn't
            // deallocate it.
            discoveredPeripheral = peripheral
            
            // Connect to the peripheral.
            logger.info("Connecting to perhiperal \(peripheral)")
            
            let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String
            discoveredPeripheralName = name ?? "Unknown"
            centralManager.connect(peripheral, options: nil)
        }
    }

    // Reacts to connection failure.
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        logger.error("Failed to connect to \(peripheral). \( String(describing: error))")
        cleanup()
    }

    // Discovers the services and characteristics to find the 'TransferService'
    // characteristic after peripheral connection.
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if let didConnectHandler = accessoryConnectedHandler {
            didConnectHandler()
        }
        
        logger.info("Peripheral Connected")
        
        // Stop scanning.
        centralManager.stopScan()
        logger.info("Scanning stopped")
        
        // Set the iteration info.
        connectionIterationsComplete += 1
        
        // Set the `CBPeripheral` delegate to receive callbacks for its services discovery.
        peripheral.delegate = self
        
        // Search only for services that match the service UUID.
        peripheral.discoverServices([TransferService.serviceUUID])
    }

    // Cleans up the local copy of the peripheral after disconnection.
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        logger.info("Perhiperal Disconnected")
        discoveredPeripheral = nil
        discoveredPeripheralName = nil
        
        if let didDisconnectHandler = accessoryDisconnectedHandler {
            didDisconnectHandler()
        }
        
        // Resume scanning after disconnection.
        if connectionIterationsComplete < defaultIterations {
            retrievePeripheral()
        } else {
            logger.info("Connection iterations completed")
        }
    }

}

// An extention to implement `CBPeripheralDelegate` methods.
extension DataCommunicationChannel: CBPeripheralDelegate {
    
    // Reacts to peripheral services invalidation.
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {

        for service in invalidatedServices where service.uuid == TransferService.serviceUUID {
            logger.error("Transfer service is invalidated - rediscover services")
            peripheral.discoverServices([TransferService.serviceUUID])
        }
    }

    // Reacts to peripheral services discovery.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            logger.error("Error discovering services: \(error.localizedDescription)")
            cleanup()
            return
        }
        logger.info("discovered service. Now discovering characteristics")
        // Check the newly filled peripheral services array for more services.
        guard let peripheralServices = peripheral.services else { return }
        for service in peripheralServices {
            peripheral.discoverCharacteristics(
                Array(TransferService.discoverableCharacteristics), for: service
            )
        }
    }

    // Subscribes to a discovered characteristic, which lets the peripheral know we want the data it contains.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // Deal with errors (if any).
        if let error = error {
            logger.error("Error discovering characteristics: \(error.localizedDescription)")
            cleanup()
            return
        }

        // Check the newly filled peripheral services array for more services.
        guard let serviceCharacteristics = service.characteristics else { return }
        for characteristic in serviceCharacteristics {
            
            logger.info("Discovered characteristic: \(characteristic)")
            
            if characteristic.uuid == TransferService.dataAvailableCharacteristicUUID {
                // Subscribe to the transfer service's `dataAvailableCharacteristic`.
                dataAvailableCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            } else if characteristic.uuid == TransferService.crashThresholdCharacteristicUUID {
                crashThresholdCharacteristic = characteristic
            } else if TransferService.dataCharacteristicsUUIDs.contains(characteristic.uuid) {
                self.crashDataCharacteristics.append(characteristic)
            }
        }

        // Wait for the peripheral to send data.
    }

    // Reacts to data arrival through the characteristic notification.
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // Check if the peripheral reported an error.
        if let error = error {
            logger.error("Error receiving characteristic data:\(error.localizedDescription)")
            cleanup()
            return
        }
        guard let characteristicData = characteristic.value else { return }
    
        let str = characteristicData.map { String(format: "0x%02x, ", $0) }.joined()
        logger.info("Received \(characteristicData.count) bytes on \(TransferService.specificToName(characteristic.uuid)) (\(characteristic.uuid)): \(str) ")
        
        // If the the data available characteristic has been updated
        if characteristic.uuid == TransferService.dataAvailableCharacteristicUUID {
            if let dataAvailableHandler = self.accessoryDataAvailableHandler, let firstCrashDataCharacterstic = self.crashDataCharacteristics.first {
                dataAvailableHandler()
                crashDataReader = CrashDataReader()
                peripheral.readValue(for: firstCrashDataCharacterstic)
            }
        // If the characteristic is a crash data characteristic, leverage the data  reader
        } else if TransferService.dataCharacteristicsUUIDs.contains(characteristic.uuid) {
            if let crashDataHandler = self.accessoryCrashDataHandler, let crashDataReader = self.crashDataReader {
                // If there is data left to be read (i.e. an empty characteristic hasn't been found), read the data
                if crashDataReader.remainingReads {
                    crashDataReader.readCrashDataPoints(characteristicData)
                    // If the next characteristic exists, read its value
                    if crashDataReader.characteristicsRead < self.crashDataCharacteristics.count {
                        peripheral.readValue(for: self.crashDataCharacteristics[crashDataReader.characteristicsRead])
                    // Otherwise send the crash data to the handler
                    } else {
                        crashDataHandler(crashDataReader.crashData)
                    }
                // Otherwise send the crash data to the handler
                } else {
                    crashDataHandler(crashDataReader.crashData)
                }
            }
        } else {
            logger.info("Unexpected characteristic notification on \(characteristic)")
        }
    }

    // Reacts to the subscription status.
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        // Check if the peripheral reported an error.
        if let error = error {
            logger.error("Error changing notification state: \(error.localizedDescription)")
            return
        }

        if characteristic.isNotifying {
            // Indicates the notification began.
            logger.info("Notification began on \(characteristic)")
        } else {
            // Because the notification stopped, disconnect from the peripheral.
            logger.info("Notification stopped on \(characteristic). Disconnecting")
            cleanup()
        }
    }
}

// MARK: - Crash Data Interpreter.
class CrashDataReader {
    var characteristicsRead = 0
    var remainingReads = true
    private(set) var crashData: [DataPoint] = []
    
    struct DataPoint {
        let accelerometerValue: Int16
        let clockTime: Int32
    }
    
    let chunkSize = MemoryLayout<Int16>.size + MemoryLayout<Int32>.size
        
    func readCrashDataPoints(_ data: Data){
        
        if data.count < self.chunkSize {
            self.characteristicsRead += 1
            self.remainingReads = false
            return
        }
        
        var remainingDataPoints = data.count / self.chunkSize
        var cursor = 0
        while remainingDataPoints > 0  {
            // Get the bytes that contain the acceleration value
            let accelValueDataChunk = Data(data[cursor..<cursor+MemoryLayout<Int16>.size])
            let accelValue = accelValueDataChunk.withUnsafeBytes { bufferPointer in
                bufferPointer.load(fromByteOffset: 0, as: Int16.self)
            }
            
            cursor += MemoryLayout<Int16>.size
            
            // Get the bytes that contain the clock time
            let clockTimeDataChunk = Data(data[cursor..<cursor+MemoryLayout<Int32>.size])
            let clockTime = clockTimeDataChunk.withUnsafeBytes { bufferPointer in
                bufferPointer.load(fromByteOffset: 0, as: Int32.self)
            }
            
            cursor += MemoryLayout<Int32>.size
            
            let dataPoint = DataPoint(accelerometerValue: accelValue, clockTime: clockTime)
            
            // Append Data Point to Reader Data
            self.crashData.append(dataPoint)
            // Move the cursor to the next position and decrement remaining points
            remainingDataPoints -= 1
        }
        self.characteristicsRead += 1
    }
}
