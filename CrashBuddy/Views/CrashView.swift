//
//  CrashView.swift
//  CrashBuddy
//
//  Created by Matthew Chan on 10/17/22.
//

import SwiftUI

struct CrashView: View {
    let data: CrashDataModel
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .leading) {
                Text(data.dataPoints[0].dateTime.formatted(.dateTime.day().month().year().hour().minute().second()))
                    .font(.headline)
                    .padding(.leading)
                CrashChart(data: data)
                    .padding(.horizontal)
                StatSection(statName: "Total Time", statVal: "\(Int(data.totalTime) / 3600) hr \(Int(data.totalTime) / 60 % 60) min")
                    .padding(.horizontal)
                    .frame(maxHeight: 80)
                StatSection(statName: "Average Acceleration", statVal: "\(String(format: "%.2f", data.avgAccel)) G")
                    .padding(.horizontal)
                    .frame(maxHeight: 80)
                StatSection(statName: "Max Acceleration", statVal: "\(String(format: "%.2f", data.maxAccel)) G")
                    .padding(.horizontal)
                    .frame(maxHeight: 80)
                Spacer()
            }
            .navigationTitle("Snowboarding")
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
        CrashView(data: CrashDataModel.sampleData)
    }
}
