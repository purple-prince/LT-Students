//
//  HomeView.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 5/14/22.
//

import SwiftUI
import Firebase

enum NewsFilter { case social, sports, announcements, all }

struct HomeView: View {
    
    init() {
        self.formatter.unitsStyle = .abbreviated
    }
    
    @State var newsFilterSelected: NewsFilter = .all
    @State var contentHasLoaded: Bool = false
    @State var topStory: Story = Story(title: "error", author: "error", text: "error", topic: .all, timestamp: Timestamp(date: .now), views: 0)
    @State var allStories: [Story] = []
    @State var storyToShow: Story = Story(title: "Final Lane Mascot Decision Reached", author: "Johnny Appleseed", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", topic: .all, timestamp: Timestamp(date: .now ), views: 0)//? =
    @State var showStory: Bool = false
    
    var formatter = RelativeDateTimeFormatter()
}

extension HomeView {
    var body: some View {
        ZStack {
            
            Color.appGreen.ignoresSafeArea()
            
            if !showStory {
                VStack {
                    topTabs

                    newsFilterMenu

                    ScrollView {
                        topArticle

                        mainArticles
                    }

                    Spacer()
                }
            } else {
                fullArticleView
            }
        }
    }
}

extension HomeView {
    var fullArticleView: some View {
        ZStack(alignment: .top) {
            CloseButton(mode: .back, size: .big, action: { showStory = false })
            
            VStack {
                Text(storyToShow.title)
                    .font(storyToShow.title.count > 32 ? .title : .largeTitle)
                
                if storyToShow.text == topStory.text {
                    //"https://upload.wikimedia.org/wikipedia/commons/9/96/Lane_Tech_High_School_clock_tower.jpg"
                    
                    AsyncImage(
                        url: URL(string: topStory.imageURL!)) { image in
                            image
                                .resizable()
                            
                        } placeholder: {
                            Rectangle()
                                .opacity(0.25)
                                .brightness(0.7)
                                .foregroundColor(.white)
                                
                        }
                        .cornerRadius(12)
                        .aspectRatio(2/1, contentMode: .fit)
                    
                }
                
                HStack {
                    Text(
                        formatter.localizedString(for: storyToShow.timestamp.dateValue(), relativeTo: Date()) +
                        " by " +
                        storyToShow.author
                    )
                        .fontWeight(.light)
                        .font(.callout)
                        .italic()
                    
                    Spacer()
                        
                }
                .padding(.vertical)
                
                ScrollView {
                    Text("            " + storyToShow.text)
                        .font(Font.system(size: 18))
                        .lineSpacing(8)
                }
            }
            .padding()
            .padding(.top, 48)
            .foregroundColor(.white)
        }
    }

    var mainArticles: some View {
        VStack {
            
            if contentHasLoaded {
                ForEach(allStories) { story in
                    articleView(story: story)
                }
                .onAppear { updateArticleViews() }
            } else {
                Text("Loading...")
            }
        }
        .padding(.horizontal)
    }
    
    var topTabs: some View {
        ZStack {
            Text("Lane Tech Community")
                .font(.title)
                .foregroundColor(.white)
                .offset(x: -5)

            Capsule()
                .foregroundColor(.appYellow)
                .frame(height: 2)
                .offset(y: 24)
        }
        .padding()
    }

    var newsFilterMenu: some View {
        
        ZStack {
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack {
                    Text("All")
                        .font(Font.system(size: 20))
                        .fontWeight(newsFilterSelected == .all ? .semibold : .regular)
                        .padding(.horizontal, newsFilterSelected == .all ? 20 : 0)
                        .scaleEffect(getNewsFilterMenuScale(mode: .all))
                        .onTapGesture { contentHasLoaded = false; withAnimation(.spring()) { newsFilterSelected = .all } }
                    Text("Social")
                        .font(Font.system(size: 20))
                        .fontWeight(newsFilterSelected == .social ? .semibold : .regular)
                        .padding(.horizontal, newsFilterSelected == .social ? 20 : 0)
                        .scaleEffect(getNewsFilterMenuScale(mode: .social))
                        .onTapGesture { contentHasLoaded = false; withAnimation(.spring()) { newsFilterSelected = .social } }
                    Text("Sports")
                        .font(Font.system(size: 20))
                        .fontWeight(newsFilterSelected == .sports ? .semibold : .regular)
                        .padding(.horizontal, newsFilterSelected == .sports ? 20 : 0)
                        .scaleEffect(getNewsFilterMenuScale(mode: .sports))
                        .onTapGesture { contentHasLoaded = false; withAnimation(.spring()) { newsFilterSelected = .sports } }
                    Text("Announcements")
                        .font(Font.system(size: 20))
                        .fontWeight(newsFilterSelected == .announcements ? .semibold : .regular)
                        .padding(.horizontal, newsFilterSelected == .announcements ? 20 : 0)
                        .scaleEffect(getNewsFilterMenuScale(mode: .announcements))
                        .onTapGesture { contentHasLoaded = false; withAnimation(.spring()) { newsFilterSelected = .announcements } }
                }
                .foregroundColor(.appYellow)
                .padding(.leading)
            }
        }
    }
    
    var topArticle: some View {
        VStack(alignment: .leading) {
            if contentHasLoaded && topStory.title != "error" {
                AsyncImage(
                    url: URL(string: topStory.imageURL!)) { image in
                        image
                            .resizable()
                        
                    } placeholder: {
                        Rectangle()
                            .opacity(0.25)
                            .brightness(0.7)
                            .foregroundColor(.gray)
                            
                    }
                    .cornerRadius(12)
                    .aspectRatio(2/1, contentMode: .fit)

                

                Text(topStory.title)
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.bottom, 1)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text("      " + topStory.text)
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                    .lineLimit(3)
                    .truncationMode(.tail)
                
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .opacity(0.25)
                    .brightness(0.7)
                    .aspectRatio(2/1, contentMode: .fit)

                Text("This is a title...")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.bottom, 8)

                Text("\tLorem ipsum dolor sit amet, consectetur adipiscing elit. Integer eget justo eget est elementum egestas. ")
                    .foregroundColor(.white)
                    .lineLimit(3)
                
                Capsule()
                    .frame(height: 1)
                    .opacity(0.1)
            }
        }
        .redacted(reason: contentHasLoaded ? [] : .placeholder)
        .padding(.top)
        .padding(.horizontal)
        .onAppear {
            loadAllInitialData()
        }
        .onTapGesture {
            if contentHasLoaded {
                storyToShow = topStory
                showStory = true
            }
        }
    }
    
    func articleView(story: Story) -> some View {
        
        return VStack {
            
            Capsule()
                .frame(height: 1)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(story.title)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .font(.title2)
                    .padding(.vertical, 12)
                    .foregroundColor(.white)
                
                Text("      " + story.text)
                    .fontWeight(.thin)
                    .lineLimit(2)
                
                HStack {
                                        
                    Text(formatter.localizedString(for: story.timestamp.dateValue(), relativeTo: Date()))
                    
                    Spacer()
                    
                    Text(String(story.views) + " views")
                    
                }
                .foregroundColor(.appYellow)
                .padding(.top)
                    
            }
        }
        .onTapGesture {
            storyToShow = story
            showStory = true
        }
        .foregroundColor(.white)
    }
}

extension HomeView {
    
    func updateArticleViews() {
        let db = Firestore.firestore()
        let docRef = db.collection("productionStories")
        var docIds: [String] = []
        
        docRef.getDocuments { (snapshot, error) in
            if let error = error { print(error.localizedDescription); return }
            if let snapshot = snapshot {
                for doc in snapshot.documents { docIds.append(doc.documentID) }
                
                for doc in docIds {
                    let docReference = docRef.document(doc)
                    docReference.updateData([
                        "views" : FieldValue.increment(1.0)
                    ])
                }
            }
        }
    }
    
    func loadInitialTopStory() {
        let db = Firestore.firestore()
        let docRef = db.collection("productionStories").whereField("topic", isEqualTo: "top").whereField("isActive", isEqualTo: true).limit(to: 1)
        docRef.getDocuments { (snapshot, error) in
            if let error = error { print(error.localizedDescription); return }
            if let snapshot = snapshot {
                if let doc = snapshot.documents.first {
                    
                    let author = doc["author"] as? String ?? "error"
                    let text = (doc["text"] as? String ?? "error").replacingOccurrences(of: "\\n", with: "\n\n")
                    let topic: NewsFilter
                    let time = doc["timestamp"] as? Timestamp ?? Timestamp(seconds: 99, nanoseconds: 0)
                    let title = doc["title"] as? String ?? "error"
                    let views = doc["views"] as? Int ?? -1
                    let imageUrl = doc["imageUrl"] as? String ?? "https://upload.wikimedia.org/wikipedia/commons/9/96/Lane_Tech_High_School_clock_tower.jpg"
                    
                    
                    switch doc["topic"] as? String ?? "error" {
                        case "top": topic = .all
                        case "social": topic = .social
                        case "sports": topic = .sports
                        case "announcements": topic = .announcements
                        default: topic = .all
                    }
                    
                    topStory = Story(title: title, author: author, text: text, topic: topic, timestamp: time, views: views, imageURL: imageUrl)
                }
            }
        }
    }
    
    func loadAllInitialData() {
        loadInitialTopStory()
        
        let db = Firestore.firestore()
        let docRef = db.collection("productionStories")
            .whereField("isActive", isEqualTo: true)
            .whereField("topic", isEqualTo: "all")
//            //.whereField("timestamp", isNotEqualTo: false)
//            //.order(by: "timestamp", descending: true)
//
        docRef.getDocuments { (snapshot, error) in
            if let error = error { print(error.localizedDescription); return }
            if let snapshot = snapshot {
                for doc in snapshot.documents {


                    allStories.append(Story(
                        title: (doc["title"] as? String ?? "error").replacingOccurrences(of: "\\n", with: "\n\n"),
                        author: doc["author"] as? String ?? "error",
                        text: (doc["text"] as? String ?? "error").replacingOccurrences(of: "\\n", with: "\n\n"),
                        topic: .all,
                        timestamp: doc["timestamp"] as? Timestamp ?? Timestamp(seconds: 99, nanoseconds: 0),//Timestamp(date: .now),
                        views: doc["views"] as? Int ?? -1
                    ))
                }

                contentHasLoaded = true
            }
        }
    }
    
    func getNewsFilterMenuOffset() -> Int {
        switch newsFilterSelected {
            case .all: return 120
            case .social: return 80
            case .sports: return 25
            case .announcements: return -70
        }
    }
    
    func getNewsFilterMenuScale(mode: NewsFilter) -> CGFloat {
        switch mode {
            case .all:
                switch newsFilterSelected {
                    case .all: return 1.0
                    case .social: return 0.95
                    case .sports: return 0.9
                    case .announcements: return 0.85
                }
            case .social:
                switch newsFilterSelected {
                    case .all: return 0.95
                    case .social: return 1.0
                    case .sports: return 0.95
                    case .announcements: return 0.9
                }
            case .sports:
                switch newsFilterSelected {
                    case .all: return 0.9
                    case .social: return 0.95
                    case .sports: return 1.0
                    case .announcements: return 0.95
                }
            case .announcements:
                switch newsFilterSelected {
                    case .all: return 0.85
                    case .social: return 0.9
                    case .sports: return 0.95
                    case .announcements: return 1.0
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
