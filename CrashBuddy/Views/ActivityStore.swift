//
//  ActivityStore.swift
//  CrashBuddy
//
//  Created by Matthew Chan on 11/8/22.
//

import Foundation
import SwiftUI

class ActivityStore: ObservableObject {
    @Published var activites: [ActivityData] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("activities.data")
    }
    
    static func load(completion: @escaping (Result<[ActivityData], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let activityDatas = try JSONDecoder().decode([ActivityData].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(activityDatas))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(activities: [ActivityData], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(activities)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(activities.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}