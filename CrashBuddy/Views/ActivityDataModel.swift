//
//  DataPoints.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 10/13/22.
//

import Foundation

enum ActivityType: Codable {
    case snowboarding, cycling, skiing
}

class ActivityDataModel: Hashable, Codable {
    static func == (lhs: ActivityDataModel, rhs: ActivityDataModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(totalTime)
        hasher.combine(avgAccel)
        hasher.combine(maxAccel)
    }
    
    let id: UUID
    let dataPoints: [DataPoint]
    let totalTime: TimeInterval
    let avgAccel: Float
    let maxAccel: Float
    var type: ActivityType
    
    init (dataPoints: [DataPoint]) {
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
        self.type = ActivityType.snowboarding
        self.id = UUID()
    }
    
    struct DataPoint: Codable {
        let dateTime: Date
        let accelerometerReading: Float
    }
    
    func setActivity(activityName: String) {
        switch activityName {
        case "Snowboarding":
            type = ActivityType.snowboarding
        case "Cycling":
            type = ActivityType.cycling
        case "Skiing":
            type = ActivityType.skiing
        default:
            type = ActivityType.snowboarding
        }
    }
    
    func getIcon() -> String {
        switch self.type {
        case ActivityType.snowboarding:
            return "🏂"
        case ActivityType.cycling:
            return "🚴"
        case ActivityType.skiing:
            return "⛷"
        }
    }
    
    func getActivityTypeName() -> String {
        switch self.type {
        case ActivityType.snowboarding:
            return "Snowboarding"
        case ActivityType.cycling:
            return "Cycling"
        case ActivityType.skiing:
            return "Skiing"
        }
    }
}

extension ActivityDataModel {
    static let sampleData = ActivityDataModel(dataPoints:
                                            (0..<100).map({DataPoint(dateTime: Date(timeIntervalSinceReferenceDate:  Double($0 * 20)), accelerometerReading: Float.random(in: 0.345...2.386))})
                                         + [DataPoint(dateTime: Date(timeIntervalSinceReferenceDate: 2020), accelerometerReading: 45.162),
                                            DataPoint(dateTime: Date(timeIntervalSinceReferenceDate: 2040), accelerometerReading: 93.729),
                                            DataPoint(dateTime: Date(timeIntervalSinceReferenceDate: 2060), accelerometerReading: 32.348)]
                                         + (0..<100).map({DataPoint(dateTime: Date(timeIntervalSinceReferenceDate: Double(($0 * 20) + 2080)), accelerometerReading: Float.random(in: 0.345...2.386))})
    )
}
