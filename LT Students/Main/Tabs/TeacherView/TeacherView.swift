//
//  TeacherView.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 5/14/22.
//

//TODO: MAKE SURE U ENABLE ADMOB!!

import SwiftUI
import Firebase

struct TeacherView: View {
    @State var searchQuery: String = ""
    @State var showTeacherPopup: Bool = false
    @State var teacherSelected: String = ""
    @FocusState private var searchBarIsFocused: Bool
    @State var allTeachersAreLoading: Bool = false
    
    @State var allTeachers: [String] = []
    
    func getPossibleTeachers() -> [String] {
        var ls = allTeachers.filter { teacher in
            teacher.starts(with: searchQuery.lowercased())
        }
        
        if searchQuery == "" {
            var newLs = ls.sorted()
            newLs.insert("Type or scroll to search...", at: 0)
            return newLs
        }
        
        return ls.sorted()
    }
}

extension TeacherView {
    
    func getAllTeachers() {
        let db = Firestore.firestore()
        let colRef = db.collection("teachers")
        
        colRef.getDocuments { snapshot, error in
            if let error = error { print(error.localizedDescription); return }
            
            allTeachersAreLoading = true
            
            if let snapshot = snapshot {
                for doc in snapshot.documents {
                    allTeachers.append(doc.documentID.lowercased())
                }
            }
            
            allTeachersAreLoading = false
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.appGreen.ignoresSafeArea()
            
            if showTeacherPopup {
                TeacherPopup(teacherSelected: $teacherSelected, showTeacherPopup: $showTeacherPopup)
            } else {
                VStack(spacing: 8) {
                    
                    Text("Teachers")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    Capsule()
                        .frame(height: 2)
                        .foregroundColor(.white)
                    
                    Text("Rate teachers, get info, and see reviews of your teachers.")
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    searchBar
                    
                    Spacer()
                }
            }
        }.onAppear {
            getAllTeachers()
        }
    }
    
    var searchBar: some View {
        
        VStack {
            ZStack {
                
                Picker("", selection: $searchQuery) {
                    ForEach(getPossibleTeachers(), id: \.self) { teacher in
                        HStack(spacing: 0) {
                            Text(teacher.prefix(searchQuery.count))
                                .font(.title)
                                .foregroundColor(.clear)
                            
                            Text(teacher.suffix(from: teacher.index(teacher.startIndex, offsetBy: searchQuery.count)))
                                .font(.title)
                                .foregroundColor(.white)
                                .opacity(0.5)
                            
                            Spacer()
                        }
                        .tag(teacher)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 300)
                
                TextField("", text: $searchQuery)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal)
                    .offset(x: -4)
                    .submitLabel(.search)
                    .focused($searchBarIsFocused)
                    .onSubmit {
                        searchQuery = getPossibleTeachers().first ?? searchQuery
                        searchBarIsFocused = false
                    }
                    .onChange(of: searchQuery) { newValue in
                        if searchQuery == "Type or scroll to search..." { searchQuery = "" }
                        
                        searchQuery = searchQuery.lowercased()
                    }
            }
            .padding()
            
            if allTeachers.contains(searchQuery) {
                Button(action: {
                    showTeacherPopup = true
                    teacherSelected = searchQuery.capitalized
                }, label: {
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.appYellow)
                        
                        Text("Go")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                    }
                    .aspectRatio(3, contentMode: .fit)
                    .frame(height: 70)
                })
            }
            
        }
        .disabled(allTeachersAreLoading)
    }
}

struct TeacherView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherView()
    }
}

struct CloseButton: View {
    
    enum Sizes { case small, big }
    enum Modes { case back, close }
    
    let mode: Modes
    let size: Sizes
    let action: () -> ()
    
    var body: some View {
        VStack {
            HStack {
                
                if mode == .close {
                    Spacer()
                }
                
                Image(systemName: mode == .close ? "xmark" : "chevron.backward")
                    .foregroundColor(.appYellow)
                    .font(Font.system(size: size == .small ? 32 : 40))
                    .onTapGesture { action() }
                    .padding()
                
                if mode == .back {
                    Spacer()
                }
            }
            
            Spacer()
        }
    }
}
