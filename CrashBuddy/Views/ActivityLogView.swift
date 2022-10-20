//
//  ActivityLogView.swift
//  CrashBuddy
//
//  Created by Matthew Chan on 10/6/22.
//

import SwiftUI

struct ActivityLogView: View {
    var activities: [ActivityData]
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .leading) {
                
                ForEach((1...6), id: \.self) {_ in
                    NavigationLink(destination: ActivityView(data: ActivityData.sampleData)) {
                        ActivityCard(data: ActivityData.sampleData)
                            .frame(maxHeight: 80)
                    }
                }
                Spacer()
            }
            .navigationTitle("Activity Log")
        }
    }
}

struct ActivityLogView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityLogView(activities: [ActivityData.sampleData])
    }
}
