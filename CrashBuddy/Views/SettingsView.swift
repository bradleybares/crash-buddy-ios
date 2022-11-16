//
//  SettingsView.swift
//  CrashBuddy
//
//  Edited by Joshua An on 10/16/22.
//

import SwiftUI



struct SettingsView: View {

    let settings: SettingModel
    //let settingsViewModel: SettingsViewlModel(SettingsModel)
    //
    var body: some View {
        Form {
            Section {
                // Debug Mode
                //settings.debugModel.getDebugStatus();
                //DebugView(debugViewModel(settingsModel.debugModel))
                NavigationLink(destination: DebugView(debugModelView: SettingDebugViewModel(debugModel: settings.debugModel)), label: {
                    Text("Debug Mode")
                })
                
                // Sports
                NavigationLink(destination: SportsView(sportViewModel: SettingSportViewModel(sportModel: settings.sportsModel)), label: {
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

