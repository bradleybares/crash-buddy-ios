//
//  SettingDebugSubView.swift
//  CrashBuddy
//
//  Created by Joshua An on 11/1/22.
//

import SwiftUI

struct DebugView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    @State private var debugOn = true
    @State private var sensorStatus = false
    @State private var memoryStatus = true
    @State private var powerStatus = true
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $debugOn,
                           label: {Text("Debug")
                    })
                }
                
                Section {
                    HStack {
                        Text("Sensor Status")
                        Spacer()
                        if sensorStatus {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(Color.green)
                                .frame(alignment: .trailing)

                        }
                        else {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(Color.red)
                                .frame(alignment: .trailing)
                        }
                    }
                    
                    HStack {
                        Text("Memory Status")
                        Spacer()
                        if memoryStatus {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(Color.green)
                                .frame(alignment: .trailing)

                        }
                        else {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(Color.red)
                                .frame(alignment: .trailing)
                        }
                    }
                    
                    HStack {
                        Text("Power Status")
                        Spacer()
                        if powerStatus {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(Color.green)
                                .frame(alignment: .trailing)

                        }
                        else {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(Color.red)
                                .frame(alignment: .trailing)
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Debug").font(.headline)
                }
            }
        }
    }
}
