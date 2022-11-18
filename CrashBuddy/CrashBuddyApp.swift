//
//  CrashBuddyApp.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 9/12/22.
//

import SwiftUI

@main
struct CrashBuddyApp: App {
    
    @StateObject private var activityStore = ActivityStore()
    @StateObject private var settingsStore = SettingsStore()
    
    var body: some Scene {
        WindowGroup {
            let homepageViewModel = HomepageViewModel(activities: store.activites)
            ContentView(homepageViewModel: homepageViewModel) {
                ActivityStore.save(activities: homepageViewModel.activities) { result in
                    if case .failure(let error) = result {
                        fatalError(error.localizedDescription)
                    }
                }
                SettingsStore.save(settings: peripheralViewModel.settings) { result in
                        if case .failure(let error) = result {
                        fatalError(error.localizedDescription)
                    }
                }
            }
            .onAppear {
                ActivityStore.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let activities):
                        activityStore.activites = activities
                    }
                }
                SettingsStore.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let settings):
                        settingsStore.settings = settings
                    }
                }
            }
        }
    }
}
