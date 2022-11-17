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

//    let debugModelView: SettingDebugViewModel
//
//
//    init(debugModelView: SettingDebugViewModel) {
//        self.debugModelView = debugModelView
//    }
    
    @State private var debugOn: Bool = false
    @State private var sensorStatus: Bool = true
    @State private var memoryStatus: Bool = true
    
    init(debugOnBool: Bool, sensorStatusBool: Bool, memoryStatusBool: Bool) {
        debugOn = debugOnBool
        sensorStatus = sensorStatusBool
        memoryStatus = memoryStatusBool
    }

    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn:
                            $debugOn,
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
