//
//  TeacherPopup.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 5/29/22.
//

import SwiftUI
import Firebase

struct TeacherPopup: View {
    
    @Binding var teacherSelected: String
    @Binding var showTeacherPopup: Bool
    @State var showAddReviewScreen: Bool = false

    @State var numReviews: Int = 0
    
    //nice, crit, teach
    @State var averageRatings: [Double] = []
    @State var ratingsHaveLoaded: Bool = false
    @State var reviewsHaveLoaded: Bool = false
    
    @State var profilePicUrl: URL? = nil
    
    //let naughtyWords: [String] = ["cunt", "idiot", "cock", "penis", "pussy", "fuck", "shit", "vagina", "dick", "asshole", "wanker", "motherfuckcer", "bastard", "tit" "tits", "boobs", "sex", "NWORDNWORDNWORDNWORDNWORD"] hh hgg 5 gg65 t gg55 t67 tg7t t
}

//BODY
extension TeacherPopup {
    var body: some View {
        ZStack {
            
            Color.appGreen.ignoresSafeArea()
                .brightness(showAddReviewScreen ? -0.1 : 0)
                     
            main
                .disabled(showAddReviewScreen)
                .brightness(showAddReviewScreen ? -0.1 : 0)
            
            CloseButton(mode: .back, size: .small) { showTeacherPopup = false }
                .disabled(showAddReviewScreen)
                .blur(radius: showAddReviewScreen ? 5 : 0)

            if showAddReviewScreen {
                AddReviewPopup(numReviews: $numReviews, showAddReviewPopup: $showAddReviewScreen, teacherSelected: teacherSelected)
                    .onDisappear{ getRatings() }
            }
        }
    }
}

extension ReviewsSectionView {
    func reviewSheet(review: Review) -> some View {
        ZStack {
            
            ZStack {
//
//                RoundedRectangle(cornerRadius: 12)
//                    .foregroundColor(.black)
//                    .blur(radius: 8)
                
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.white)
                    .brightness(-0.15)
                    .shadow(color: .black, radius: 5, x: 0, y: 7)
                    
                    
                
                VStack {
                    Text(review.text)
                        .foregroundColor(.black)
                        .font(.subheadline)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    HStack {
                        
                        Spacer()
                        
                        HStack(alignment: .top, spacing: 4) {
                            Text(String(review.votes))
                                .foregroundColor(.appGreen)
                            
                                ZStack {
                                    if reviewUpvoteIndexesClicked.contains(review.docID) {
                                        Arrow(widthMultiplier: 1.5, heightMultiplier: 1.1)
                                            .offset(y: 1)
                                            .foregroundColor(.appGreen)
                                            .aspectRatio(1, contentMode: .fit)
                                            .frame(height: 16)
                                    } else {
                                        Arrow(widthMultiplier: 1.5, heightMultiplier: 1.1)
                                            .offset(y: 1)
                                            .stroke(Color.appGreen, lineWidth: 1)
                                            .aspectRatio(1, contentMode: .fit)
                                            .frame(height: 16)
                                    }
                                }
                        }
                        .onTapGesture {
                            if reviewUpvoteIndexesClicked.contains(review.docID) {
                                reviewUpvoteIndexesClicked = reviewUpvoteIndexesClicked.filter({$0 != review.docID})
                            } else {
                                reviewUpvoteIndexesClicked.append(review.docID)
                            }
                        }
                        
                    }
                    .padding(.horizontal)
                    
                }
                .padding()
                .foregroundColor(.white)
            }
            .aspectRatio(25/10, contentMode: .fit)
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }
}

//VIEW
extension TeacherPopup {
    var main: some View {
        ZStack {
            VStack {
                
                VStack {

                    
                    if profilePicUrl != nil {
                        
                        AsyncImage(url: profilePicUrl) { image in
                            image
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .clipShape(Circle())
                                .clipped()
                        } placeholder: {
                            Circle()
                                .foregroundColor(.gray)
                        }
                        .frame(width: 100, height: 100)
                        
                    } else {
                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 110, height: 110)
                    }
                    
                    



                    Text("\(teacherSelected) • \(numReviews)")
                        .font(.title)
                        .foregroundColor(.white)

                    ratingLabel

                    Capsule()
                        .frame(height: 4)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
                .padding()
                
                
                if ratingsHaveLoaded {
                    ReviewsSectionView(teacherSelected: $teacherSelected, reviewsHaveLoaded: $reviewsHaveLoaded, numReviews: numReviews)
                }
                
                Spacer()
            }
            
            addReviewButton
                .blur(radius: showAddReviewScreen ? 5 : 0)
            
        }
        .blur(radius: showAddReviewScreen ? 5 : 0)
    }
    
    var addReviewButton: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "plus")
                Text("Add Review")
            }
            .onTapGesture { withAnimation(.easeInOut) { showAddReviewScreen = true } }
            .foregroundColor(.white)
            
            Spacer()
        }
        .padding()
    }
    
    var ratingLabel: some View {
        
        VStack {
            HStack {
                if ratingsHaveLoaded {
                    
                    Spacer()
                    
                    Text("Nice & Fun")
                        .font(.title3)
                        .foregroundColor(.white)
                    
                    Spacer()
                        .frame(width: 20)
                    
                    starRatingView(rating: averageRatings[0])
                }
            }
            HStack {
                if ratingsHaveLoaded {
                    
                    Spacer()
                    
                    Text("Criticality")
                        .font(.title3)
                        .foregroundColor(.white)
                    
                    Spacer()
                        .frame(width: 20)
                    
                    starRatingView(rating: averageRatings[1])
                }
            }
            HStack {
                if ratingsHaveLoaded {
                    
                    Spacer()
                    
                    Text("Teachng")
                        .font(.title3)
                        .foregroundColor(.white)
                    
                    Spacer()
                        .frame(width: 20)
                    
                    starRatingView(rating: averageRatings[2])
                }
            }
        }
        .onAppear {getRatings()}
        .onDisappear { ratingsHaveLoaded = false }
    }
    
    func starRatingView(rating: Double) -> some View {
                        
        return HStack {
            
            Capsule()
                .foregroundColor(.appYellow)
                .frame(width: rating * 25, height: 16)
            
            Text(String(rating))
                .foregroundColor(.white)
                .padding(.trailing, 125 - (rating * 25))
        }
    }
}

//FUNC
extension TeacherPopup {
    
    func getRatings() {
        
        ratingsHaveLoaded = false
        var ls: [Double] = []
        var numReviews: Double = 0.0
        
        let db = Firestore.firestore()
        
        db.collection("teachers").document(teacherSelected).getDocument { (doc, error) in
            if let error = error {
                print("ERROR! ERROR!")
                
            }
            if let doc = doc {
                
                if let pic = doc["imageUrl"] {
                    let url = pic as? String ?? ""
                    
                    if !url.isEmpty {
                        profilePicUrl = URL(string: url)
                    }
                }
                
                numReviews = doc["tReviews"] as? Double ?? 0.0
                self.numReviews = doc["tReviews"] as? Int ?? 0//Int(numReviews)
                
                ls.append(doc["tNiceStars"] as? Double ?? 6.9)
                ls.append(doc["tCritStars"] as? Double ?? 6.9)
                ls.append(doc["tTeachStars"] as? Double ?? 6.9)
                
                averageRatings = ls
                averageRatings = numReviews <= 0 ? [0, 0, 0] : averageRatings.map { $0 / numReviews }
                averageRatings = averageRatings.map { Double(Int($0 * 10)) / 10.0 }
            } else {
                print("NODOC :( NODOC :( NODOC :(")
            }
            
            ratingsHaveLoaded = true
        }
    }
}

struct TeacherPopup_Previews: PreviewProvider {
    static var previews: some View {
        TeacherPopup(teacherSelected: .constant("Rachel Agosta"), showTeacherPopup: .constant(true))
    }
}
