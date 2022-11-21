//
//  ContentView.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 9/12/22.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject var homepageViewModel: HomepageViewModel
    let saveAction: ()->Void
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    
                    if homepageViewModel.crashes.count > 0 {
                        RecentCrashSection(crashes: homepageViewModel.crashes)
                        
                        CrashLogSection(crashes: homepageViewModel.crashes)
                        
                        Spacer()
                    } else {
                        Spacer()
                        Text("Logged crashes will appear here")
                            .font(.headline)
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                    
                    PeripheralInteractionSection(status: homepageViewModel.status, statusString: homepageViewModel.statusString, updateTrackingStatus: homepageViewModel.updateTrackingStatus)
                    
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

struct RecentCrashSection: View {
    
    var crashes: [CrashDataModel]
    
    var body: some View {
        VStack {
            if let recentCrash = crashes.last {
                let recentDate = recentCrash.dataPoints[0].dateTime
                SectionHeader(sectionTitle: "Recent Crash", sectionSubTitle: "\(recentDate.formatted(.dateTime.weekday(.wide))), \(recentDate.formatted(.dateTime.month().day()))")
                CrashChart(data: recentCrash, includeCharacteristics: true, loading: false
                ).frame(maxHeight: 280)
            }
        }
    }
}

struct CrashLogSection: View {
    
    var crashes: [CrashDataModel]
    
    var body: some View {
        VStack {
            SectionHeader(sectionTitle: "Crash Log", sectionToolbarItem:
                NavigationLink(
                    destination: CrashLogView(crashes: crashes),
                    label: {
                        Text("Show More")
                    }
                )
            )
            ForEach(crashes.suffix(3).reversed(), id: \.self) { crash in
                NavigationLink(destination: CrashView(data: crash)) {
                    CrashCard(data: crash)
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
