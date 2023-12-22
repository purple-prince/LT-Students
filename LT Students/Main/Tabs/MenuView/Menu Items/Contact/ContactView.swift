//
//  ContactView.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 6/2/22.
//

import SwiftUI

struct ContactView: View {
    @Binding var showMenuView: Bool
    @Binding var showContactView: Bool
}

extension ContactView {
    var body: some View {
        ZStack {
            Color.appGreen.ignoresSafeArea()
            
            main
            
            CloseButton(mode: .back, size: .big) { showMenuView = true; showContactView = false; }
        }
    }
}

extension ContactView {
    var main: some View {
        VStack {
            
            title
            
            Spacer()
            
            VStack {
                HStack {
                    Text("Students: ")
                    Text("hmu on ig")
                        .fontWeight(.thin)
                    Image("insta_icon")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .onTapGesture {
                            openInstagramProfile()
                        }
                    
                    Spacer()
                }
                
                HStack {
                    Text("Others: ") + Text("We'd love to hear from you! We're a small team, but we'll do our best to get back to you within 5 business days.")
                        .fontWeight(.thin)
                    
                    Spacer()
                }
                .padding(.vertical)
                
                emailButton
                    .padding(.top)
            }
            .padding()
            
            Spacer()
            
            Spacer()
            
            
        }
        .foregroundColor(.white)
    }
    
    var emailButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
                .brightness(-0.2)
                .frame(width: 300, height: 56)
            
            HStack {
                
                Spacer()
                
                Image(systemName: "envelope")
                    .font(.title2)
                    .foregroundColor(.appGreen)
                    .brightness(0.1)
                    .padding(5)
                    .background(
                        Circle()
                            .foregroundColor(.white)
                            .brightness(-0.3)
                            .scaleEffect(1.2)
                        
                    )
                
                Text("lt.app.contact@gmail.com")
                    .foregroundColor(.black)
                    .textSelection(.enabled)
                
                Spacer()
                
            }
        }
    }
    
    var title: some View {
        VStack(spacing: 8) {
            Text("Contact")
                .font(.largeTitle)
            Capsule()
                .frame(height: 2)
        }
        .padding()
        .foregroundColor(.white)
    }
    
    func openInstagramProfile() {
        let hook = "https://www.instagram.com/removed/"
        let url = URL(string: hook)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.open(URL(string: hook)!)
        }
    }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView(showMenuView: .constant(false), showContactView: .constant(true))
    }
}
