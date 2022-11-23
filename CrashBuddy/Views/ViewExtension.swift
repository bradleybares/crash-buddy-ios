//
//  ViewExtension.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 11/26/22.
//

import SwiftUI

extension View {

    func alert(title: String = "", messageContent: some View, dismissButton: CustomAlertButton = CustomAlertButton(title: "ok"), isPresented: Binding<Bool>) -> some View {
        let title   = NSLocalizedString(title, comment: "")
    
        return modifier(CustomAlertModifier(title: title, messageContent: messageContent, dismissButton: dismissButton, isPresented: isPresented))
    }

    func alert(title: String = "", messageContent: some View, primaryButton: CustomAlertButton, secondaryButton: CustomAlertButton, isPresented: Binding<Bool>) -> some View {
        let title   = NSLocalizedString(title, comment: "")
    
        return modifier(CustomAlertModifier(title: title, messageContent: messageContent, primaryButton: primaryButton, secondaryButton: secondaryButton, isPresented: isPresented))
    }
}
