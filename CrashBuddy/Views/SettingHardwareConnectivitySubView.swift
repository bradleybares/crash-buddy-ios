//
//  SettingHardwareConnectivitySubView.swift
//  CrashBuddy
//
//  Created by user229036 on 11/1/22.
//

import SwiftUI


struct HardwareConnectivityView: View {
    
    @State private var showingAlert = false
    @State private var hardwares = ["Hardware 1", "Hardware 2"]
    
    var body: some View {
        
        Form {
            Section {
                ForEach(hardwares, id: \.self) {
                    Text($0)
                }
                .swipeActions(edge: .trailing) {
                    Button("Edit") {
                        print("Edit")
                    }
                    .tint(.blue)
                    Button("Delete", role: .destructive) {
                        print("Delete")
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Hardware Connectivity").font(.headline)
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Add") {
                    showingAlert = true
                }
                .alert("Add Hardware", isPresented:$showingAlert, actions:
                        
                        {
                    Text("Bluetooth Logic here")
                }
                )
            }
        }
    }
}


