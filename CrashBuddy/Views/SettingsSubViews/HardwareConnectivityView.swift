//
//  HardwareConnectivityView.swift
//  CrashBuddy
//
//  Created by Joshua An on 10/16/22
//

import SwiftUI

struct HardwareConnectivityView: View {
    var body: some View {
        NavigationView {

        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Hardware Connectivity").font(.headline)
                    }
                }
            }  
        }       
    }
}
