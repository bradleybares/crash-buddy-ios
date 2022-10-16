//
//  SettingsView.swift
//  CrashBuddy
//
//  Edited by Joshua An on 10/16/22.
//

import SwiftUI

struct SettingsView: View {

    @State private var sport: Sport = .snowboarding
    @State private var crash_sensitivity: Int = 100

    var body: some View {
        NavigationView {
            Form {
                Section {
                    // Debug Mode
                    NavigationLink(destination: DebugView(), label: {
                                SettingRowView(title: "Debug Mode",
                            }
                    )

                    // Sports
                    Picker(selection: $sport, label: Text("Sports")) {
                        ForEach(Array(SettingEnums.Sports.allCases), id: \.self) {
                                        Text($0.rawValue)
                                    }
                    }

                    // Crash Sensitivity
                    Picker(selection: $crash_sensitivity, label: Text("Crash Sensitivity")) {
                        ForEach(Array(SettingEnums.Sports.allCases), id: \.self) {
                                        Text($0.rawValue)
                                    }
                    }

                    // Emergency Contacts
                    NavigationLink(destination: EmergencyContactsView(), label: {
                                SettingRowView(title: "Emergency Contacts",
                            }
                    )

                    // "Hardware Connectivity
                    NavigationLink(destination: HardwareConnectivityView(), label: {
                                SettingRowView(title: "Hardware Connectivity",
                            }
                    )

                }
            }
        }
        .navigationTitle(Text("Settings"))
    }
}
