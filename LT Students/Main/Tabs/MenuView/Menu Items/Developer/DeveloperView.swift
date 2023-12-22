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
removed
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
