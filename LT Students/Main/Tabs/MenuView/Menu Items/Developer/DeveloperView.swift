//
//  DeveloperView.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 6/2/22.
//

import SwiftUI

struct DeveloperView: View {
    @Binding var showMenuView: Bool
    @Binding var showDeveloperView: Bool
}

extension DeveloperView {
    var body: some View {
        ZStack {
            Color.appGreen.ignoresSafeArea()
            
            main
            
            CloseButton(mode: .back, size: .big) { showMenuView = true; showDeveloperView = false; }
        }
    }
}

extension DeveloperView {
    var main: some View {
        VStack {
            title
                .padding(.bottom)
                        
            Text("Hey developers, I need your help with... ")
                .foregroundColor(.white)
                .font(.title2)
                .multilineTextAlignment(.center)
            
            Text("""
1. Getting this app on android devices

2. Expanding this app for other schools

3. Maintaining this app. I'm a sophmore right now, so in a few years I'll be in college, and won't be able to maintain the app myself.

If you can help with any of these, or if you're just looking to get involved, please contact me at lt.app.contact@gmail.com !
""")
                .foregroundColor(.white)
                .font(.body)
                .padding()
            
            Spacer()
        }.padding()
    }
        
    
    var title: some View {
        VStack(spacing: 8) {
            Text("Developer")
                .font(.largeTitle)
            
            Capsule()
                .frame(height: 2)
        }
        .foregroundColor(.white)
        .padding()
        .padding(.horizontal)
    }
}

struct DeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperView(showMenuView: .constant(false), showDeveloperView: .constant(true))
    }
}
