//
//  CrashChart.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 10/13/22.
//

import SwiftUI
import Charts

struct CrashChart: View {
    let crashData: CrashDataModel
    let loading: Bool
    let includeCharacteristics: Bool
    
    init(crashData: CrashDataModel, includeCharacteristics: Bool = false, loading: Bool = false) {
        self.crashData = crashData
        self.loading = loading
        self.includeCharacteristics = includeCharacteristics
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14).foregroundStyle(Color.componentBackground)
            if loading {
                ProgressView().frame(width: 100, height: 100, alignment: .center).scaleEffect(3)
            } else {
                VStack {
                    Chart(crashData.dataPoints, id: \.dateTime) {
                        LineMark(
                            x: .value("Timestamp", $0.dateTime),
                            y: .value("Gs", $0.accelerometerReading)
                        )
                        RuleMark(
                            y: .value("Threshold", crashData
                                .activity.threshold)
                        ).foregroundStyle(.red)
                    }
                    if includeCharacteristics {
                        Divider()
                        HStack {
                            let hours = Int(crashData.totalTime) / 3600
                            let minutes = Int(crashData.totalTime) / 60 % 60
                            let seconds = Int(crashData.totalTime) % 60
                            ChartCharacteristic(title: "Total Time", value: String(format:"%02i:%02i:%02i", hours, minutes, seconds))
                            Spacer()
                            ChartCharacteristic(title: "Average Accel.", value: String(format: "%.2f", crashData.avgAccel) + "G")
                            Spacer()
                            ChartCharacteristic(title: "Max Accel.", value: String(format: "%.2f", crashData.maxAccel) + "G")
                            
                        }
                    }
                }.padding()
            }
        }
    }
    
    struct ChartCharacteristic: View {
        let title: String
        let value: String
        var body: some View {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                Text(value)
                    .font(.headline)
            }
        }
    }
}

struct CrashChart_Previews: PreviewProvider {
    static var previews: some View {
        CrashChart(crashData: CrashDataModel.sampleData)
            .previewLayout(.fixed(width: 250, height: 250))
        CrashChart(crashData: CrashDataModel.sampleData, includeCharacteristics: true)
            .previewLayout(.fixed(width: 250, height: 250))
        CrashChart(crashData: CrashDataModel.sampleData, loading: true)
            .previewLayout(.fixed(width: 250, height: 250))
    }
}
