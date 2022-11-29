//
//  SettingSportSubView.swift
//  CrashBuddy
//
//  Created by Joshua An on 10/31/22.
//


import SwiftUI


struct SettingsActivityProfilesView: View {
    
    @StateObject var activityProfilesViewModel: SettingsActivityProfilesViewModel

    var body: some View {
        Form {
            Section {
                List {
                    ForEach(activityProfilesViewModel.activityProfiles) { activityProfile in
                        ActivityProfileCard(activityProfile: activityProfile)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            HStack {
                                Button("Edit") {
                                    activityProfilesViewModel.editingActivityProfile = activityProfile
                                    activityProfilesViewModel.isShowingActivityProfileSheet = true
                                }
                                .tint(.blue)
                                
                                Button("Delete", role: .destructive) {
                                    activityProfilesViewModel.deleteProfile(id: activityProfile.id)
                                }
                            }
                        }
                    }
                }
            }
            Button("Add Profile") {
                activityProfilesViewModel.isShowingActivityProfileSheet = true
            }
        }
        .navigationBarTitle("Activity Profiles")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $activityProfilesViewModel.isShowingActivityProfileSheet, onDismiss: {activityProfilesViewModel.editingActivityProfile = nil}) {
            ActivityProfileSheet(activityProfilesViewModel: activityProfilesViewModel)
        }
    }
}


struct ActivityProfileCard: View {
    
    let activityProfile: ActivityProfile
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(activityProfile.name)
                    .font(.headline)
                Text("Threshold: \(activityProfile.thresholdString)Gs")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(activityProfile.emoji)
                .font(.system(size: 32))
        }
    }
}


struct ActivityProfileSheet: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var activityName: String = ""
    @State private var activityEmoji: String = ""
    @State private var activityThreshold: String = ""
    
    let activityProfilesViewModel: SettingsActivityProfilesViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section("Sport") {
                    TextField(
                        "Required",
                        text: $activityName
                    )
                    .disableAutocorrection(true)
                }
                Section("Emoji") {
                    TextField(
                        "Required",
                        text: $activityEmoji
                    )
                    .disableAutocorrection(true)
                }
                Section("Threshold") {
                    TextField(
                        "Required",
                        text: $activityThreshold
                    )
                    .disableAutocorrection(true)
                }
            }
            .navigationBarTitle((activityProfilesViewModel.editingActivityProfile != nil) ? "Edit Profile" : "Add Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button((activityProfilesViewModel.editingActivityProfile != nil) ? "Done" : "Add") {
                        if let editingActivityProfile = activityProfilesViewModel.editingActivityProfile {
                            activityProfilesViewModel.editProfile(id: editingActivityProfile.id, newName: activityName, newEmoji: activityEmoji, newThreshold: Int(activityThreshold)!)
                            
                        } else {
                            activityProfilesViewModel.addProfile(
                                newName: activityName,
                                newEmoji: activityEmoji,
                                newThreshold: Int(activityThreshold)!
                            )
                        }
                        dismiss()
                    }
                    .disabled(activityName == "" || activityEmoji == "" || activityThreshold == "")
                }
            }
            .onAppear() {
                if let editingActivityProfile = activityProfilesViewModel.editingActivityProfile {
                    activityName = editingActivityProfile.name
                    activityEmoji = editingActivityProfile.emoji
                    activityThreshold = editingActivityProfile.thresholdString
                }
            }
        }
    }
}

struct SettingsActivityProfilesView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsActivityProfilesView(activityProfilesViewModel: SettingsActivityProfilesViewModel(activitiesProfilesModel: ActivityProfilesModel()))
    }
}
