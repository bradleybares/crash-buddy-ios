//
//  CrashSensitivityView.swift
//  CrashBuddy
//
//  Created by Joshua An on 10/16/22
//

import SwiftUI

struct CrashSensitivityView: View {
    var body: some View {
        NavigationView {

        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Crash Sensitivity").font(.headline)
                    }
                }
            }  
        }
  
    }
}
