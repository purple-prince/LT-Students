//
//  SettingsContentView.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 6/2/22.
//

import SwiftUI
import Firebase

struct SettingsContentView: View {
    
    init(showMenuView: Binding<Bool>, showSettingsContentView: Binding<Bool>) {
        UITextView.appearance().backgroundColor = UIColor(Color(red: 217/255, green: 217/255, blue: 217/255))
        self._showMenuView = showMenuView
        self._showSettingsContentView = showSettingsContentView
    }
    
    @Binding var showMenuView: Bool
    @Binding var showSettingsContentView: Bool
    @State var loginState: LoginState = .notTried
    @State var currentTab: Tabs = .create
    @State var user: String = ""
    
    @State var showNewPost: Bool = false
    
    enum LoginState { case notTried, failed, success }
    @State var nameText: String = ""
    @State var passwordText: String = ""
}

extension SettingsContentView {
    var body: some View {
        ZStack {
            Color.appGreen
                .ignoresSafeArea()
            
            if loginState == .success {
                main
            } else {
                loginScreen
            }
            
            CloseButton(mode: .back, size: .big) { showMenuView = true; showSettingsContentView = false; }
            
        }
    }
}

extension SettingsContentView {
    var loginScreen: some View {
        VStack {
            
            Spacer()
            
            Text("Welcome, Content Creators!")
                .fontWeight(.semibold)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding(.vertical)
            
            VStack {
                Text("Enter your full name")
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .brightness(-0.15)
                    
                    TextField("", text: $nameText)
                        .padding(.horizontal)
                        .font(.title2)
                        .foregroundColor(.black)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .submitLabel(.done)
                        
                    if nameText.isEmpty && loginState == .failed {
                        Image(systemName: "exclamationmark.circle")
                            .foregroundColor(.red)
                            .font(.title2)
                            .offset(x: 95)
                    }
                    
                        
                }
                .aspectRatio(6, contentMode: .fit)
                .frame(height: 40)
            }
            .padding(.vertical)
            
            VStack {
                Text("Enter your Content Creator password")
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .brightness(-0.15)
                    
                    TextField("", text: $passwordText)
                        .padding(.horizontal)
                        .font(.title2)
                        .foregroundColor(.black)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .submitLabel(.done)
                    
                    if passwordText.isEmpty && loginState == .failed {
                        Image(systemName: "exclamationmark.circle")
                            .foregroundColor(.red)
                            .font(.title2)
                            .offset(x: 95)
                    }
                }
                .aspectRatio(6, contentMode: .fit)
                .frame(height: 40)
            }
            .padding(.bottom)

            
            if loginState == .failed {
                Text("Contact us on Instagram to reset password")
                    .foregroundColor(Color.red)
                    .brightness(0.25)
            }
                
            
            Spacer()
            
            Button(action: {
                login()
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        //.fill(Color.appYellow.opacity(0.3))
                        .stroke(Color.appYellow, lineWidth: 3)
                        .aspectRatio(3, contentMode: .fit)
                        .frame(height: 80)
                    
                    Text("Log In")
                        .fontWeight(.semibold)
                        .font(.largeTitle)
                        .foregroundColor(.appYellow)
                }
            })
            .ignoresSafeArea(.keyboard, edges: .bottom)
            
            Spacer()
            
        }
        .foregroundColor(.white)
    }
    
    enum Tabs { case stats, create }
    
    var newPostButton: some View {
        HStack {
            
            Spacer()
            
            Button(action: {
                showNewPost = true
            }, label: {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .font(Font.system(size: 44))
            })
        }
        .padding()
    }
    
    var main: some View {
        
        ScrollView {
            if !showNewPost {
                newPostButton
                
                Spacer()
            } else {
                NewPostMakerView(user: $user)
            }
        }
    }
    
    func login() {
        
        
        let db = Firestore.firestore()
        let docRef = db.collection("creators")
        
        docRef.getDocuments { (snapshot, error) in

            if let error = error { print(error.localizedDescription); return }
            else {
                if let snapshot = snapshot {
                    for doc in snapshot.documents {
                        if self.nameText.lowercased() == doc.documentID {
                            if self.passwordText == doc["password"] as? String ?? "" {
                                self.loginState = .success
                                user = nameText.lowercased()
                            }
                        } else {
                            nameText.removeAll()
                            passwordText.removeAll()
                            self.loginState = .failed
                        }
                    }
                }
            }
        }
    }
}

struct NewPostMakerView: View {
    
    @State var submitLoading: Bool = false
    @Binding var user: String
    @State var titleText: String = ""
    @State var contentText: String = ""
    
    var body: some View {
        VStack {
            VStack {
                
                title
                    .padding(.bottom)
                
                titleSection
                
                imageSection
                
                textSection
                
            }
            .padding()
            .foregroundColor(.white)
            
            submitButton
            
            Spacer()
        }
    }
}

extension NewPostMakerView {
    var title: some View {
        Text("New Story")
            .font(.largeTitle)
            .fontWeight(.medium)
    }
    
    var titleSection: some View {
        VStack(alignment: .leading) {
            
            HStack(spacing: 0) {
                Text("Title")
                    .font(.title)
                
                Text("*")
                    .font(.title)
                    .foregroundColor(.red)
                    .brightness(0.15)
                
                Spacer()
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .brightness(-0.15)
                
                TextField("", text: $titleText)
                    .padding(.horizontal)
                    .font(.title2)
                    .foregroundColor(.black)
                    .disableAutocorrection(true)
                    .onChange(of: titleText) { newValue in
                        if titleText.count > 20 {
                            titleText = String(titleText.prefix(20))
                        }
                    }
                    
            }
            .aspectRatio(9, contentMode: .fit)
            .frame(height: 40)
            
            HStack {
                Spacer()
                Text(String(titleText.count) + "/20")
            }
        }
    }
    
    var imageSection: some View {
        VStack {
            HStack {
                
                HStack {
                    Text("Image")
                        .font(.title)
                    
                    Spacer()
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white, lineWidth: 2)
                        
                }
                .aspectRatio(7, contentMode: .fit)
                .frame(height: 60)
            }
        }
    }
    
    var textSection: some View {
        VStack(alignment: .leading) {
            
            HStack(spacing: 0) {
                Text("Content")
                    .font(.title)
                
                Text("*")
                    .font(.title)
                    .foregroundColor(.red)
                    .brightness(0.15)
                
                Spacer()
            }
            
            ZStack {
                TextEditor(text: $contentText)
                    .font(.title3)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .disableAutocorrection(true)
                    .onChange(of: contentText) { newValue in
                        if contentText.count > 500 {
                            contentText = String(contentText.prefix(500))
                        }
                    }
            }
            .aspectRatio(6/5, contentMode: .fit)
            
            HStack {
                Spacer()
                Text(String(contentText.count) + "/500")
            }
        }
    }
    
    var submitButton: some View {
        Button(action: {
            submitPost()
        }, label: {
            ZStack {
                
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white, lineWidth: 2)
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appGreen)
                
                Text("Post")
                    .foregroundColor(.appYellow)
                    .font(.title)
            }
            .aspectRatio(3, contentMode: .fit)
            .frame(height: 66)
        })
    }
    
    func submitPost() {
        
        var role: String = ""
        submitLoading = true
        let db = Firestore.firestore()
        let docRef = db.collection("creators").document(user).collection("stories")
        
        docRef.document(titleText).setData([
            "content" : contentText
        ])
        

        
        let otherDocRef = db.collection("storiesForReview")
        
        db.collection("creators").getDocuments { (snapshot, error) in
            if let error = error { print(error.localizedDescription); return }
            if let snapshot = snapshot {
                role = snapshot.documents.first!["role"] as? String ?? "error"
            }
            
            otherDocRef.document().setData([
                "title" : titleText,
                "author" : user,
                "timestamp" : Timestamp(date: .now),
                "text" : contentText,
                "topic" : role,
                "views" : 0,
            ])
            
            submitLoading = false
            
        }
    }
}

struct SettingsContentView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsContentView(showMenuView: .constant(false), showSettingsContentView: .constant(true))
    }
}
