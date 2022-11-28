//
//  ContentView.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 9/12/22.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var homepageViewModel: HomepageViewModel
    @ObservedObject private var peripheralModel: PeripheralDataModel
    
    let saveAction: () -> Void
    
    init(homepageViewModel: HomepageViewModel, saveAction: @escaping (() -> Void)) {
        _homepageViewModel = StateObject(wrappedValue: homepageViewModel)
        self.peripheralModel = homepageViewModel.peripheralDataModel
        
        self.saveAction = saveAction
    }
        
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    if homepageViewModel.crashes.count > 0 {
                        RecentCrashSection(homepageViewModel: homepageViewModel)
                        
                        CrashLogSection(homepageViewModel: homepageViewModel)
                        
                        Spacer()
                    } else {
                        Spacer()
                        Text("Logged crashes will appear here")
                            .font(.headline)
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                    
                    PeripheralInteractionSection(homepageViewModel: homepageViewModel)
                    
                }
                .padding(.horizontal)
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingsView(settingsViewModel: SettingsViewModel(settingsModel: homepageViewModel.settings))
                    } label: {
                        Label("Settings", systemImage: "gear")
                            .labelStyle(.titleAndIcon)
                    }
                }
            }
            .sheet(isPresented: $homepageViewModel.isShowingTrackingSheet) {
                SelectOptionsSheetView(homepageViewModel: homepageViewModel)
            }
            .alert("Crash Detected", isPresented: $homepageViewModel.isShowingCrashAlert) {
                Button("Cancel") {
                    // Dismiss Alert
                }
            } message: {
                Text("Will alert emergency contact after \(homepageViewModel.emergencyContactDelay) seconds if not canceled")
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}


struct SectionHeader<Content: View>: View {
    let sectionTitle: String
    let sectionSubTitle: String?
    @ViewBuilder let sectionToolbarItem: Content
    
    init(sectionTitle: String, sectionSubTitle: String? = nil, sectionToolbarItem: Content = Spacer()) {
        self.sectionTitle = sectionTitle
        self.sectionSubTitle = sectionSubTitle
        self.sectionToolbarItem = sectionToolbarItem
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Text(sectionTitle)
                    .font(.headline)
                Spacer()
                sectionToolbarItem
            }
            if let potentialSubTitle = sectionSubTitle {
                Text(potentialSubTitle)
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
            }
        }
    }
}


struct RecentCrashSection: View {
    
    let homepageViewModel: HomepageViewModel
    
    var body: some View {
        VStack {
            if let recentCrash = homepageViewModel.crashes.last {
                let recentDate = recentCrash.dataPoints[0].dateTime
                SectionHeader(sectionTitle: "Recent Crash", sectionSubTitle: "\(recentDate.formatted(.dateTime.weekday(.wide))), \(recentDate.formatted(.dateTime.month().day()))")
                CrashChart(crashData: recentCrash, includeCharacteristics: true, loading: homepageViewModel.receivingCrashData
                ).frame(maxHeight: 280)
            }
        }
    }
}


struct CrashLogSection: View {
    
    let homepageViewModel: HomepageViewModel
    
    var body: some View {
        VStack {
            SectionHeader(sectionTitle: "Crash Log", sectionToolbarItem:
                NavigationLink(
                    destination: CrashLogView(crashes: homepageViewModel.crashes),
                    label: {
                        Text("Show More")
                    }
                )
            )
            ForEach(homepageViewModel.crashes.suffix(3).reversed()) { crash in
                NavigationLink(destination: CrashView(crashData: crash)) {
                    CrashCard(crashData: crash)
                        .frame(maxHeight: 80)
                }
            }
        }
    }
}


struct PeripheralInteractionSection: View {
    
    let homepageViewModel: HomepageViewModel
    
    var body: some View {
        VStack {
            SectionHeader(sectionTitle: "Peripheral", sectionSubTitle: homepageViewModel.peripheralStatusString)
            Button {
                if (homepageViewModel.peripheralStatus == .tracking) {
                    homepageViewModel.updateTrackingStatus()
                } else {
                    homepageViewModel.isShowingTrackingSheet = true
                }
            } label: {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundStyle(Color.componentBackground)
                    if (homepageViewModel.peripheralStatus == .tracking) {
                        Text("Stop Tracking").foregroundColor(.red)
                    } else {
                        Text("Start Tracking")
                    }
                }
                .frame(maxHeight: 50)
            }
            .disabled(homepageViewModel.peripheralStatus == .notConnected)
        }
    }
}


struct SelectOptionsSheetView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let homepageViewModel: HomepageViewModel
    
    @State private var selectedActivity: ActivityProfile?
    @State private var selectedContact: EmergencyContact?
    
    var body: some View {
        NavigationView {
            Form {
                Section("Activity Profiles") {
                    Picker("Selected Profile", selection: $selectedActivity) {
                        Text("Select").tag(Optional<ActivityProfile>(nil))
                        ForEach(homepageViewModel.settings.activityProfilesModel
                            .profiles) {
                                Text($0.name).tag(Optional($0))
                        }
                    }
                    if let selectedActivity = self.selectedActivity {
                        ActivityProfileCard(activityProfile: selectedActivity)
                    }
                }
                
                Section("Emergency Contact") {
                    Picker("Selected Contact", selection: $selectedContact) {
                        Text("Select").tag(Optional<ActivityProfile>(nil))
                        ForEach(homepageViewModel.settings.emergencyContactsModel
                            .contacts) {
                                Text($0.name).tag(Optional($0))
                        }
                    }
                    if let selectedContact = self.selectedContact {
                        EmergencyContactCard(emergencyContact:  selectedContact)
                    }
                }
            }
            .navigationBarTitle("Tracking Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Start") {
                        if let selectedActivity = self.selectedActivity, let selectedContact = self.selectedContact {
                            homepageViewModel.selectedActivity = selectedActivity
                            homepageViewModel.selectedContact = selectedContact
                            homepageViewModel.updateTrackingStatus()
                        }
                        dismiss()
                    }
                    .disabled(self.selectedActivity == nil || self.selectedContact == nil)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            homepageViewModel: HomepageViewModel(
                crashes: [CrashDataModel.sampleData],
                settings: SettingsModel(debugModel: DebugModel(), activityProfilesModel: ActivityProfilesModel(), emergencyContactsModel: EmergencyContactsModel())
            ),
            saveAction: {}
        )
    }
}
