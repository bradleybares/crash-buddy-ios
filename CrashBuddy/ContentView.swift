//
//  ContentView.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 9/12/22.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var peripheralViewModel: PeripheralViewModel
    let saveAction: ()->Void
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    RecentActivitySection(activities: peripheralViewModel.activities)
                    
                    ActivityLogSection(activities: peripheralViewModel.activities)
                    
                    Spacer()
                    
                    PeripheralInteractionSection(status: peripheralViewModel.status, statusString: peripheralViewModel.statusString, updateTrackingStatus: peripheralViewModel.updateTrackingStatus)
                    
                }
                .padding(.horizontal)
                .navigationTitle("Home")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            SettingsView(settingsViewModel: SettingsViewModel(settingsModel: peripheralViewModel.settings))
                        } label: {
                            Label("Settings", systemImage: "gear")
                                .labelStyle(.titleAndIcon)
                        }
                    }
                }
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

struct RecentActivitySection: View {
    
    var activities: [ActivityData]
    
    var body: some View {
        VStack {
            let recentActivity = activities.last ?? ActivityData.sampleData
            let recentDate = recentActivity.dataPoints[0].dateTime
            SectionHeader(sectionTitle: "Recent Activity", sectionSubTitle: "\(recentDate.formatted(.dateTime.weekday(.wide))), \(recentDate.formatted(.dateTime.month().day()))")
            ActivityChart(data: recentActivity, includeCharacteristics: true, loading: false
            ).frame(maxHeight: 280)
        }
    }
}

struct ActivityLogSection: View {
    
    var activities: [ActivityData]
    
    var body: some View {
        VStack {
            SectionHeader(sectionTitle: "Activity Log", sectionToolbarItem:
                            NavigationLink(
                                destination: ActivityLogView(activities: activities),
                                label: {
                                    Text("Show More")
                                }
                            )
            )
            ForEach(activities.prefix(3), id: \.self) { activity in
                NavigationLink(destination: ActivityView(data: activity)) {
                    ActivityCard(data: activity)
                        .frame(maxHeight: 80)
                }
            }
        }
    }
}

struct PeripheralInteractionSection: View {
    
    var status: PeripheralStatus
    var statusString: String
    var updateTrackingStatus: (() -> Void)
    
    var body: some View {
        VStack {
            SectionHeader(sectionTitle: "Peripheral", sectionSubTitle: statusString)
            Button(action: updateTrackingStatus, label: {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundStyle(Color.componentBackground)
                    if (status == .tracking) {
                        Text("Stop Tracking").foregroundColor(.red)
                    } else {
                        Text("Start Tracking")
                    }
                }
                .frame(maxHeight: 50)
            })
            .disabled(status == .notConnected)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(activities: .constant([ActivityData.sampleData]), settings: .constant(SettingModel(debugModel: DebugModel(debugOn: false, sensorStatus: true, memoryStatus: true), sportsModel: SportModel(), sensitivitiesModel: SensitivitiesModel(), contactsModel: ContactsModel())),
            saveAction: {})
    }
}
