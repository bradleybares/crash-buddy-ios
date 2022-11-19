//
//  ContentView.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 9/12/22.
//

import SwiftUI

enum Status {
    case notConnected, connected, started
}

struct ContentView: View {

    @State var connectionStatus: Status = .notConnected
    @Binding var activities: [ActivityData]
    @Binding var settings: SettingModel

    @State private var newActivityData = ActivityData.sampleData
    let saveAction: ()->Void

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack(alignment: .leading) {
                    let recentActivity = activities.last ?? ActivityData.sampleData
                    let recentDate = recentActivity.dataPoints[0].date
                    SectionHeader(sectionTitle: "Recent Activity", sectionSubTitle: "\(recentDate.formatted(.dateTime.weekday(.wide))), \(recentDate.formatted(.dateTime.month().day()))")
                    ActivityChart(data: recentActivity, includeCharacteristics: true)
                        .padding(.horizontal)
                    
                    SectionHeader(sectionTitle: "Activity Log", sectionToolbarItem:
                                    NavigationLink(
                                        destination: ActivityLogView(activities: activities),
                                        label: {
                                            Text("Show More")
                                        }
                                    )
                    )
                    ForEach(activities.prefix(3), id: \.self) {activity in
                        NavigationLink(destination: ActivityView(data: activity)) {
                            ActivityCard(data: activity)
                                .frame(maxHeight: 80)
                        }
                    }
                    
                    SectionHeader(sectionTitle: "Peripheral", sectionSubTitle: "Not Connected")
                    Button(action: {
                        print("button pressed")
                    }, label: {
                        ZStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: 14)
                                .foregroundStyle(.white)
                            Text("Connect")
                        }
                        .frame(maxHeight: 50)
                        .padding(.horizontal)
                    })
                    
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
