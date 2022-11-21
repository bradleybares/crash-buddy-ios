//
//  SettingSensitivitySubView.swift
//  CrashBuddy
//
//  Created by user229036 on 11/1/22.
//

import SwiftUI


struct CrashSensitivityView: View {
    
    @ObservedObject var sensitivityViewModel: SettingSensitivityViewModel
    @ObservedObject var sensitivityModel: SensitivitiesModel
    
    init(sensitivityViewModel: SettingSensitivityViewModel) {
        self.sensitivityViewModel = sensitivityViewModel
        self.sensitivityModel = sensitivityViewModel.sensitivityModel
    }
    
    @State private var showingAddSensitivity = false
    @State private var showingEditSensitivity = false
    
    
    var body: some View {
        Form {
            Section {
                List {
                    ForEach(sensitivityModel.sensitivities)
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
                            sensitivityViewModel.updateSelectedSensitivity(sensitivity: sensitivity)
                            sensitivityViewModel.updateUI()
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            
                            HStack {
                                Button("Edit") {
                                    showingEditSensitivity = true
                                    sensitivityViewModel.selectEditSensitivity = sensitivity
                                }
                                .tint(.blue)
                                
                                
                                Button("Delete", role: .destructive) {
                                    let selectedIndex = sensitivityModel.sensitivities.firstIndex(of: sensitivity )
                                    
                                    sensitivityModel.deleteSensitivity(sensitivity: sensitivity, selectedIndex: selectedIndex ?? 0)
                                }
                            }
                        }
                        .sheet(isPresented: $showingEditSensitivity,
                               onDismiss: sensitivityViewModel.updateUI) {
                            SensitivityEditView(sensitivityViewModel: sensitivityViewModel)
                            
                        }
                    }
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
                           onDismiss: sensitivityViewModel.updateUI) {
                        SensitivityAddView(sensitivityViewModel: sensitivityViewModel)
                    }
                }
            }
        }
    }
}


struct SensitivityAddView: View {
    
    @State var sensitivity: String = ""
    @State var showingAddAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    let sensitivityViewModel: SettingSensitivityViewModel
    
    init(sensitivityViewModel: SettingSensitivityViewModel) {
        self.sensitivityViewModel = sensitivityViewModel
    }
    
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
                        
                        if (!sensitivityViewModel.checkInput(sensitivity: sensitivity))
                        {
                            
                            sensitivityViewModel.checkAddDuplicates(potentialString: sensitivity)
                            
                            if
                                (!sensitivityViewModel.sensitivityModel.getAlreadyAdded()) {
                                presentationMode.wrappedValue.dismiss()
                            }
                            else {
                                showingAddAlert = true
                            }
                            
                        }
                        
                        else {
                            showingAddAlert = true
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
    }
}

struct SensitivityEditView: View {
    
    
    @State var editString: String = ""
    @State var showingAddAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    let sensitivityViewModel: SettingSensitivityViewModel
    
    init(sensitivityViewModel: SettingSensitivityViewModel) {
        self.sensitivityViewModel = sensitivityViewModel
        editString = sensitivityViewModel.editSensitivityString
    }
    
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
                        if (!sensitivityViewModel.checkInput(sensitivity: editString))
                        {
                            
                            sensitivityViewModel.checkEditDuplicates(editString: editString)
                            
                            if
                                (!sensitivityViewModel.sensitivityModel.getAlreadyAdded()) {
                                presentationMode.wrappedValue.dismiss()
                            }
                            else {
                                showingAddAlert = true
                            }
                            
                        }
                        else {
                            showingAddAlert = true
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
        .onAppear() {
            editString = sensitivityViewModel.selectEditSensitivity.value
        }
    }
}

