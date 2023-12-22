//
//  SettingsView.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 6/2/22.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showMenuView: Bool
    @Binding var showSettingsView: Bool
    @AppStorage("haptics_on") var haptics_on: Bool = true
}

extension SettingsView {
    var body: some View {
        ZStack {
            Color.appGreen.ignoresSafeArea()
            
            main
            
            CloseButton(mode: .back, size: .big) { showMenuView = true; showSettingsView = false; }
        }
    }
}

extension SettingsView {
    var main: some View {
        VStack(spacing: 12) {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.medium)
                .foregroundColor(.white)
            
            Capsule()
                .frame(height: 2)
                .foregroundColor(.white)
            
            settingsList
            
            Spacer()
        }
        .padding()
    }
    
    var settingsList: some View {
        VStack {
            BoolSettingsOption(title: "Vibrations", selection: User.instance.$haptics_on)
        }
    }
}

struct BoolSettingsOption: View {
    var title: String
    @Binding var selection: Bool
    //var action: () -> ()
    
    var body: some View {
        HStack {

            Text(title)
                .font(.title)
                .foregroundColor(.white)
                .fontWeight(.light)
            
            Spacer()
            
            Toggle("", isOn: $selection)
                .frame(width: 43)
                .toggleStyle(SwitchToggleStyle(tint: Color.appYellow))
        }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showMenuView: .constant(false), showSettingsView: .constant(true))
    }
}
