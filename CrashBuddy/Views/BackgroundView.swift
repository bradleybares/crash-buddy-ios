//
//  BackgroundView.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 10/13/22.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Color(red: 242/255, green: 242/255, blue: 247/255).ignoresSafeArea()
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
