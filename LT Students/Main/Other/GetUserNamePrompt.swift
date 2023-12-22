//
//  GetUserNamePrompt.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 5/29/22.
//

import SwiftUI
import Firebase

struct GetUserNamePrompt: View {
        
    @State var firstName: String = ""
    @State var lastName: String = ""
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .brightness(-0.1)
            
            VStack {
                
                Text("Enter your name")
                    .font(.title)
                
                HStack {
                    
                    Text("First Name:")
                        .font(.title2)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .aspectRatio(6, contentMode: .fit)
                            .foregroundColor(.white)
                        
                        TextField("", text: $firstName).padding(.horizontal).font(.title3)
                    }
                }
                
                HStack {
                    
                    Text("Last Name:")
                        .font(.title2)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .aspectRatio(6, contentMode: .fit)
                            .foregroundColor(.white)
                        
                        TextField("", text: $lastName).padding(.horizontal).font(.title3)
                    }
                }
                
                Text("We just want to make sure you go to our school 😀. After verifying, your app activity will not be tracked, and you'll stay anonymous.")
                    .font(.footnote)
                    .padding(.top)
                
                Spacer()
                
                Button(action: { submitName() }, label: {
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 12)
                            .aspectRatio(4, contentMode: .fit)
                            .foregroundColor(Color(red: 30/255, green: 30/255, blue: 30/255))
                        
                        Text("Submit")
                            .fontWeight(.medium)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                })
            }
            .padding() 
        }
        .aspectRatio(5/5, contentMode: .fit)
        .padding(20)
    }
    
    func submitName() {
        User.instance.first_name = firstName
        User.instance.last_name = lastName
        
        let db = Firestore.firestore()
        db.collection("users").document(User.instance.name).setData([
            "exists" : true
        ])
        
        User.instance.is_initialized = true
    }
}

struct GetUserNamePrompt_Previews: PreviewProvider {
    static var previews: some View {
        GetUserNamePrompt()
    }
}
