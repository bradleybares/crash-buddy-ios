//
//  ActivityChart.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 10/13/22.
//

import SwiftUI
import Charts

struct ActivityChart: View {
    let data: ActivityData
    let includeCharacteristics: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14).foregroundStyle(.white)
            VStack {
                Chart(data.dataPoints, id: \.date) {
                    LineMark(
                        x: .value("Timestamp", $0.date),
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
                        
                    }.foregroundColor(.black)
                }
            }.padding()
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
        ActivityChart(data: ActivityData.sampleData, includeCharacteristics: false)
            .previewLayout(.fixed(width: 250, height: 250))
        ActivityChart(data: ActivityData.sampleData, includeCharacteristics: true)
            .previewLayout(.fixed(width: 250, height: 250))
    }
}
