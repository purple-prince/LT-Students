//
//  AboutView.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 6/2/22.
//

import SwiftUI

struct AboutView: View {
    @Binding var showMenuView: Bool
    @Binding var showAboutView: Bool
}

extension AboutView {
    var body: some View {
        ZStack {
            Color.appGreen.ignoresSafeArea()
            
            VStack(spacing: 8) {
                
                Text("About")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Capsule()
                    .frame(height: 2)
                    .foregroundColor(.white)
                
                main
                
                Spacer()
            }
            .padding()
            
            CloseButton(mode: .back, size: .big) { showMenuView = true; showAboutView = false; }
        }
    }
}

extension AboutView {
    var main: some View {
        VStack {
            
            DisclosureGroup(content: {
                Text(""" removed
""")
                .fontWeight(.light)
                .font(.callout)
                .multilineTextAlignment(.leading)
                .padding(.vertical)
            }, label: {
                Text("Purpose")
                    .fontWeight(.medium)
                    .font(.title)
                    .padding(.horizontal)
            })
            
            DisclosureGroup(content: {
                Text("""
removed""")
                .fontWeight(.light)
                .font(.callout)
                .multilineTextAlignment(.leading)
                .padding(.vertical)
            }, label: {
                Text("Who Made This?")
                    .fontWeight(.medium)
                    .font(.title)
                    .padding(.horizontal)
            })
            
            DisclosureGroup(content: {
                Image("insta_icon")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .onTapGesture {
                        openInstagramProfile()
                    }
                    .padding()
            }, label: {
                Text("Socials")
                    .fontWeight(.medium)
                    .font(.title)
                    .padding(.horizontal)
            })
            
            DisclosureGroup(content: {
                Text("""
pp here
""")
                .fontWeight(.light)
                .font(.callout)
                .multilineTextAlignment(.leading)
                .padding(.vertical)
            }, label: {
                Text("Privacy")
                    .fontWeight(.medium)
                    .font(.title)
                    .padding(.horizontal)
            })
            
            DisclosureGroup(content: {
                Text("""
toes here
""")
                .fontWeight(.light)
                .font(.callout)
                .multilineTextAlignment(.leading)
                .padding(.vertical)
            }, label: {
                Text("Terms Of Service")
                    .fontWeight(.medium)
                    .font(.title)
                    .padding(.horizontal)
            })
            

        }
        .padding(.vertical)
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

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView(showMenuView: .constant(false), showAboutView: .constant(true))
    }
}
