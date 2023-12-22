//
//  ReviewsSectionView.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 5/29/22.
//

import SwiftUI
import Firebase

struct ReviewsSectionView: View {
    
    @Binding var teacherSelected: String
    @Binding var reviewsHaveLoaded: Bool
    
    @State var reviews: [Review] = []
    @State var tempBool: Bool = false
    
    @State var lastDocument: DocumentSnapshot?
    @State var reviewUpvoteIndexesClicked: [Int] = []
    @State var numReviewsToShow: Int = 0
    
    let numReviews: Int
}

extension ReviewsSectionView {
    var body: some View {
        VStack {
            
            if numReviews <= 0 {
                Text("No reviews yet :(")
                    .foregroundColor(.white)
                    .font(.title2)
            } else {
                
                VStack {
                    Text("Lane's Thoughts")
                        .foregroundColor(.white)
                        .font(.title2)
                                
                    ScrollView {
                        ForEach(reviews) { review in
                            reviewSheet(review: review)
                        }
                        
                        if numReviews > 5 && numReviewsToShow < numReviews {
                            Button(action: {
                                getMoreReviews()
                            }, label: {
                                Text("View more")
                                    .foregroundColor(.white)
                                    .font(.title2)
                            })
                        }
                    }
                }
                .onAppear {
                    getInitialReviews()
                }
                .onDisappear {
                    reviews.removeAll()
                    lastDocument = nil

                    updateReviewVotes()
                }
            }
        }
    }
    
    
}

//FUNCS
extension ReviewsSectionView {
    
    func updateReviewVotes() {
        for i in reviewUpvoteIndexesClicked {
            let db = Firestore.firestore()
            let docRef = db.collection("teachers").document(teacherSelected).collection("reviews").document(String(i))
            
            docRef.updateData([
                "votes" : FieldValue.increment(1.0)
            ])
        }
    }
    
    func getInitialReviews() {
                
        let db = Firestore.firestore()
        let docRef = db.collection("teachers").document(teacherSelected).collection("reviews")
        
        docRef.order(by: "votes", descending: true).limit(to: 5).getDocuments { (snapshot, err) in
            
            if let error = err {
                print((err?.localizedDescription)!)
                return
            } else {
                for doc in snapshot!.documents{
                    
                    if doc.documentID != "-1" {
                        let review = Review(
                            docID: Int(doc.documentID) ?? -1,
                            text: doc["text"] as? String ?? "Couldn't load data",
                            votes: doc["votes"] as? Int ?? -1) //Int(doc["votes"] as? Int ?? "-1") ?? -1) // Revi(id: i.documentID, name: i.get("name") as! String, url: i.get("url") as! String, show: false)
                        
                        self.reviews.append(review)
                    }
                }
                
                self.lastDocument = snapshot!.documents.last
            }
        }
    }
    
    func getMoreReviews() {
        
        let db = Firestore.firestore()
        let docRef = db.collection("teachers").document(teacherSelected).collection("reviews")
        
        docRef.order(by: "votes", descending: true).start(afterDocument: lastDocument!).limit(to: 5).getDocuments { (snapshot, err) in
            if let error = err {
                print((err?.localizedDescription)!)
                return
            } else {
                if let snapshot = snapshot {
                    if snapshot.documents.isEmpty {
                        return
                    } else {
                        for doc in snapshot.documents {
                            
                            if doc.documentID != "-1" {
                                let review = Review(
                                    docID: Int(doc.documentID) ?? -1,
                                    text: doc["text"] as? String ?? "Couldn't load data",
                                    votes: doc["votes"] as? Int ?? -1)
                                    
                                reviews.append(review)
                                                            
                                lastDocument = snapshot.documents.last
                            }
                        }
                    }
                } else {
                    print("NO SNAPSHOT TO RETURN FILE:REVIEWSSECTIONVIEW :(")
                    return
                }
                
                //for i in reviews { print(String(i.docID))}
            }
        }
    }
        
}

struct ReviewsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewsSectionView(teacherSelected: .constant("Rachel Agosta"), reviewsHaveLoaded: .constant(false), numReviews: 1)
    }
}

struct Review: Identifiable {
    let id: UUID = UUID()
    let docID: Int
    let text: String
    let votes: Int
}
