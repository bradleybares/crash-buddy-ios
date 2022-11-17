//
//  SettingSportSubView.swift
//  CrashBuddy
//
//  Created by user229036 on 10/31/22.
//


import SwiftUI


struct SportsView: View {
    
    @ObservedObject var sportViewModel: SettingSportViewModel
    @ObservedObject var sportModel: SportModel
    
    init(sportViewModel: SettingSportViewModel) {
        self.sportViewModel = sportViewModel
        self.sportModel = sportViewModel.sportModel
    }
    
    @State private var showingAddSport = false
    @State private var showingEditSport = false

    var body: some View {
        Form {
            Section {
                List {
                    ForEach(sportModel.sports)
                    { sport in
                        HStack {
                            Text("\(sport.name)")
                                .frame(alignment: .leading)
                            Spacer()
                            if sport.isSelected {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color.blue)
                                    .frame(alignment: .trailing)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            sportViewModel.updateSelectedSport(sport: sport)
                            sportViewModel.updateUI()
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            
                            HStack {
                                Button("Edit") {
                                    showingEditSport = true

                                    sportViewModel.selectEditSport = sport
                                }
                                .tint(.blue)
                                
                                
                                Button("Delete", role: .destructive) {
                                    let selectedIndex = sportViewModel.sportModel.sports.firstIndex(of: sport )
                                    
                                    sportViewModel.deleteSport(sport: sport, index: selectedIndex ?? 0)
                                }
                            }
                        }
                        .sheet(isPresented: $showingEditSport,
                               onDismiss: sportViewModel.updateUI)
                         {
                            SportEditView(sportViewModel: sportViewModel)
                        }
                    }
                }
                
                Section {
                    Text("Selected sport: \(sportViewModel.sportModel.selectedSport.name)")
                    Text("size list: \(sportViewModel.sportModel.sports.count)")

                }
            }
        }
        .onAppear(){
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Sports").font(.headline)
                }
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                ZStack {
                    
                    Button("Add") {
                        showingAddSport = true
                    }
                    .sheet(isPresented: $showingAddSport, onDismiss: sportViewModel.updateUI)
                    {
                        SportAddView(sportViewModel: sportViewModel)
                    }
                }
            }
        }
    }
}


struct SportAddView: View {
    
    @State var sport: String = ""
    @State var showingAddAlert = false
    @Environment(\.presentationMode) var presentationMode

    let sportViewModel: SettingSportViewModel
    
    init(sportViewModel: SettingSportViewModel) {
        self.sportViewModel = sportViewModel
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .leading) {
                        TextField("Enter sport", text:
                                    $sport
                                  )
                    }
                }
                Section {
                    Button("Add") {
                        sportViewModel.checkAddDuplicates(potentialString: sport)
                        if (!sportViewModel.sportModel.getAlreadyAdded()) {
                                    presentationMode.wrappedValue.dismiss()
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
        .alert(isPresented: $showingAddAlert)
        {
            Alert(title: Text("Duplicate Entry"), message: Text("Entry already present and will not be added"))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Add Sport").font(.headline)
            }
            
        }
    }
}

struct SportEditView: View {
    
    
    @State var editString: String = ""
    @State var showingAddAlert = false
    
    @Environment(\.presentationMode) var presentationMode

    let sportViewModel: SettingSportViewModel
    
    init(sportViewModel: SettingSportViewModel) {
        self.sportViewModel = sportViewModel
        editString = sportViewModel.editSportString
    }
    
    var body: some View {
        
        NavigationView {
            
            Form {
                Section {
                    VStack(alignment: .leading) {
                        TextField("Edit sport", text: $editString)
                    }
                }
                Section {
                    Button("Done") {
                        sportViewModel.checkEditDuplicates(editString: editString)
                        if (!sportViewModel.sportModel.getAlreadyAdded()) {
                                    presentationMode.wrappedValue.dismiss()
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
        .alert(isPresented: $showingAddAlert)
        {
            Alert(title: Text("Duplicate Entry"), message: Text("Entry already present and will not be added"))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Edit Sport").font(.headline)
            }
            
        }
        .onAppear() {
            editString = sportViewModel.selectEditSport.name
        }
    }
}


