//
//  SettingDebugSubView.swift
//  CrashBuddy
//
//  Created by Joshua An on 11/1/22.
//

import SwiftUI

enum DebugKeyValue: String {
    case persistentDebugStatus, persistentSensorStatus, presistentMemoryStatus, persistentPowerStatus
}

struct DebugView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero

    @AppStorage(DebugKeyValue.persistentDebugStatus.rawValue) private var debugOn: Bool = true
    @AppStorage(DebugKeyValue.persistentSensorStatus.rawValue) private var sensorStatus: Bool = true
    @AppStorage(DebugKeyValue.presistentMemoryStatus.rawValue) private var memoryStatus: Bool = true
    @AppStorage(DebugKeyValue.persistentPowerStatus.rawValue) private var powerStatus: Bool = true
    
    init(debugOnInit: Bool, sensorStatusInit: Bool, memoryStatusInit: Bool, powerStatusInit: Bool) {
        debugOn = debugOnInit
        sensorStatus = sensorStatusInit
        memoryStatus = memoryStatusInit
        powerStatus = powerStatusInit
    }
    
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
