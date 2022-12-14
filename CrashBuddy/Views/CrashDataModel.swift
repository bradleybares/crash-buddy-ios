//
//  DataPoints.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 10/13/22.
//

import Foundation
import CoreLocation


struct CrashDataModel: Identifiable, Codable {
    let id: UUID
    let dataPoints: [DataPoint]
    let totalTime: TimeInterval
    let avgAccel: Float
    let maxAccel: Float
    let activity: ActivityProfile
    let longitude: Double
    let latitude: Double
    
    init (dataPoints: [DataPoint], activityProfile: ActivityProfile, location: CLLocationCoordinate2D) {
        self.id = UUID()
        self.dataPoints = dataPoints
        self.totalTime = dataPoints.last!.dateTime.timeIntervalSince(dataPoints.first!.dateTime)
        
        var totalAccel: Float = 0.0
        var maxAccel: Float = 0.0
        for dataPoint in dataPoints {
            totalAccel += dataPoint.accelerometerReading
            maxAccel = max(maxAccel, dataPoint.accelerometerReading)
        }
        
        self.avgAccel = totalAccel/Float(dataPoints.count)
        self.maxAccel = maxAccel
        self.activity = activityProfile
        self.longitude = Double(location.longitude)
        self.latitude = Double(location.latitude)
    }
    
    struct DataPoint: Codable {
        let dateTime: Date
        let accelerometerReading: Float
    }
}

extension CrashDataModel {
    static let sampleData = CrashDataModel(
        dataPoints:
            (0..<100).map({DataPoint(dateTime: Date(timeIntervalSinceReferenceDate:  Double($0 * 20)), accelerometerReading: Float.random(in: 0.345...2.386))})
         + [DataPoint(dateTime: Date(timeIntervalSinceReferenceDate: 2020), accelerometerReading: 45.162),
            DataPoint(dateTime: Date(timeIntervalSinceReferenceDate: 2040), accelerometerReading: 93.729),
            DataPoint(dateTime: Date(timeIntervalSinceReferenceDate: 2060), accelerometerReading: 32.348)]
         + (0..<100).map({DataPoint(dateTime: Date(timeIntervalSinceReferenceDate: Double(($0 * 20) + 2080)), accelerometerReading: Float.random(in: 0.345...2.386))}),
        activityProfile: ActivityProfile.sampleProfile,
        location: CLLocationCoordinate2D(latitude: 3.86462, longitude: -37.58900)
    )
}
