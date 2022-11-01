//
//  SettingSubViews.swift
//  CrashBuddy
//
//  Created by Joshua An on 10/17/22.
//

import SwiftUI

//class Sports: ObservableObject {
//
//    @Published var sports: [Sport]
//
//    init() {
//        self.sports = []
//    }
//}
//
//class Sport: Identifiable, Equatable, ObservableObject {
//    static func == (lhs: Sport, rhs: Sport) -> Bool {
//        lhs.id == rhs.id
//    }
//
//    var id: String = UUID().uuidString
//    var name: String
//    var isSelected: Bool
//
//
//    init(name: String) {
//        self.name = name
//        self.isSelected = false
//    }
//
//}

struct EmergencyContact: Identifiable, Hashable {
    let id = UUID()
    
    let name: String
    let phoneNumber: String
    let address: String
    let relationship: String
}

struct EmergencyContactsView: View {
    
    @State var contacts = [
        EmergencyContact(name: "Contact 1", phoneNumber: "1234567689", address: "Address 1", relationship: "Friend"),
        EmergencyContact(name: "Contact 2", phoneNumber: "1112223333", address: "Address 2", relationship: "Sibling"),
        EmergencyContact(name: "Contact 3", phoneNumber: "4445556666", address: "Address 3", relationship: "Mother")
    ]
    //@State private var contact: EmergencyContact = contacts[0]
    @State private var showingAlert = false
    @State private var addedName = ""
    @State private var addedPhoneNumber = ""
    @State private var addedAddress = ""
    @State private var addedRelationship = ""
    @State private var selectedItem = ""
    
    
    func addContact(name: String, phoneNumber: String, address: String, relationship: String) {
        contacts.append(EmergencyContact(name: name, phoneNumber: phoneNumber, address: address, relationship: relationship))
    }
    
    var body: some View {
        Form {
            Section {
                VStack {
                    List {
                        ForEach(contacts, id: \.self)
                        { index in
                            HStack {
                                
                                Text("\(index.name)")
                                Spacer()
                            }
                            
                            .swipeActions(edge: .trailing) {
                                Button("Edit") {
                                    print("Edit")
                                }
                                .tint(.blue)
                                Button("Delete", role: .destructive) {
                                    print("Delete")
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Emergency Contacts").font(.headline)
                }
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Add") {
                    showingAlert = true
                }
                .alert("Add Emergency Contact", isPresented:$showingAlert, actions:
                        
                        {
                    TextField("Name", text: $addedName)
                    TextField("Phone Number", text: $addedPhoneNumber)
                    TextField("Address", text: $addedAddress)
                    TextField("Relationship", text: $addedRelationship)
                    
                    Button("Cancel", role: .cancel, action: {})
                    Button("Add", action: {
                        addContact(name: addedName, phoneNumber: addedPhoneNumber, address: addedAddress, relationship: addedRelationship)
                        addedName = ""
                        addedPhoneNumber = ""
                        addedAddress = ""
                        addedRelationship = ""
                    })
                    
                })
            }
        }
    }
}

struct DebugView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    @State private var debugOn = true
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $debugOn,
                           label: {Text("Debug")
                    })
                }
                
                //TODO change from toggle
                // how exactly do we determine whether this is on or not
                // Does this display only if debug mode is on? or always is it always on display
                Section {
                    Toggle(isOn: $debugOn,
                           label: {Text("Sensor Status")
                    })
                    
                    Toggle(isOn: $debugOn,
                           label: {Text("Memory Status")
                    })
                    
                    Toggle(isOn: $debugOn,
                           label: {Text("Power Status")
                    })
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

struct CrashSensitivityView: View {
    
    @State private var sensitivity = 100
    @State private var showingAlert = false
    @State private var addedSensitivity = ""
    
    @State var sensitivities = ["0", "50", "100"]
    
    func addSensitivity(sensitivity: String) {
        sensitivities.append(sensitivity)
    }
    var body: some View {
        
        Form {
            Section {
                ForEach(sensitivities, id: \.self) {
                    Text($0)
                }
                .swipeActions(edge: .trailing) {
                    Button("Edit") {
                        print("Edit")
                    }
                    .tint(.blue)
                    Button("Delete", role: .destructive) {
                        print("Delete")
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Crash Sensitivity").font(.headline)
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Add") {
                    showingAlert = true
                }
                .alert("Add Crash Sensitivity in G", isPresented:$showingAlert, actions:
                        
                        {
                    TextField("Sensitivity", text: $addedSensitivity)
                    Button("Cancel", role: .cancel, action: {})
                    Button("Add", action: {
                        addSensitivity(sensitivity: addedSensitivity)
                        addedSensitivity = ""
                    })
                })
            }
            
        }
    }
}

struct HardwareConnectivityView: View {
    
    @State private var showingAlert = false
    @State private var hardwares = ["Hardware 1", "Hardware 2"]
    
    var body: some View {
        
        Form {
            Section {
                ForEach(hardwares, id: \.self) {
                    Text($0)
                }
                .swipeActions(edge: .trailing) {
                    Button("Edit") {
                        print("Edit")
                    }
                    .tint(.blue)
                    Button("Delete", role: .destructive) {
                        print("Delete")
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Hardware Connectivity").font(.headline)
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Add") {
                    showingAlert = true
                }
                .alert("Add Hardware", isPresented:$showingAlert, actions:
                        
                        {
                    Text("Bluetooth Logic here")
                }
                )
            }
        }
    }
}

//struct SportsView: View {
//
//    @State private var showingAddAlert = false
//    @State private var showingEditAlert = false
//    @State private var pingDuplicateAlert = false
//    @State private var initializeView = false
//    @State private var showingDetail = false
//
//    @State private var addedSport = ""
//    @State private var editedSport = ""
//    @State private var addAlertMessage = "Add Sport"
//    @State private var duplicateButtonLogic = true
//
//    @State private var selectedSportLabel = ""
//    @State private var selectedSport: Sport = Sport(name: "Skiing")
//    @State private var previousSport: Sport = Sport(name: "Skiing")
//
//    //@EnvironmentObject var sportsObj: Sports
//    @StateObject var sportsObj = Sports()
//
//    var duplicateAlert: Alert {
//        return Alert(title: Text("Duplicate Entry"), message: Text("\(addedSport) already exists."), dismissButton: .cancel())
//    }
//
//    func addSport(name: String) {
//        sportsObj.sports.append(Sport(name: name))
//    }
//
//    var body: some View {
//        Form {
//            Section {
//                List {
//                    ForEach(sportsObj.sports)
//                    { sport in
//                        HStack {
//                            Text("\(sport.name)")
//                                .frame(alignment: .leading)
//                            Spacer()
//                            if sport.isSelected {
//                                Image(systemName: "checkmark")
//                                    .foregroundColor(Color.blue)
//                                    .frame(alignment: .trailing)
//                            }
//
//                        }
//                        .contentShape(Rectangle())
//                        .onTapGesture {
//                            previousSport = selectedSport
//                            selectedSport = sport
//                            previousSport.isSelected = false
//                            selectedSport.isSelected = true
//                        }
//                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
//
//                            HStack {
//                                Button("Edit") {
//                                    print("Edit")
//                                    self.showingEditAlert = true
//                                    editedSport = sport.name
//                                    print(editedSport)
//
//                                }
//
//                                Button("Delete", role: .destructive) {
//                                    let selectedIndex = sportsObj.sports.firstIndex(of: sport )
//
//                                    if sport.isSelected {
//                                        selectedSport = Sport(name: "")
//
//                                    }
//                                    sportsObj.sports.remove(at: selectedIndex!)
//                                }
//
//
//                            }
//                        }
//                    }
//
//                }
//                Text("Selected sport: \(selectedSport.name)")
//            }
//        }
//        .onAppear(){
//            if (!initializeView) {
//                addSport(name: "Skiing")
//                addSport(name: "Biking")
//                addSport(name: "Snowboarding")
//            }
//            initializeView = true
//        }
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .principal) {
//                VStack {
//                    Text("Sports").font(.headline)
//                }
//            }
//
//            ToolbarItemGroup(placement: .navigationBarTrailing) {
//                ZStack {
//
//                    Button("Add") {
//                        showingDetail = true
//                    }
//                    .sheet(isPresented: $showingDetail) {
//                        SportAddView(sportsObj: sportsObj, sport: "")
//                    }
//
//
//                }
//            }
//        }
//    }
//}
//
//
//struct SportAddView: View {
//
//    @StateObject var sportsObj = Sports()
//    @State var sport: String
//    @State var showingAddAlert = false
//    @State var showView = false
//    @Environment(\.presentationMode) var presentationMode
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section {
//                    VStack(alignment: .leading) {
//                        TextField("Enter sport", text: $sport)
//                    }
//                }
//                Section {
//                    Button("Add") {
//                        checkDuplicates()
//                    }
//                    Button("Cancel", role: .cancel) {
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                    .tint(.red)
//                }
//
//            }
//        }
//        .alert(isPresented: $showingAddAlert) {
//            Alert(title: Text("Duplicate Entry"), message: Text("Entry already present and will not be added"))
//        }
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .principal) {
//                Text("Add Sport").font(.headline)
//            }
//
//        }
//        .environmentObject(sportsObj)
//    }
//
//
//
//    func checkDuplicates() {
//        var alreadyAdded = false
//        for existingSport in sportsObj.sports {
//            if (sport == existingSport.name) {
//                alreadyAdded = true
//            }
//        }
//
//        if (!alreadyAdded) {
//            sportsObj.sports.append(Sport(name: sport))
//            presentationMode.wrappedValue.dismiss()
//
//        }
//
//        else {
//            showingAddAlert = true
//        }
//        sport = ""
//    }
//}
//
//struct SportEditView: View {
//
//    @StateObject var sportsObj = Sports()
//    @State var sport: String
//    @State var showingAddAlert = false
//    @State var showView = false
//    @Environment(\.presentationMode) var presentationMode
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section {
//                    VStack(alignment: .leading) {
//                        TextField("Enter sport", text: $sport)
//                    }
//                }
//                Section {
//                    Button("Add") {
//                        checkDuplicates()
//                    }
//                    Button("Cancel", role: .cancel) {
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                    .tint(.red)
//                }
//
//            }
//        }
//        .alert(isPresented: $showingAddAlert) {
//            Alert(title: Text("Duplicate Entry"), message: Text("Entry already present and will not be added"))
//        }
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .principal) {
//                Text("Add Sport").font(.headline)
//            }
//
//        }
//        .environmentObject(sportsObj)
//    }
//
//
//
//    func checkDuplicates() {
//        var alreadyAdded = false
//        for existingSport in sportsObj.sports {
//            if (sport == existingSport.name) {
//                alreadyAdded = true
//            }
//        }
//
//        if (!alreadyAdded) {
//            sportsObj.sports.append(Sport(name: sport))
//            presentationMode.wrappedValue.dismiss()
//
//        }
//
//        else {
//            showingAddAlert = true
//        }
//        sport = ""
//    }
//}
//
