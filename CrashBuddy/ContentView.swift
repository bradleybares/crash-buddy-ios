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
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack(alignment: .leading) {
                    SectionHeader(sectionTitle: "Recent Activity", sectionSubTitle: "WEDNESDAY, SEP 28")
                    ActivityChart(data: ActivityData.sampleData, includeCharacteristics: true)
                        .padding(.horizontal)
                        
                    SectionHeader(sectionTitle: "Activity Log", sectionToolbarItem:
                        NavigationLink(
                            destination: ActivityLogView(activities: [ActivityData.sampleData]),
                            label: {
                                Text("Show More")
                            }
                        )
                    )
                    ForEach((1...3), id: \.self) {_ in
                        NavigationLink(destination: ActivityView(data: ActivityData.sampleData)) {
                            ActivityCard(data: ActivityData.sampleData)
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
                            SettingsView()
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
        ContentView()
    }
}
