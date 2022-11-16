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

    let debugModelView: SettingDebugViewModel
    
    init(debugModelView: SettingDebugViewModel) {
        self.debugModelView = debugModelView
    }
//    init(debugOnInit: Bool, sensorStatusInit: Bool, memoryStatusInit: Bool) {
//        debugOn = debugOnInit
//        sensorStatus = sensorStatusInit
//        memoryStatus = memoryStatusInit
//    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: Binding.constant(self.debugModelView.debugModel.getDebugStatus()) ,
                           label: {Text("Debug")
                    })
                }
                
                Section {
                    HStack {
                        Text("Sensor Status")
                        Spacer()
                        if self.debugModelView.debugModel.getSensorStatus() {
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
                        if self.debugModelView.debugModel.getMemoryStatus() {
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
