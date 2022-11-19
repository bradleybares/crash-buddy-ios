//
//  SettingsView.swift
//  CrashBuddy
//
//  Edited by Joshua An on 10/16/22.
//

import SwiftUI



struct SettingsView: View {

    @ObservedObject var settingsViewModel: SettingsViewModel

    init(settingsViewModel: SettingsViewModel) {
        self.settingsViewModel = settingsViewModel
    }

    var body: some View {
        Form {
            Section {
                // Debug Mode
                NavigationLink(destination: DebugView(debugOnBool: false, sensorStatusBool: true, memoryStatusBool: true), label: {
                    Text("Debug Mode")
                })
                
                // Sports
                NavigationLink(destination: SportsView(sportViewModel: SettingSportViewModel(sportModel: settingsViewModel.settingsModel.sportsModel)), label: {
                    HStack {
                        Text("Sports")
                        Spacer()
                        Text("\(settingsViewModel.settingsModel.sportsModel.selectedSport.name)")
                            .frame(alignment: .trailing)
                            .foregroundColor(Color.gray)
                    }
                })
                
                // Crash Sensitivity
                NavigationLink(destination: CrashSensitivityView(sensitivityViewModel: SettingSensitivityViewModel(sensitivityModel: settingsViewModel.settingsModel.sensitivitiesModel)), label: {
                    HStack {
                        Text("Crash Sensitivity")
                        Spacer()
                        Text("\(settingsViewModel.settingsModel.sensitivitiesModel.selectedSensitivity.value)")
                            .frame(alignment: .trailing)
                            .foregroundColor(Color.gray)
                    }
                    
                })
                
                
                // Emergency Contacts
                NavigationLink(destination: EmergencyContactsView(contactViewModel: SettingContactViewModel(contactModel: settingsViewModel.settingsModel.contactsModel)), label: {
                    Text("Emergency Contacts")
                })
                .onAppear(perform: settingsViewModel.updateUI)
                .navigationTitle(Text("Settings"))
                
            }
        }
        
        
    }
}

