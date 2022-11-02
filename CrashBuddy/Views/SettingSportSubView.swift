//
//  SettingSportSubView.swift
//  CrashBuddy
//
//  Created by user229036 on 10/31/22.
//


import SwiftUI


class Sports: ObservableObject {
    
    @Published var sports: [Sport]
    
    init() {
        self.sports = []
    }
}


class Sport: Identifiable, Equatable, ObservableObject {
    static func == (lhs: Sport, rhs: Sport) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String = UUID().uuidString
    var name: String
    var isSelected: Bool
    
    init(name: String) {
        self.name = name
        self.isSelected = false
    }
    
}


struct SportsView: View {
    
    @State private var initializeView = false
    @State private var showingAddSport = false
    @State private var showingEditSport = false

    @State private var addedSport = ""
    @State private var editedSport = ""
    
    @State private var selectedSport: Sport = Sport(name: "Skiing")
    @State private var previousSport: Sport = Sport(name: "Skiing")
    @State private var selectEditSport: Sport = Sport(name: "Skiing")

    @StateObject var sportsObj = Sports()
    
    func addSport(name: String) {
        sportsObj.sports.append(Sport(name: name))
    }
    
    var body: some View {
        Form {
            Section {
                List {
                    ForEach(sportsObj.sports)
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
                            previousSport = selectedSport
                            selectedSport = sport
                            previousSport.isSelected = false
                            selectedSport.isSelected = true
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            
                            HStack {
                                Button("Edit") {
                                    selectEditSport = sport
                                    showingEditSport = true

                                    sportsObj.sports = sportsObj.sports.reversed()
                                    sportsObj.sports = sportsObj.sports.reversed()

                                }
                                .tint(.blue)
                                
                                
                                Button("Delete", role: .destructive) {
                                    let selectedIndex = sportsObj.sports.firstIndex(of: sport )
                                    
                                    if sport.isSelected {
                                        selectedSport = Sport(name: "")
                                        
                                    }
                                    sportsObj.sports.remove(at: selectedIndex!)
                                }
                            }
                        }
                        .sheet(isPresented: $showingEditSport) {
                            SportEditView(sportsObj: sportsObj, existingSport: selectEditSport)
                            
                        }
                    }
                }
                
                Section {
                    Text("Selected sport: \(selectedSport.name)")
                }
            }
        }
        .onAppear(){
            if (!initializeView) {
                addSport(name: "Skiing")
                addSport(name: "Biking")
                addSport(name: "Snowboarding")
            }
            initializeView = true
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
                    .sheet(isPresented: $showingAddSport) {
                        SportAddView(sportsObj: sportsObj, sport: "")
                    }
                    
                    
                }
            }
        }
    }
}


struct SportAddView: View {
    
    @StateObject var sportsObj = Sports()
    @State var sport: String
    @State var showingAddAlert = false
    @State var showView = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .leading) {
                        TextField("Enter sport", text: $sport)
                    }
                }
                Section {
                    Button("Add") {
                        checkDuplicates()
                    }
                    Button("Cancel", role: .cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .tint(.red)
                }
                
            }
        }
        .alert(isPresented: $showingAddAlert) {
            Alert(title: Text("Duplicate Entry"), message: Text("Entry already present and will not be added"))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Add Sport").font(.headline)
            }
            
        }
        .environmentObject(sportsObj)
    }
    
    
    
    func checkDuplicates() {
        var alreadyAdded = false
        for existingSport in sportsObj.sports {
            if (sport == existingSport.name) {
                alreadyAdded = true
            }
        }
        
        if (!alreadyAdded) {
            sportsObj.sports.append(Sport(name: sport))
            presentationMode.wrappedValue.dismiss()
            
        }
        
        else {
            showingAddAlert = true
        }
        sport = ""
    }
}

struct SportEditView: View {
    
    @StateObject var sportsObj = Sports()
    
    @State var editString: String = ""
    @State var existingSport: Sport

    @State var showingAddAlert = false
    @State var showView = false
    @Environment(\.presentationMode) var presentationMode
    
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
                        checkEditDuplicates()
                    }
                    Button("Cancel", role: .cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .tint(.red)
                }
                
            }
        }
        .alert(isPresented: $showingAddAlert) {
            Alert(title: Text("Duplicate Entry"), message: Text("Entry already present and will not be added"))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Edit Sport").font(.headline)
            }
            
        }
        .environmentObject(sportsObj)
        .onAppear() {
            editString = existingSport.name
        }
    }
    

    func checkEditDuplicates() {
        var alreadyAdded = false
        for existingSport in sportsObj.sports {
            if (editString == existingSport.name) {
                alreadyAdded = true
            }
        }
        
        if (!alreadyAdded) {
            
            var sportIndex: Int {
                sportsObj.sports.firstIndex(where: { $0.name == existingSport.name })!}

            sportsObj.sports[sportIndex].name = editString

            sportsObj.sports = sportsObj.sports.reversed()
            sportsObj.sports = sportsObj.sports.reversed()
            
            presentationMode.wrappedValue.dismiss()
            
        }
        
        else {
            showingAddAlert = true
        }
    }
}

