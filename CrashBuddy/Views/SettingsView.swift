//
//  SettingsView.swift
//  CrashBuddy
//
//  Edited by Joshua An on 10/16/22.
//

import SwiftUI



struct SettingsView: View {

    let settings: SettingModel

    var body: some View {
        Form {
            Section {
                // Debug Mode
                //settings.debugModel.getDebugStatus();
                //DebugView(debugViewModel(settingsModel.debugModel))
                NavigationLink(destination: DebugView(debugOnBool: false, sensorStatusBool: true, memoryStatusBool: true), label: {
                    Text("Debug Mode")
                })
                
                // Sports
                NavigationLink(destination: SportsView(sportViewModel: SettingSportViewModel(sportModel: settings.sportsModel)), label: {
                    Text("Sports")
                })
                
                // Crash Sensitivity
                NavigationLink(destination: CrashSensitivityView(sensitivityViewModel: SettingSensitivityViewModel(sensitivityModel: settings.sensitivitiesModel)), label: {
                    Text("Crash Sensitivity")
                })
                
                // Emergency Contacts
                NavigationLink(destination: EmergencyContactsView(contactViewModel: SettingContactViewModel(contactModel: settings.contactsModel)), label: {
                    Text("Emergency Contacts")
                })

                .navigationTitle(Text("Settings"))
                
            }
        }
        
        
    }
}

