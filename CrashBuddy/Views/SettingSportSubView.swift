//
//  SettingSportSubView.swift
//  CrashBuddy
//
//  Created by user229036 on 10/31/22.
//


import SwiftUI


//enum SportKeyValue: String {
//    case persistentSport, persistentSportList
//}
//
//
//class Sports: ObservableObject {
//
//    @Published var sports: [Sport]
//
//    init() {
//        self.sports = []
//    }
//}
//
//
//class Sport: Identifiable, Equatable, ObservableObject {
//    static func == (lhs: Sport, rhs: Sport) -> Bool {
//        lhs.name == rhs.name
//    }
//
//    var id: String = UUID().uuidString
//    var name: String
//    var isSelected: Bool
//
//    init(name: String) {
//        self.name = name
//        self.isSelected = false
//    }
//
//}


struct SportsView: View {
    
    let sportViewModel: SettingSportViewModel
        
    //viewmodel
    @State private var showingAddSport = false
    @State private var showingEditSport = false

    @State private var addedSport = ""
    @State private var editedSport = ""
    
    //model
    @State private var selectedSport: Sport = Sport(name: "Skiing")
    @State private var previousSport: Sport = Sport(name: "Skiing")
    @State private var selectEditSport: Sport = Sport(name: "Skiing")

    //@StateObject var sportsObj = Sports()
    
//    @AppStorage(SportKeyValue.persistentSport.rawValue) private var persistentSport: String = ""
//
//    @AppStorage(SportKeyValue.persistentSportList.rawValue) var persistentSportList = ["Skiing", "Biking", "Snowboarding"]
//
//    func addSport(name: String) {
//        sportsObj.sports.append(Sport(name: name))
//    }
//
//    func updatePersistentList() {
//        for indiviudalSport in sportsObj.sports {
//            if !persistentSportList.contains(indiviudalSport.name) {
//                persistentSportList.append(indiviudalSport.name)
//            }
//        }
//    }
//
//    func updatePersistentListEdit() {
//        for index in 0..<(sportsObj.sports.count) {
//            if (sportsObj.sports[index].name != persistentSportList[index]) {
//                persistentSportList[index] = sportsObj.sports[index].name
//            }
//        }
//    }
    
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
                            if sport.isSelected || sport.name == persistentSport {
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
                            persistentSport = sport.name
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
                                    persistentSportList.remove(at: selectedIndex!)
                                }
                            }
                        }
                        .sheet(isPresented: $showingEditSport, onDismiss: updatePersistentListEdit) {
                            SportEditView(sportsObj: sportsObj, existingSport: selectEditSport)
                            
                        }
                    }
                }
                
                Section {
                    Text("Selected sport: \(selectedSport.name)")
                    Text("Persisting sport: \(persistentSport)")
                    Text("existing sport list size; \(sportsObj.sports.count)")
                    Text("Persisting sport List size: \(persistentSportList.count)")
                }
            }
        }
        .onAppear(){
            for individualSportString in persistentSportList {
                if !(sportsObj.sports.contains(Sport(name: individualSportString))) {
                    addSport(name: individualSportString)
                }
            }
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
                    .sheet(isPresented: $showingAddSport,
                    onDismiss: updatePersistentList) {
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
    
    
    // checkDUplciateEntry
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


extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
