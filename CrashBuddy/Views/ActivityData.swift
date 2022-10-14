//
//  DataPoints.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 10/13/22.
//

import Foundation

struct ActivityData {
    let dataPoints: [DataPoint]
    let totalTime: TimeInterval
    let avgAccel: Double
    let maxAccel: Double
    
    init (dataPoints: [DataPoint]) {
        self.dataPoints = dataPoints
        self.totalTime = dataPoints.last!.date.timeIntervalSince(dataPoints.first!.date)
        
        var totalAccel = 0.0
        var maxAccel = 0.0
        for dataPoint in dataPoints {
            totalAccel += dataPoint.accelerometerReading
            maxAccel = max(maxAccel, dataPoint.accelerometerReading)
        }
        
        self.avgAccel = totalAccel/Double(dataPoints.count)
        self.maxAccel = maxAccel
    }
    
    struct DataPoint {
        let date: Date
        let accelerometerReading: Double
        init (timeInterval: TimeInterval, accelerometerReading: Double) {
            self.date = Date(timeIntervalSinceReferenceDate: timeInterval)
            self.accelerometerReading = accelerometerReading
        }
    }
}

extension ActivityData {
    static let sampleData = ActivityData(dataPoints:
        (0..<100).map({DataPoint(timeInterval: Double($0 * 20), accelerometerReading: Double.random(in: 0.345...2.386))})
        + [DataPoint(timeInterval: 2020, accelerometerReading: 45.162),
           DataPoint(timeInterval: 2040, accelerometerReading: 93.729),
           DataPoint(timeInterval: 2060, accelerometerReading: 32.348)]
        + (0..<100).map({DataPoint(timeInterval: Double(($0 * 20) + 2080), accelerometerReading: Double.random(in: 0.345...2.386))})
    )
}
