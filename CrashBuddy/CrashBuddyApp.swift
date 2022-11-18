//
//  CrashBuddyApp.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 9/12/22.
//

import SwiftUI

@main
struct CrashBuddyApp: App {
    
    private var activityStore = ActivityStore()
    private var settingsStore = SettingsStore()
    
    var body: some Scene {
        WindowGroup {
            let homepageViewModel = HomepageViewModel(crashes: store.crashes)
            ContentView(homepageViewModel: homepageViewModel) {
                CrashStore.save(crashes: homepageViewModel.crashes) { result in
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
                CrashStore.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let crashes):
                        store.crashes = crashes
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
