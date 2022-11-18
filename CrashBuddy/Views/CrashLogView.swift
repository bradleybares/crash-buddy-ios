//
//  CrashLogView.swift
//  CrashBuddy
//
//  Created by Matthew Chan on 10/6/22.
//

import SwiftUI

struct CrashLogView: View {
    var crashes: [CrashDataModel]
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .leading) {
                ForEach(crashes, id: \.id) { crash in
                    NavigationLink(destination: CrashView(data: CrashDataModel.sampleData)) {
                        CrashCard(data: CrashDataModel.sampleData)
                            .frame(maxHeight: 80)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Crash Log")
        }
    }
}

struct CrashLogView_Previews: PreviewProvider {
    static var previews: some View {
        CrashLogView(crashes: [CrashDataModel.sampleData])
    }
}
