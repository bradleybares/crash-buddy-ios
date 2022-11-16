//
//  ContentView.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 9/12/22.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var activities: [ActivityData]
    @Binding var settings: SettingModel

    let saveAction: ()->Void
    @StateObject var peripheralViewModel: PeripheralViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack(alignment: .leading) {
                    let recentActivity = peripheralViewModel.activities.last ?? ActivityData.sampleData
                    let recentDate = recentActivity.dataPoints[0].dateTime
                    SectionHeader(sectionTitle: "Recent Activity", sectionSubTitle: "\(recentDate.formatted(.dateTime.weekday(.wide))), \(recentDate.formatted(.dateTime.month().day()))")
                    ActivityChart(data: recentActivity, includeCharacteristics: true)
                        .padding(.horizontal)
                    
                    SectionHeader(sectionTitle: "Activity Log", sectionToolbarItem:
                                    NavigationLink(
                                        destination: ActivityLogView(activities: peripheralViewModel.activities),
                                        label: {
                                            Text("Show More")
                                        }
                                    )
                    )
                    ForEach(peripheralViewModel.activities.prefix(3), id: \.self) {activity in
                        NavigationLink(destination: ActivityView(data: activity)) {
                            ActivityCard(data: activity)
                                .frame(maxHeight: 80)
                        }
                    }
                    
                    SectionHeader(sectionTitle: "Peripheral", sectionSubTitle: peripheralViewModel.statusString)
                    Button(action: {
                        peripheralViewModel.updateTrackingStatus()
                    }, label: {
                        ZStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: 14)
                                .foregroundStyle(.white)
                            if peripheralViewModel.status == .tracking {
                                Text("Stop Tracking").foregroundColor(.red)
                            } else {
                                Text("Start Tracking")
                            }
                        }
                        .frame(maxHeight: 50)
                        .padding(.horizontal)
                    })
                    .disabled(peripheralViewModel.status == .notConnected)
                    
                }
                .navigationTitle("Home")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            SettingsView(settingsViewModel: SettingsViewModel(settingsModel: settings))
                        } label: {
                            Label("Settings", systemImage: "gear")
                                .labelStyle(.titleAndIcon)
                        }
                    }
                }
            }
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
        }.padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(activities: .constant([ActivityData.sampleData]), settings: .constant(SettingModel(debugModel: DebugModel(debugOn: false, sensorStatus: true, memoryStatus: true), sportsModel: SportModel(), sensitivitiesModel: SensitivitiesModel(), contactsModel: ContactsModel())),
            saveAction: {})
    }
}
