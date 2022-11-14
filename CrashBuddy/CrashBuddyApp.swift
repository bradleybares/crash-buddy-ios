//
//  CrashBuddyApp.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 9/12/22.
//

import SwiftUI

@main
struct CrashBuddyApp: App {
    @StateObject private var store = ActivityStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView(activities: $store.activites) {
                ActivityStore.save(activities: store.activites) { result in
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
                        store.activites = activities
                    }
                }
            }
        }
    }
}
