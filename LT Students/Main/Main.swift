//
//  Main.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 5/14/22.
//

import SwiftUI

struct Main: View {
    enum MainTabOptions { case teachers, search, home, menu, polls, shade }
    
    @State var currentTab: MainTabOptions = .home
    @State var showContent: Bool = false
    @State var logoOpacity: Double = 1.0
}

extension Main {
    var body: some View {
        
        ZStack {
            Color.appGreen.ignoresSafeArea()
            
            VStack {
                if currentTab == .home { HomeView() }
                else if currentTab == .teachers { TeacherView() }
                else if currentTab == .menu { MenuView() }
                else if currentTab == .polls { PollsView() }
                else if currentTab == .shade { ShadeView() }
                            
                tabs
            }
            .disabled(!showContent)
            
            if !showContent {
                
                ZStack {
                    Color.appGreen.ignoresSafeArea()
                    
                    Image("logo")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .padding()
                        .padding()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                withAnimation(.linear(duration: 0.3)) { logoOpacity = 0.0 }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { showContent = true }
                            }
                        }
                }
                .opacity(logoOpacity)
            }
        }
    }
    
    var tabs: some View {
        HStack {

            HStack {
                Spacer()
                Image(systemName: currentTab == .home ? "newspaper.fill" : "newspaper")
                    .font(.title)
                    .onTapGesture { currentTab = .home; HapticManager.manager.playHaptic(type: .light) }
                Spacer()
            }
            
            HStack {
                Spacer()
                Image(systemName: currentTab == .shade ? "ellipsis.bubble.fill" : "ellipsis.bubble")
                    .font(.title)
                    .onTapGesture { currentTab = .shade; HapticManager.manager.playHaptic(type: .light) }
                Spacer()
            }
            
            HStack {
                Spacer()
                Image(systemName: currentTab == .teachers ? "person.3.fill" : "person.3")
                    .font(.title)
                    .onTapGesture { currentTab = .teachers; HapticManager.manager.playHaptic(type: .light) }
                Spacer()
            }
            
            HStack {
                Spacer()
                Image(systemName: currentTab == .polls ? "chart.bar.fill" : "chart.bar")
                    .font(.title)
                    .onTapGesture { currentTab = .polls; HapticManager.manager.playHaptic(type: .light) }
                Spacer()
            }
            
            HStack {
                Spacer()
                Image(systemName: "slider.horizontal.3")
                    .font(.title)
                    .onTapGesture { currentTab = .menu; HapticManager.manager.playHaptic(type: .light) }
                Spacer()
            }
        }
        .foregroundColor(.appYellow)
        .background(Color.appGreen.edgesIgnoringSafeArea(.bottom))
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
