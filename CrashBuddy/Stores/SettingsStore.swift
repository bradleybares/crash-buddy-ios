//
//  SettingsStore.swift
//  CrashBuddy
//
//  Created by Joshua An on 11/17/22.
//

import Foundation
import SwiftUI

class SettingsStore {
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("settings")
    }
    
    static func load(completion: @escaping (Result<SettingsModel, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success(SettingsModel(debugModel: DebugModel(), activityProfilesModel: ActivityProfilesModel(), emergencyContactsModel: EmergencyContactsModel()))
                        )
                    }
                    return
                }
                let SettingModels = try JSONDecoder().decode(SettingsModel.self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(SettingModels))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(settings: SettingsModel, completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(settings)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(1))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
