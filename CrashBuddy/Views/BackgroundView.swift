//
//  BackgroundView.swift
//  CrashBuddy
//
//  Created by Bradley G Bares on 10/13/22.
//

import SwiftUI

struct BackgroundView: View {
    
    var body: some View {
        
        Color.appBackground.ignoresSafeArea()
        
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
