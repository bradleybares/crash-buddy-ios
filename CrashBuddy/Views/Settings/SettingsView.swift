//
//  SettingsView.swift
//  CrashBuddy
//
//  Edited by Joshua An on 10/16/22.
//

import SwiftUI


struct SettingsView: View {
    
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        Form {
            Section {
                // Debug Mode
                NavigationLink {
                    DebugView(debugOnBool: false, sensorStatusBool: true, memoryStatusBool: true)
                } label: {
                    Text("Debug")
                }
                
                // Sports
                NavigationLink {
                    SettingsActivityProfilesView(activityProfilesViewModel: SettingsActivityProfilesViewModel(activitiesProfilesModel: settingsViewModel.settingsModel.activityProfilesModel))
                } label: {
                    HStack {
                        Text("Activity Profiles")
                        Spacer()
                        Text("\(settingsViewModel.settingsModel.activityProfilesModel.profiles.count)")
                            .frame(alignment: .trailing)
                            .foregroundColor(Color.gray)
                    }
                }
                
                // Emergency Contacts
                NavigationLink { SettingsEmergencyContactsView(emergencyContactsViewModel: SettingsEmergencyContactsViewModel(emergencyContactsModel: settingsViewModel.settingsModel.emergencyContactsModel))
                } label: {
                    HStack {
                        Text("Emergency Contacts")
                        Spacer()
                        Text("\(settingsViewModel.settingsModel.emergencyContactsModel.contacts.count)")
                            .frame(alignment: .trailing)
                            .foregroundColor(Color.gray)
                    }
                }
            }
        }
        .onAppear(perform: settingsViewModel.updateUI)
        .navigationTitle(Text("Settings"))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settingsViewModel: SettingsViewModel(settingsModel: SettingsModel(debugModel: DebugModel(), activityProfilesModel: ActivityProfilesModel(), emergencyContactsModel: EmergencyContactsModel())))
    }
}
