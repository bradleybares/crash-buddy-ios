//
//  ActivityLogView.swift
//  CrashBuddy
//
//  Created by Matthew Chan on 10/6/22.
//

import SwiftUI

struct ActivityLogView: View {
    var activities: [ActivityDataModel]
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .leading) {
                ScrollView {
                    ForEach(activities, id: \.id) { activity in
                        NavigationLink(destination: ActivityView(data: ActivityData.sampleData)) {
                            ActivityCard(data: ActivityData.sampleData)
                                .frame(maxHeight: 80)
                        }
                    }
                    Spacer()
                }
            }
            .padding(.horizontal)
            .navigationTitle("Activity Log")
        }
    }
}

struct ActivityLogView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityLogView(activities: [ActivityDataModel.sampleData])
    }
}
