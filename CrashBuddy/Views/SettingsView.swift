//
//  SettingsView.swift
//  CrashBuddy
//
//  Edited by Joshua An on 10/16/22.
//

import SwiftUI



struct SettingsView: View {

    
    var body: some View {
        Form {
            Section {
                // Debug Mode
                NavigationLink(destination: DebugView(debugOnInit: false, sensorStatusInit: false, memoryStatusInit: true, powerStatusInit: true), label: {
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

                .navigationTitle(Text("Settings"))
                
            }
        }
        
        
    }
}

