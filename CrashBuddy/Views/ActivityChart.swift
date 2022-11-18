//
//  ActivityChart.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 10/13/22.
//

import SwiftUI
import Charts

struct ActivityChart: View {
    let data: ActivityDataModel
    let loading: Bool
    let includeCharacteristics: Bool
    
    init(data: ActivityDataModel, includeCharacteristics: Bool = false, loading: Bool = false) {
        self.data = data
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
                    Chart(data.dataPoints, id: \.dateTime) {
                        LineMark(
                            x: .value("Timestamp", $0.dateTime),
                            y: .value("Gs", $0.accelerometerReading)
                        )
                        RuleMark(
                            y: .value("Threshold", 90)
                        ).foregroundStyle(.red)
                    }
                    if includeCharacteristics {
                        Divider()
                        HStack {
                            let hours = Int(data.totalTime) / 3600
                            let minutes = Int(data.totalTime) / 60 % 60
                            let seconds = Int(data.totalTime) % 60
                            ChartCharacteristic(title: "Total Time", value: String(format:"%02i:%02i:%02i", hours, minutes, seconds))
                            Spacer()
                            ChartCharacteristic(title: "Average Accel.", value: String(format: "%.2f", data.avgAccel) + "G")
                            Spacer()
                            ChartCharacteristic(title: "Max Accel.", value: String(format: "%.2f", data.maxAccel) + "G")
                            
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

struct ActivityChart_Previews: PreviewProvider {
    static var previews: some View {
        ActivityChart(data: ActivityDataModel.sampleData)
            .previewLayout(.fixed(width: 250, height: 250))
        ActivityChart(data: ActivityDataModel.sampleData, includeCharacteristics: true)
            .previewLayout(.fixed(width: 250, height: 250))
        ActivityChart(data: ActivityDataModel.sampleData, loading: true)
            .previewLayout(.fixed(width: 250, height: 250))
    }
}
