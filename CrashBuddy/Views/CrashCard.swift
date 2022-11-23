//
//  CrashCard.swift
//  CrashBuddy
//
//  Created by Matthew Chan on 10/17/22.
//

import SwiftUI

struct CrashCard: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    var crashData: CrashDataModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(Color.componentBackground)
                .frame(maxHeight: 80)
            HStack {
                Text(crashData.activity.emoji)
                    .font(.system(size: 36))
                    .padding(.leading)
                Divider()
                VStack(alignment: .leading) {
                    Text(crashData.activity.name)
                        .font(.title)
                    HStack {
                        Text("\(Int(crashData.maxAccel))G")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.red)
                        Spacer()
                        Text(crashData.dataPoints[0].dateTime.formatted(date: .numeric, time: .shortened))
                            .font(.subheadline)
                        Image(systemName: "chevron.right")
                    }
                }
            }
            .padding(.vertical)
            .foregroundColor(Color.componentForeground)
        }
    }
}

struct CrashCard_Previews: PreviewProvider {
    static var previews: some View {
        CrashCard(crashData: CrashDataModel.sampleData).frame(maxHeight: 80)
    }
}
