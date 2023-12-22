//
//  MenuView.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 6/2/22.
//

import SwiftUI

struct MenuView: View {
    @State var showSettingsView  : Bool = false
    @State var showAboutView     : Bool = false
    @State var showContentView   : Bool = false
    @State var showDeveloperView : Bool = false
    @State var showFeedbackView  : Bool = false
    @State var showContactView   : Bool = false
    @State var showMenuView  : Bool = true
}

extension MenuView {
    var body: some View {
        ZStack {
            
            Color.appGreen.ignoresSafeArea()
            
            if showSettingsView  { SettingsView        (showMenuView: $showMenuView, showSettingsView:        $showSettingsView ) }
            if showAboutView     { AboutView           (showMenuView: $showMenuView, showAboutView:           $showAboutView    ) }
            if showContentView   { SettingsContentView (showMenuView: $showMenuView, showSettingsContentView: $showContentView  ) }
            if showDeveloperView { DeveloperView       (showMenuView: $showMenuView, showDeveloperView:       $showDeveloperView) }
            if showFeedbackView  { FeedbackView        (showMenuView: $showMenuView, showFeedbackView:        $showFeedbackView ) }
            if showContactView   { ContactView         (showMenuView: $showMenuView, showContactView:         $showContactView  ) }
            if showMenuView      { settingsMain }
        }
    }
}

extension MenuView {
    func menuButton(_ title: String, imageName: String, action: @escaping () -> ()) -> some View {
        return VStack {
            Image(systemName: imageName)
                .font(.largeTitle)
                .padding(4)
            
            Text(title)
                .font(.title2)
        }
        .onTapGesture(perform: action)
        .padding()
    }
    
    var title: some View {
        VStack(spacing: 8) {
            Text("Other Stuff")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.top)
            
            Capsule()
                .frame(height: 2)
                .foregroundColor(.white)
                .padding(.bottom)
                .padding(.horizontal)
        }
    }
    
    var settingsMain: some View {
        ZStack {
            Color.appGreen.ignoresSafeArea()
            
            VStack(spacing: 8) {
                title
                
                HStack {
                    
                    VStack {
                        
                        menuButton("Settings", imageName: "gear") {
                            showSettingsView = true
                            showMenuView = false
                        }
                        
                        menuButton("Content", imageName: "square.text.square") {
                            showContentView = true
                            showMenuView = false
                        }
                        
                        menuButton("Feedback", imageName: "hand.thumbsup") {
                            showFeedbackView = true
                            showMenuView = false
                        }
                    }
                    .padding(.trailing)
                    
                    VStack {
                        menuButton("About", imageName: "questionmark.app") {
                            showAboutView = true
                            showMenuView = false
                        }
                        
                        menuButton("Developer", imageName: "chevron.left.forwardslash.chevron.right") {
                            showDeveloperView = true
                            showMenuView = false
                        }
                        
                        menuButton("Contact", imageName: "person.crop.circle") {
                            showContactView = true
                            showMenuView = false
                        }
                    }
                    .padding(.leading)
                }
                .foregroundColor(.appYellow)
                
                Spacer()
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
