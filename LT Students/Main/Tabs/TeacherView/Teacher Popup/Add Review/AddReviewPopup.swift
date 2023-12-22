//
//  AddReviewPopup.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 5/29/22.
//

import SwiftUI
import Firebase

struct AddReviewPopup: View {
    
    @Binding var numReviews: Int
    @Binding var showAddReviewPopup: Bool
    let teacherSelected: String
    
    @State var reviewText: String = ""
    var reviewTextLength: Int { return reviewText.count }
    
    @State var niceStars: Double = 0
    @State var critStars: Double = 0
    @State var teachStars: Double = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .foregroundColor(.appGreen)
            
            VStack(spacing: 8) {
                Text(teacherSelected)
                    .font(.title)
                Capsule().frame(height: 2).padding(.horizontal)
                    .padding(.bottom)
                
                VStack(spacing: 16) {
                    StarRaterView(title: "Nice & Fun", mode: .nice, niceStars: $niceStars, critStars: $critStars, teachStars: $teachStars)
                    StarRaterView(title: "Criticality", mode: .crit, niceStars: $niceStars, critStars: $critStars, teachStars: $teachStars)
                    StarRaterView(title: "Teaching", mode: .teach, niceStars: $niceStars, critStars: $critStars, teachStars: $teachStars)
                }
                
                Text("Review: ")
                    .font(.title)
                    .padding()
                
                TextEditor(text: $reviewText)
                    .aspectRatio(3, contentMode: .fit)
                    .onChange(of: reviewText) { newValue in
                        if reviewText.count > 150 {
                            reviewText.removeLast(reviewText.count - 150)
                        }
                    }
                
                HStack {
                    Spacer()
                    
                    Text(String(reviewTextLength) + " / 150")
                }
                
                Spacer()
                    
                Button(action: { submitReview() }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .aspectRatio(5, contentMode: .fit)
                            .foregroundColor(.appGreen)
                        
                        Text("Submit")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                })
                
            }.padding()
            
            CloseButton(mode: .close, size: .big) {
                showAddReviewPopup = false
            }
        }
        .padding()
        .aspectRatio(3/5, contentMode: .fit)
    }
}

extension AddReviewPopup {
    func submitReview() {
        let db = Firestore.firestore()
        
        db.collection("teachers").document(teacherSelected).updateData([
            "tReviews" : FieldValue.increment(1.0),
            "tNiceStars" : FieldValue.increment(niceStars),
            "tCritStars" : FieldValue.increment(critStars),
            "tTeachStars" : FieldValue.increment(teachStars)
        ])
                            
        db.collection("teachers").document(teacherSelected).collection("reviews").document(String(numReviews + 1)).setData([
            "text" : reviewText,
            "votes" : 0
        ])
        
        showAddReviewPopup = false
    }
}

struct AddReviewPopup_Previews: PreviewProvider {
    static var previews: some View {
        AddReviewPopup(numReviews: .constant(3), showAddReviewPopup: .constant(true), teacherSelected: "rachel agosta")
    }
}
