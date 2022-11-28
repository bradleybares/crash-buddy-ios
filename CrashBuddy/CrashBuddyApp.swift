//
//  CrashBuddyApp.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 9/12/22.
//

import SwiftUI

@main
struct CrashBuddyApp: App {
    
    private var crashStore = CrashStore()
    private var settingsStore = SettingsStore()
    
    var body: some Scene {
        WindowGroup {
            let homepageViewModel = HomepageViewModel(crashStore: crashStore, settingsStore: settingsStore)
            ContentView(homepageViewModel: homepageViewModel) {
                CrashStore.save(crashes: homepageViewModel.crashes) { result in
                    if case .failure(let error) = result {
                        fatalError(error.localizedDescription)
                    }
                }
                SettingsStore.save(settings: homepageViewModel.settings) { result in
                    if case .failure(let error) = result {
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
    }
}
