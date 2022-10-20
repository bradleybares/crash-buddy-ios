//
//  ActivityCard.swift
//  CrashBuddy
//
//  Created by Matthew Chan on 10/17/22.
//

import SwiftUI

enum ActivityType {
    case snowboarding, cycling, skiing
}

struct ActivityCard: View {
    var data: ActivityData
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(.white)
                .padding(.horizontal)
                .frame(maxHeight: 80)
            HStack {
                Text("🏂").font(.system(size: 36)).padding(.leading)
                VStack(alignment: .leading) {
                    Text("Snowboarding")
                        .font(.title)
                        .foregroundColor(Color.black)
                    HStack {
                        Text("\(Int(data.maxAccel))G")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.green)
                        Spacer()
                        Text(data.dataPoints[0].date.formatted(date: .numeric, time: .shortened))
                            .font(.subheadline)
                            .foregroundColor(Color.black)
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.black)
                    }
                }
                .padding()
            }
            .padding()
        }
    }
}

struct ActivityCard_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCard(data: ActivityData.sampleData)
    }
}
