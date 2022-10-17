//
//  EmergencyContactsView.swift
//  CrashBuddy
//
//  Created by Joshua An on 10/16/22
//

import SwiftUI

struct EmergencyContactsView: View {
    var body: some View {
        NavigationView {

        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Emergency Contacts").font(.headline)
                    }
                }
            }  
        }    
    }
}
