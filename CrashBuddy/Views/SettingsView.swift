//
//  SettingsView.swift
//  CrashBuddy
//
//  Edited by Joshua An on 10/16/22.
//

import SwiftUI

struct Sport: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

struct SettingsView: View {

    
    var body: some View {
        Form {
            Section {
                // Debug Mode
                NavigationLink(destination: DebugView(), label: {
                    Text("Debug Mode")
                })
                
                // Sports
                NavigationLink(destination: SportsView(), label: {
                    Text("Sports")
                })
                
                // Crash Sensitivity
                NavigationLink(destination: CrashSensitivityView(), label: {
                    Text("Crash Sensitivity")
                })
                
                // Emergency Contacts
                NavigationLink(destination: EmergencyContactsView(), label: {
                    Text("Emergency Contacts")
                })
                
                // Hardware Connectivity
                NavigationLink(destination: HardwareConnectivityView(), label: {
                    Text("Hardware Connectivity")
                })
                .navigationTitle(Text("Settings"))
                
            }
        }
        
        
    }
}

