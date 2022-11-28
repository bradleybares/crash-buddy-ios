//
//  CrashView.swift
//  CrashBuddy
//
//  Created by Matthew Chan on 10/17/22.
//

import SwiftUI

struct CrashView: View {
    let crashData: CrashDataModel
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .leading) {
                Text(crashData.dataPoints[0].dateTime.formatted(.dateTime.day().month().year().hour().minute().second()))
                    .font(.headline)
                CrashChart(crashData: crashData)
                    .frame(maxHeight: 320)
                StatSection(statName: "Location", statVal: "(\(crashData.longitude),\(crashData.latitude)")
                    .frame(maxHeight: 80)
                StatSection(statName: "Total Time", statVal: "\(Int(crashData.totalTime) / 3600) hr \(Int(crashData.totalTime) / 60 % 60) min")
                    .frame(maxHeight: 80)
                StatSection(statName: "Average Acceleration", statVal: "\(String(format: "%.2f", crashData.avgAccel)) G")
                    .frame(maxHeight: 80)
                StatSection(statName: "Max Acceleration", statVal: "\(String(format: "%.2f", crashData.maxAccel)) G")
                    .frame(maxHeight: 80)
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle(crashData.activity.name)
        }
    }
}

struct StatSection<Content: View>: View {
    let statName: String
    let statVal: String
    @ViewBuilder let content: Content
    
    init(statName: String, statVal: String, content: Content = Spacer()) {
        self.statName = statName
        self.statVal = statVal
        self.content = content
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .foregroundColor(.white)
            HStack {
                
                VStack(alignment: .leading) {
                    Text(statName)
                        .multilineTextAlignment(.leading)
                        .fontWeight(.bold)
                        .padding(.top)
                    content
                    Text(statVal)
                    
                        .padding(.bottom)
                }
                Spacer()
            }
            .padding(.leading)
        }
    }
}

struct CrashView_Previews: PreviewProvider {
    static var previews: some View {
        CrashView(crashData: CrashDataModel.sampleData)
    }
}
