//
//  SettingSensitivitySubView.swift
//  CrashBuddy
//
//  Created by user229036 on 11/1/22.
//

import SwiftUI

class CrashSensitivities: ObservableObject {
    
    @Published var crashSensitivities: [CrashSensitivity]
    
    init() {
        self.crashSensitivities = []
    }
}


class CrashSensitivity: Identifiable, Equatable, ObservableObject {
    static func == (lhs: CrashSensitivity, rhs: CrashSensitivity) -> Bool {
        lhs.value == rhs.value
    }
    
    var id: String = UUID().uuidString
    var value: String
    var isSelected: Bool
    
    init(value: String) {
        self.value = value
        self.isSelected = false
    }
    
}


struct CrashSensitivityView: View {
    
    @State private var initializeView = false
    @State private var showingAddSensitivity = false
    @State private var showingEditSensitivity = false
    
    @State private var addedSensitivity = ""
    @State private var editedSensitivity = ""
    
    @State private var selectedSensitivity: CrashSensitivity = CrashSensitivity(value: "100")
    @State private var previousSensitivity: CrashSensitivity = CrashSensitivity(value: "100")
    @State private var selectEditSensitivity: CrashSensitivity = CrashSensitivity(value: "100")
    
    @StateObject var crashSensitivitiesObj = CrashSensitivities()
    
    func addSensitivity(sensitivity: String) {
        crashSensitivitiesObj.crashSensitivities.append(CrashSensitivity(value: sensitivity))
    }
    
    var body: some View {
        Form {
            Section {
                List {
                    ForEach(crashSensitivitiesObj.crashSensitivities)
                    { sensitivity in
                        HStack {
                            Text("\(sensitivity.value)")
                                .frame(alignment: .leading)
                            Spacer()
                            if sensitivity.isSelected {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color.blue)
                                    .frame(alignment: .trailing)
                            }
                            
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            previousSensitivity = selectedSensitivity
                            selectedSensitivity = sensitivity
                            previousSensitivity.isSelected = false
                            selectedSensitivity.isSelected = true
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            
                            HStack {
                                Button("Edit") {
                                    selectEditSensitivity = sensitivity
                                    showingEditSensitivity = true
                                    
                                    crashSensitivitiesObj.crashSensitivities = crashSensitivitiesObj.crashSensitivities.reversed()
                                    crashSensitivitiesObj.crashSensitivities = crashSensitivitiesObj.crashSensitivities.reversed()
                                    
                                }
                                .tint(.blue)
                                
                                
                                Button("Delete", role: .destructive) {
                                    let selectedIndex = crashSensitivitiesObj.crashSensitivities.firstIndex(of: sensitivity )
                                    
                                    if sensitivity.isSelected {
                                        selectedSensitivity = CrashSensitivity(value: "")
                                        
                                    }
                                    crashSensitivitiesObj.crashSensitivities.remove(at: selectedIndex!)
                                }
                            }
                        }
                        .sheet(isPresented: $showingEditSensitivity) {
                            SensitivityEditView(crashSensitivitiesObj: crashSensitivitiesObj, existingSensitivity: selectEditSensitivity)
                            
                        }
                    }
                }
                
                Section {
                    Text("Selected Sensitivity: \(selectedSensitivity.value)")
                }
            }
        }
        .onAppear(){
            if (!initializeView) {
                addSensitivity(sensitivity: "0")
                addSensitivity(sensitivity: "50")
                addSensitivity(sensitivity: "100")
            }
            initializeView = true
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Crash Sensitivities").font(.headline)
                }
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                ZStack {
                    
                    Button("Add") {
                        showingAddSensitivity = true
                    }
                    .sheet(isPresented: $showingAddSensitivity) {
                        SensitivityAddView(crashSensitivitiesObj: crashSensitivitiesObj, sensitivity: "")
                        
                    }
                    
                    
                }
            }
        }
    }
}


struct SensitivityAddView: View {
    
    @StateObject var crashSensitivitiesObj = CrashSensitivities()
    @State var sensitivity: String
    @State var showingAddAlert = false
    @State var showView = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .leading) {
                        TextField("Enter Crash Sensitivity", text: $sensitivity)
                    }
                }
                Section {
                    Button("Add") {
                        if (!checkInput()) {
                            checkDuplicates()
                        }
                    }
                    Button("Cancel", role: .cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .tint(.red)
                }
                
            }
        }
        .alert(isPresented: $showingAddAlert) {
            Alert(title: Text("Invalid Input"), message: Text("The input must be a number that does not already exist."))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Add Crash Sensitivity").font(.headline)
            }
            
        }
        .environmentObject(crashSensitivitiesObj)
    }
    
    func checkInput() -> Bool {
        let testValid = Int(sensitivity) ?? -1
        
        if (testValid < 0) {
            showingAddAlert = true
        }
        
        return testValid < 0
    }
    
    func checkDuplicates() {
        var alreadyAdded = false
        for existingSensitivity in crashSensitivitiesObj.crashSensitivities {
            if (sensitivity == existingSensitivity.value) {
                alreadyAdded = true
            }
        }
        
        if (!alreadyAdded) {
            crashSensitivitiesObj.crashSensitivities.append(CrashSensitivity(value: sensitivity))
            presentationMode.wrappedValue.dismiss()
            
        }
        
        else {
            showingAddAlert = true
        }
        sensitivity = ""
    }
}

struct SensitivityEditView: View {
    
    @StateObject var crashSensitivitiesObj = CrashSensitivities()
    
    @State var editString: String = ""
    @State var existingSensitivity: CrashSensitivity
    
    @State var showingAddAlert = false
    @State var showView = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationView {
            
            Form {
                Section {
                    VStack(alignment: .leading) {
                        TextField("Edit Crash Sensitivity", text: $editString)
                    }
                }
                Section {
                    Button("Done") {
                        if (!checkInput()) {
                            checkEditDuplicates()
                        }
                    }
                    Button("Cancel", role: .cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .tint(.red)
                }
                
            }
        }
        .alert(isPresented: $showingAddAlert) {
            Alert(title: Text("Invalid Input"), message: Text("The input must be a number that does not already exist."))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Edit Crash Sensitivity").font(.headline)
            }
            
        }
        .environmentObject(crashSensitivitiesObj)
        .onAppear() {
            editString = existingSensitivity.value
        }
    }
    
    func checkInput() -> Bool {
        let testValid = Int(editString) ?? -1
        
        if (testValid < 0) {
            showingAddAlert = true
        }
        
        return testValid < 0
    }
    
    func checkEditDuplicates() {
        var alreadyAdded = false
        for existingSensitivity in crashSensitivitiesObj.crashSensitivities {
            if (editString == existingSensitivity.value) {
                alreadyAdded = true
            }
        }
        
        if (!alreadyAdded) {
            
            var sensitivityIndex: Int {
                crashSensitivitiesObj.crashSensitivities.firstIndex(where: { $0.value == existingSensitivity.value })!}
            
            crashSensitivitiesObj.crashSensitivities[sensitivityIndex].value = editString
            
            crashSensitivitiesObj.crashSensitivities = crashSensitivitiesObj.crashSensitivities.reversed()
            crashSensitivitiesObj.crashSensitivities = crashSensitivitiesObj.crashSensitivities.reversed()
            
            presentationMode.wrappedValue.dismiss()
            
        }
        
        else {
            showingAddAlert = true
        }
    }
}

