//
//  SportsView.swift
//  CrashBuddy
//
//  Created by Joshua An on 10/16/22
//

import SwiftUI

struct Sport: Identifiable {
    let id = UUID()
    let name: String
}

struct SportsView: View {

    @State private var showingAlert = false 
    @State private var addedSport = ""

    @State var sports = [
        Sport(name: "Skiing"),
        Sport(name: "Biking"),
        Sport(name: "Snowboarding")
    ]

    func addSport(name: String){
        sports.append(Sport(name: name))
    }

    var body: some View {
        NavigationView {

        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Sports").font(.headline)
                    }
                }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Add") {
                        showingAlert = true
                    }
                    .alert("Add Sport", isPresented:$showingAlert, actions: {

                    {
                        TextField("", text: $addedSport)
                        Button("Cancel", role: .cancel, action: {})
                        Button("Add", action: {
                            addSport($addedSport)
                        })
                        

                    }, message: {Text("Unable to edit after adding.")}) 
                        
                    }
                }
            }  
        }  
    }
}

