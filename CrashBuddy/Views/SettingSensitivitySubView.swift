//
//  SettingSensitivitySubView.swift
//  CrashBuddy
//
//  Created by user229036 on 11/1/22.
//

import SwiftUI


enum SensitivityKeyValue: String {
    case persistentSensitivity, persistentSensitivityList
}


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
    
    @State private var showingAddSensitivity = false
    @State private var showingEditSensitivity = false
    
    @State private var addedSensitivity = ""
    @State private var editedSensitivity = ""
    
    @State private var selectedSensitivity: CrashSensitivity = CrashSensitivity(value: "100")
    @State private var previousSensitivity: CrashSensitivity = CrashSensitivity(value: "100")
    @State private var selectEditSensitivity: CrashSensitivity = CrashSensitivity(value: "100")
    
    @StateObject var crashSensitivitiesObj = CrashSensitivities()
    
    @AppStorage(SensitivityKeyValue.persistentSensitivity.rawValue) private var persistentSensitivity: String = ""
    
    @AppStorage(SensitivityKeyValue.persistentSensitivityList.rawValue) var persistentSensitivityList = ["0", "50", "100"]
    
    func addSensitivity(sensitivity: String) {
        crashSensitivitiesObj.crashSensitivities.append(CrashSensitivity(value: sensitivity))
    }
    
    func updatePersistentList() {
        for individualSensitivity in crashSensitivitiesObj.crashSensitivities {
            if !persistentSensitivityList.contains(individualSensitivity.value) {
                persistentSensitivityList.append(individualSensitivity.value)
            }
        }
    }
    
    func updatePersistentListEdit() {
        for index in 0..<(crashSensitivitiesObj.crashSensitivities.count) {
            if (crashSensitivitiesObj.crashSensitivities[index].value != persistentSensitivityList[index]) {
                persistentSensitivityList[index] = crashSensitivitiesObj.crashSensitivities[index].value
            }
        }
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
                            if sensitivity.isSelected || sensitivity.value == persistentSensitivity {
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
                            persistentSensitivity = sensitivity.value
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
                                    
                                    persistentSensitivityList.remove(at: selectedIndex!)
                                }
                            }
                        }
                        .sheet(isPresented: $showingEditSensitivity,
                        onDismiss: updatePersistentListEdit) {
                            SensitivityEditView(crashSensitivitiesObj: crashSensitivitiesObj, existingSensitivity: selectEditSensitivity)
                            
                        }
                    }
                }
                
                Section {
                    Text("Selected Sensitivity: \(selectedSensitivity.value)")
                    Text("Persisting sensitivity: \(persistentSensitivity)")
                    Text("existing sens list size; \(crashSensitivitiesObj.crashSensitivities.count)")
                    Text("Persisting sens List size: \(persistentSensitivityList.count)")
                }
            }
        }
        .onAppear(){
            for individualSensitivityString in persistentSensitivityList {
                if !(crashSensitivitiesObj.crashSensitivities.contains(CrashSensitivity(value: individualSensitivityString))) {
                    addSensitivity(sensitivity: individualSensitivityString)
                }
            }
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
                    .sheet(isPresented: $showingAddSensitivity,
                    onDismiss: updatePersistentList) {
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

