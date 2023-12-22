//
//  ShadeView.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 6/18/22.
//

import SwiftUI
import GoogleMobileAds
import Firebase

//VARS
struct ShadeView: View {
    
    enum Grade { case senior, junior, sophmore, freshman }
    enum VoteCases { case non, up, down }
    
    @State var showRules: Bool = false
    @State var gradeSelected: Grade = .senior
    @State var postUploading = true
    @State var showPostPopup: Bool = false
    @State var sortPostsByRecent: Bool = true
    @State var sortPostsDescending: Bool = true
    @State var lastPost: DocumentSnapshot? = nil
    @State var allPosts: [ShadePost] = []
    @State var postsLoaded: Bool = false
    @State var noShade: Bool = false

    @AppStorage("posts_voted_for") var posts_voted_for: [String] = []
    @AppStorage("posts_voted_up") var posts_voted_up: [Bool] = []

    @State var newVoteData: [String : Bool] = [:]
    @State var votesToUpdate: [String : Bool] = [:]
    
    @State var h = ["", "", ""]
    
    @State var cp: String = ""
}

//BODY
extension ShadeView {
    
    
    var body: some View {
        ZStack {
            
            ZStack {
                Color.appGreen.ignoresSafeArea()
                    .brightness(showRules ? -0.1 : 0)
                
                VStack {
                    title
                    
                    menu
                    
                    main
                    
                    Spacer()
                }
                .brightness(showRules ? -0.1 : 0)
                .blur(radius: showRules ? 8 : 0)
                .disabled(showRules)
                
                addPostButton
                    .brightness(showRules ? -0.1 : 0)
                    .blur(radius: showRules ? 16 : 0)
                    .disabled(showRules)
                    .sheet(isPresented: $showPostPopup) { AddShadeSheet(showPostPopup: $showPostPopup) }
            }
            
            if showRules { rulesView } //TODO: ADD TRANSITION OR ANIMATION OR SUM

        }
        .onAppear {
            loadPosts()
        }
        .onDisappear {
            updatePostVotesInFirestore()
        }
    }
}

extension ShadeView {
    
    func postView(post: ShadePost) -> some View {
        
        var votes: Int {
            
            if post.originalVoteState == post.voteState {
                return post.votes
            } else {
                switch post.originalVoteState {
                    case .up:
                        if post.voteState == .down {
                            return post.votes - 2
                        } else {
                            return post.votes - 1
                        }
                    case .down:
                        if post.voteState == .up {
                            return post.votes + 2
                        } else {
                            return post.votes + 1
                        }
                    case .non:
                        if post.voteState == .down {
                            return post.votes - 1
                        } else {
                            return post.votes + 1
                        }
                }
            }
        }
        
        return ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.white)
                .brightness(-0.2)
                .shadow(color: .black, radius: 5, x: 0, y: 5)
            
            HStack {
                
                Text("\(post.text)  **- \(post.author)**")
                    .multilineTextAlignment(.leading)
                    .onTapGesture {
                        posts_voted_up.removeAll()
                        posts_voted_for.removeAll()
                    }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Image(systemName: "chevron.up")
                        .font(post.voteState == .up ? Font.title3.bold() : .title3)
                        .foregroundColor(post.voteState == .up ? .green : .gray)
                    
                    .onTapGesture {
                        if posts_voted_for.contains(post.id) {
                            if posts_voted_up[posts_voted_for.firstIndex(of: post.id)!] {
                                posts_voted_up.remove(at: posts_voted_for.firstIndex(of: post.id)!)
                                posts_voted_for.remove(at: posts_voted_for.firstIndex(of: post.id)!)
                                allPosts[allPosts.firstIndex { p in p.id == post.id }!].voteState = .non
                            } else {
                                allPosts[allPosts.firstIndex { p in p.id == post.id }!].voteState = .up
                                posts_voted_up[posts_voted_for.firstIndex(of: post.id)!] = true
                            }
                        } else {
                            posts_voted_for.append(post.id)
                            posts_voted_up.append(true)
                            allPosts[allPosts.firstIndex { p in p.id == post.id }!].voteState = .up
                        }
                    }
                    
                    Text(String(votes))
                        .font(.title3)
                    
                    
                    Image(systemName: "chevron.down")
                        .font(post.voteState == .down ? Font.title3.bold() : .title3)
                        .foregroundColor(post.voteState == .down ? .red : .gray)
                        //.font(votedForPost && !(posts_voted_up[index!]) ? Font.title3.bold() : .title3)
                        //.foregroundColor(votedForPost && !(posts_voted_up[index!]) ? .red : .gray)
                    .onTapGesture {
                        
                        if posts_voted_for.contains(post.id) {
                            if !posts_voted_up[posts_voted_for.firstIndex(of: post.id)!] {
                                posts_voted_up.remove(at: posts_voted_for.firstIndex(of: post.id)!)
                                posts_voted_for.remove(at: posts_voted_for.firstIndex(of: post.id)!)
                                allPosts[allPosts.firstIndex { p in p.id == post.id }!].voteState = .non
                            } else {
                                allPosts[allPosts.firstIndex { p in p.id == post.id }!].voteState = .down
                                posts_voted_up[posts_voted_for.firstIndex(of: post.id)!] = false
                            }
                        } else {
                            posts_voted_for.append(post.id)
                            posts_voted_up.append(false)
                            allPosts[allPosts.firstIndex { p in p.id == post.id }!].voteState = .down
                        }
                    }
                }
            }
            .foregroundColor(.black)
            .padding(4)
            .padding(.horizontal, 8)
        }
        .aspectRatio(7/2, contentMode: .fit)
        .padding(.horizontal)
    }
    
    func updatePostVotes(post: ShadePost, votedUp: Bool) {
        let db = Firestore.firestore()
        let colRef = db.collection("shade")
        
        colRef.document(post.id).updateData([
            "votes" : FieldValue.increment(votedUp ? 1.0 : -1.0)
        ])
    }
    
    var main: some View {
        VStack {
            if postsLoaded {
                
                if allPosts.isEmpty {
                    Spacer()
                    Text("No Posts :(")
                        .font(.title)
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        ForEach(allPosts) { post in
                            postView(post: post)
                                .padding(.top)
                        }
                    }
                }
            } else {
                Text("Loading...")
                    .foregroundColor(.white)
                    .font(.title)
            }
        }
    }
    
    var addPostButton: some View {
        VStack {
            
            Spacer()
            
            Button(action: {
                showPostPopup = true
            }, label: {
                
                ZStack(alignment: .bottom) {
                    Circle()
                        .frame(width: 50)
                        .foregroundColor(.appGreen)
                    
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.appYellow)
                        .font(Font.system(size: 60))
                }
            })
            .frame(height: 60)
        }
    }
    
    var menu: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text("Senior")
                    .fontWeight(gradeSelected == .senior ? .medium : .regular)
                    .onTapGesture {
                        withAnimation(.spring()) { gradeSelected = .senior }
                        loadPosts()
                    }
                Spacer()
                Text("Junior")
                    .fontWeight(gradeSelected == .junior ? .medium : .regular)
                    .onTapGesture {
                        withAnimation(.spring()) { gradeSelected = .junior }
                        loadPosts()
                    }
                Spacer()
                Text("Sophmore")
                    .fontWeight(gradeSelected == .sophmore ? .medium : .regular)
                    .onTapGesture {
                        withAnimation(.spring()) { gradeSelected = .sophmore }
                        loadPosts()
                    }
                Spacer()
                Text("Freshman")
                    .fontWeight(gradeSelected == .freshman ? .medium : .regular)
                    .onTapGesture {
                        withAnimation(.spring()) { gradeSelected = .freshman }
                        loadPosts()
                    }
                Spacer()
            }
            
            Capsule()
                .frame(width: 70, height: 2)
                .offset(x: gradeSelected == .senior ? -142 : gradeSelected == .junior ? -65 : gradeSelected == .sophmore ? 25 : 130)
        }
        .foregroundColor(.appYellow)
    }
    
    var rulesView: some View {
        ZStack {
            VStack {
                Text("Rules")
                    .font(.largeTitle)
                    .underline()
                
                Spacer()
                
                Text("")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading) {
                    Text("- Don't post rude, threatening, or hateful things about someone else.\n")
                    Text("- Don't post content you wouldn't want posted about you.\n")
                    Text("- If you post harmful content, your device may be banned from the app without warning.\n")
                    
                    Spacer()
                    
                    Text("If you see a post you don't like, feel free to flag it. It'll be removed right away, but may be reposted if we review it and deem it OK. For more information, see our Terms of Service in the \"About\" section.")
                        .font(.footnote)
                }
                
                Spacer()
                Spacer()
            }
            .foregroundColor(.white)
            .padding()
            
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .font(Font.system(size: 40))
                        .foregroundColor(.appYellow)
                        .onTapGesture { showRules = false }
                        .padding()
                }
                Spacer()
            }
        }
        .frame(height: 550)
        .background(
            ZStack {
                
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appYellow, lineWidth: 4)
                
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.appGreen)
            }
        )
        .padding()
    }
    
    var title: some View {
        VStack {
            Text("Shade Room")
                .font(.largeTitle)
            
            HStack(spacing: 0) {
                Text("First time? Read the")
                
                Text(" rules.")
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .underline()
                    .brightness(0.2)
                    .onTapGesture { showRules = true }
                
                Spacer()

            }
            .padding()
        }
        .foregroundColor(.white)
    }
}

//FUNCS
extension ShadeView {
    
    //doc["timestamp"] as? Timestamp ?? Timestamp(seconds: 99, nanoseconds: 0)
    
    func appendPost(doc: QueryDocumentSnapshot) {
        let text      = doc["text"] as? String ?? "error"
        let votes     = doc["votes"] as? Int ?? -1
        let author    = doc["author"] as? String ?? "error"
        let timestamp = doc["timestamp"] as? Timestamp ?? Timestamp(seconds: 99, nanoseconds: 0)
        let grade     = doc["grade"] as? String ?? "senior"
        var voteState: VoteCases {
            if posts_voted_for.contains(doc.documentID) {
                if posts_voted_up[posts_voted_for.firstIndex(of: doc.documentID)!] { return .up }
                else { return .down }
            } else { return .non }
        }
        
        let post = ShadePost(
            id: doc.documentID,
            text: text,
            votes: votes,
            author: author,
            timestamp: timestamp.dateValue(),
            grade: grade,
            voteState: voteState,
            originalVoteState: voteState
        )
        
        allPosts.append(post)
    }
    
    func loadPosts() {
        
        postsLoaded = false
        allPosts.removeAll()
        
        let db = Firestore.firestore()
        let colRef = db.collection("shade")
        var docRef: Query? = nil
        var grade: String {
            switch gradeSelected {
                case .senior: return "senior"
                case .junior: return "junior"
                case .sophmore: return "sophmore"
                case .freshman: return "freshman"
            }
        }
        
        if let lastPost = lastPost {
            docRef = colRef
                .whereField("grade", isEqualTo: grade)
                .order(by: sortPostsByRecent ? "timestamp" : "votes", descending: sortPostsDescending)
                .start(afterDocument: lastPost)
                .limit(to: 5)
        } else {
            docRef = colRef
                .whereField("grade", isEqualTo: grade)
                .order(by: sortPostsByRecent ? "timestamp" : "votes", descending: sortPostsDescending)
                .limit(to: 5)
        }
        

        docRef!.getDocuments(completion: { (snapshot, error) in
            if let error = error { print("ERROR! ERROR! ERROR!" + error.localizedDescription); return }
            if let snapshot = snapshot {
                                
                for doc in snapshot.documents { appendPost(doc: doc) }
                
                if !snapshot.isEmpty {
                    lastPost = snapshot.documents.last!
                }
            }
            
            postsLoaded = true
        })
        
    }
    
    func updatePostVotesInFirestore() {
        let db = Firestore.firestore()
        let colRef = db.collection("shade")
        for post in allPosts {
            if post.originalVoteState != post.voteState {
                var incrementAmt: Double {
                    switch post.originalVoteState {
                        case .down:
                            if post.voteState == .up { return 2.0 } else { return 1.0 }
                        case .up:
                            if post.voteState == .down { return -2.0 } else { return -1.0 }
                        case .non:
                            if post.voteState == .up { return 1.0 } else { return -1.0 }
                    }
                }
                
                colRef.document(post.id).updateData([
                    "votes" : FieldValue.increment(incrementAmt)
                ])
            }
        }
    }
}

struct ShadePost: Identifiable {
    let id: String
    let text: String
    var votes: Int
    let author: String
    let timestamp: Date
    let grade: String
    var voteState: ShadeView.VoteCases
    let originalVoteState: ShadeView.VoteCases
}

struct ShadeView_Previews: PreviewProvider {
    static var previews: some View {
        ShadeView()
    }
}
