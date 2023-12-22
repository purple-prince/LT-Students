//
//  AddShadeSheet.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 7/6/22.
//

import SwiftUI
import Firebase

struct AddShadeSheet: View {
    
    init(showPostPopup: Binding<Bool>) {
        UITextView.appearance().backgroundColor = .clear
        
        self.rewardAd = RewardedAd()
        rewardAd.load()
        
        self._showPostPopup = showPostPopup
            
    }
    
    @Binding var showPostPopup: Bool
    @State var showConfirmAdPopup: Bool = false
    @State var nameText: String = "anonymous"
    @State var shadeText: String = ""
    @State var adWatched: Bool = false
    @State var confirmAdPopupVerticalOffset: Double = 0.0
    @State var gradeForPost: String = ""//"senior"
    @State var gradePickerOffset: Double = -70
    
    var rewardAd: RewardedAd
    
    @State var showNameError: Bool = false
    @State var showTextError: Bool = false
    @State var showGradeError: Bool = false
}

extension AddShadeSheet {
    var body: some View {
        ZStack {
            
            Color.appGreen
                .ignoresSafeArea()
                .brightness(showConfirmAdPopup ? 0 : 0.1)

            if adWatched {
                adCompleteView
            } else {
                mainSheetView
            }
            
            if showConfirmAdPopup { confirmAdPopup }
                        
        }
        .onAppear { confirmAdPopupVerticalOffset = -550; rewardAd.load() }
        .onDisappear { showConfirmAdPopup = false; if !showPostPopup { nameText = "anonymous"; shadeText = ""; } }
    }
}

extension AddShadeSheet {
    var adCompleteView: some View {
        VStack {
            Text("Post Complete")
                .foregroundColor(.white)
                .font(.largeTitle)
                .fontWeight(.medium)

            Button(action: {showPostPopup = false}, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.white)

                    Text("Done")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.appGreen)
                }
                .aspectRatio(3, contentMode: .fit)
                .frame(height: 60)

            })
            .onDisappear { adWatched = false }
        }
    }
    
    var mainSheetView: some View {
        VStack {

        Text("New Post")
            .fontWeight(.semibold)
            .font(.largeTitle)

//            Text("change this sheet size with .presentationDetents() once ios16 is released")
//                .font(.footnote)

            HStack {
                VStack(alignment: .leading) {

                    Text("Display Name")
                        .font(.title2)
                        .foregroundColor(.white)

                    ZStack(alignment: .leading) {

                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(.white)
                            .brightness(-0.1)
                            .frame(height: 32)
                            .aspectRatio(5, contentMode: .fit)

                        TextField("", text: $nameText)
                            .onChange(of: nameText) { newValue in
                                nameText = String(nameText.prefix(12))
                                if nameText.count > 0 { showNameError = false }
                            }
                            .padding(.horizontal)
                            .foregroundColor(.black)
                            .submitLabel(.done)
                            .border(showNameError ? Color.red : Color.clear)
                    }
                    
                    //Text("SDOFHD SDJFN".split)
                }

                Spacer()

                VStack {

                    Text("Grade")
                        .font(.title2)
                        .foregroundColor(.white)

                    gradePicker
                        
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(showGradeError ? Color.red : Color.clear, lineWidth: 2)
                        .scaleEffect(1.1)
                        //.offset(x: -10)
                )


            }
            .padding()

            VStack(alignment: .leading) {
                Text("Shade")
                    .foregroundColor(.white)
                    .font(.title2)

                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(.white)
                        .brightness(-0.1)


                    TextEditor(text: $shadeText)
                        .onChange(of: shadeText) { newValue in
                            shadeText = String(shadeText.prefix(100))
                            if shadeText.count > 0 { showTextError = false }
                            
                        }
                        .foregroundColor(.black)
                        .padding(4)
                        .border(showTextError ? Color.red : Color.clear, width: 3)

                }
                .aspectRatio(32/10, contentMode: .fit)

                HStack {
                    Spacer()
                    Text(String(shadeText.count) + "/100")
                        .foregroundColor(.white)
                }
            }
            .padding()
            
            confirmAdPopupButton
            
            Spacer()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .blur(radius: showConfirmAdPopup ? 5 : 0)
        .brightness(showConfirmAdPopup ? -0.1 : 0)
        .padding(.top)
        .padding(.top)
    }
    
    func postButtonAction() {
        if nameText != "" && gradeForPost != "" && shadeText != "" {
            showConfirmAdPopup = true
        } else {
            if nameText == "" { showNameError = true }
            if gradeForPost == "" { showGradeError = true }
            if shadeText == "" { showTextError = true }
        }
    }
    
    var confirmAdPopupButton: some View {
        Button(action: {
            postButtonAction()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.appYellow)
                Text("Post")
                    .fontWeight(.semibold)
                    .foregroundColor(.appGreen)
                    .font(.title)
            }
            .aspectRatio(2, contentMode: .fit)
            .frame(height: 72)
            .padding()
        })
    }
    
    var confirmAdPopup: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.appYellow, lineWidth: 2)
            
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.appGreen)
            
            VStack {
                Text("Watch ad to post?")
                    .foregroundColor(.white)
                    .font(.title)
                
                Spacer()
                
                adButton
            }
            .padding()
            
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .font(Font.system(size: 32))
                        .padding()
                        .foregroundColor(.appYellow)
                        .onTapGesture { adPopupDismissAnimation() }
                }
                Spacer()
            }
        }
        .offset(y: confirmAdPopupVerticalOffset)
        .aspectRatio(23/10, contentMode: .fit)
        .padding()
        .onAppear {
            confirmAdPopupEntryAnimation()
        }
    }
    
    var adButton: some View {
        Button(action: {
            self.rewardAd.showAd(rewardFunction: {
                uploadPost()
                adWatched = true
                print("SUCCESS")
            })
        }, label: {
            ZStack {
                
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appYellow, lineWidth: 2)
                
                Image(systemName: "arrowtriangle.right.fill")
                    .font(.title)
            }
            .aspectRatio(2, contentMode: .fit)
            .frame(height: 60)
            .foregroundColor(.appYellow)
        })
    }
    
    var gradePicker: some View {
        ZStack {
            
            if gradeForPost != "" {
                RoundedRectangle(cornerRadius: 4)
                    .offset(x: gradePickerOffset)
                    .foregroundColor(.appYellow)
                    .aspectRatio(2, contentMode: .fit)
                    .frame(height: 20)
            }
            
            HStack(spacing: 14) {
                Text("Senr")
                    .font(Font.system(size: 15))
                    .foregroundColor(gradeForPost == "senior" ? .black : .white)
                    .onTapGesture {
                        gradeForPost = "senior"
                        withAnimation(.easeOut) { gradePickerOffset = -70 }
                        showGradeError = false
                    }
                
                Text("Junr")
                    .font(Font.system(size: 15))
                    .foregroundColor(gradeForPost == "junior" ? .black : .white)
                    .onTapGesture {
                        gradeForPost = "junior"
                        withAnimation(.easeOut) { gradePickerOffset = -25 }
                        showGradeError = false
                    }
                
                Text("Soph")
                    .font(Font.system(size: 15))
                    .foregroundColor(gradeForPost == "sophmore" ? .black : .white)
                    .onTapGesture {
                        gradeForPost = "sophmore"
                        withAnimation(.easeOut) { gradePickerOffset = 23 }
                        showGradeError = false
                    }
                
                Text("Frsh")
                    .font(Font.system(size: 15))
                    .foregroundColor(gradeForPost == "freshman" ? .black : .white)
                    .onTapGesture {
                        gradeForPost = "freshman"
                        withAnimation(.easeOut) { gradePickerOffset = 70 }
                        showGradeError = false
                    }
            }
        }
        .padding(.vertical, 6)
    }
}

extension AddShadeSheet {
    func uploadPost() {
                
        let db = Firestore.firestore()
        let colRef = db.collection("shade")
        colRef.addDocument(data: [
            "author" : nameText,
            "text" : shadeText,
            "timestamp" : Date.now,
            "votes" : 0,
            "grade" : gradeForPost
        ])
    }
    
    func confirmAdPopupEntryAnimation() {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 1.0)) { confirmAdPopupVerticalOffset = 0 }
    }
    
    func adPopupDismissAnimation() {
        withAnimation(.spring(response: 0.2, dampingFraction: 1.0, blendDuration: 1.0)) { confirmAdPopupVerticalOffset = 75 }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { withAnimation(.easeIn(duration: 0.3)) { confirmAdPopupVerticalOffset = -550 } }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { showConfirmAdPopup = false }
    }
}

struct AddShadeSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddShadeSheet(showPostPopup: .constant(true))
    }
}
