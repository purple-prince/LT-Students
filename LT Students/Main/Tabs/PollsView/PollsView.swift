//
//  PollsView.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 6/11/22.
//

//MARK: ONLY EVER HAVE 5 ACTIVE POLLS AT A TIME! APP WILL CRASH OTHERWISE


import SwiftUI
import Firebase

struct PollsView: View {
    
    init() {
        self.formatter.unitsStyle = .abbreviated
    }

    var formatter = RelativeDateTimeFormatter()
    //formatter.localizedString(for: timestamp.datevalue(), relativeTo: Date()
    
    
    @State var allPolls: [Poll] = [
    ]
    @State var contentHasLoaded: Bool = false
    
    @AppStorage("polls_voted_for") var polls_voted_for: [String] = []
    @AppStorage("options_voted_for") var options_voted_for: [String] = []
    var pollsAndOptionsVotedFor: [String : String] {
        Dictionary(uniqueKeysWithValues: zip(polls_voted_for, options_voted_for))
    }
}

extension PollsView {
    var body: some View {
        ZStack {
            Color.appGreen.ignoresSafeArea()
            
            VStack {
                title

                ScrollView {
                    if contentHasLoaded {
                        main()
                    } else {
                        skeletonView
                    }
                }

                Spacer()
            }
        }
        .onAppear {
            getInitialPolls()
        }
    }
}

extension PollsView {
    var title: some View {
        VStack(spacing: 8) {
            Text("Polls")
                .font(.largeTitle)
            
            Capsule()
                .frame(height: 2)
        }
        .padding()
        .foregroundColor(.white)
    }
    
    func pollTitle(poll: Poll) -> some View {
        return ZStack {
            HStack {

                if poll.isNew {
                    ZStack {
                        Capsule()
                            .foregroundColor(.appYellow)
                            .aspectRatio(2, contentMode: .fit)

                        Text("NEW")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.appGreen)
                    }
                    .padding(.leading, 8)
                    .frame(height: 23)
                }

                Text(poll.question.capitalized)
                    .foregroundColor(.black)
                    .font(.title2)
                

//                if poll.question.count > 20 {
//                    Text(poll.question.capitalized)
//                        .font(.caption)
//                        .multilineTextAlignment(.center)
//                } else if poll.question.count > 15 {
//                    Text(poll.question.capitalized)
//                        .multilineTextAlignment(.center)
//                        .font(.title3)
//                } else {
//                    Text(poll.question.capitalized)
//                        .font(.title)
//                }

                Spacer()
            }
        }
    }

    func main() -> some View {
        
        let lightColor = Color(red: 180/255, green: 180/255, blue: 180/255)
        let darkColor = Color(red: 35/255, green: 35/255, blue: 35/255)
        
        func voteButtonLabel(key: String) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .opacity(0.3)

                Text(key.capitalized)
            }
            .padding(8)
            .aspectRatio(3, contentMode: .fit)
            .frame(height: 75)
        }
        
        func hasNotVotedPoll(index: Int, key: String) -> some View {
            return HStack {
                HStack {
                    Spacer()
                    Text(key)
                }
                .foregroundColor(.black)
                .frame(width: 110)

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.appGreen, lineWidth: 2)
                        .frame(width: 32, height: 32)
                }
                .onTapGesture {
                    voteForPoll(index: index, key: key)
                    allPolls.removeAll()
                    getInitialPolls()
                }
                
                Spacer()
            }
        }
        
        func hasVotedPoll(index: Int, key: String) -> some View {
            
            let votedForThisPoll: Bool = options_voted_for[index] == key
                        
            return HStack {
                
                HStack {
                    Spacer()
                    Text(key)
                }
                .foregroundColor(.black)
                .frame(width: 110)

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(Color(red: 220/255, green: 220/255, blue: 220/255))
                        .frame(width: 200, height: 32)

                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor( votedForThisPoll ? Color.appGreen : lightColor)
                        .frame(width: allPolls[index].getPercentVotes(forKey: key) * 2, height: 32)

                    Text(String(format: "%.0f", allPolls[index].getPercentVotes(forKey: key)) + "%")
                        .foregroundColor(votedForThisPoll ? Color(red: 240/255, green: 240/255, blue: 240/255) : darkColor)
                        .padding(.leading)

                }
                
                Spacer()
            }
        }
        

        return VStack {

            //Button(action: {polls_voted_for.removeAll(); options_voted_for.removeAll()}, label: {Text("click me")})
            
            ForEach(0..<allPolls.count) { index in
                    VStack(alignment: .leading, spacing: 0) {
                        pollTitle(poll: allPolls[index])
                        
                        HStack(spacing: 4) {
                            
                            Text(formatter.localizedString(for: allPolls[index].timestamp.dateValue(), relativeTo: Date()))
                                .font(.callout)
                            
                            Text("•")
                                .font(.callout)
                            
                            Text(String(allPolls[index].totalVotes) + " votes")
                                .font(.callout)
                        }
                        .foregroundColor(.gray)
                        .padding(.top, 6)

                        

                        VStack {
                            ForEach(Array(allPolls[index].results.keys), id: \.self) { key in
                                
                                if polls_voted_for.contains(allPolls[index].docID) {
                                    hasVotedPoll(index: index, key: key)
                                } else {
                                    hasNotVotedPoll(index: index, key: key)
                                }
                            }
                        }
                        .padding(.top)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color(red: 240/255, green: 240/255, blue: 240/255))
                    )
                    .padding()
            }
        }
        .padding(.bottom)
        .onAppear { print(polls_voted_for.description); }
    }
    
    var skeletonView: some View {
        VStack {
            ForEach(0..<3) { index in
                    VStack(alignment: .leading, spacing: 0) {
                        ZStack {
                            HStack {
                                Text("This is a question")
                                    .foregroundColor(.black)
                                    .font(.title2)

                                Spacer()
                            }
                        }
                        
                        HStack(spacing: 4) {
                            
                            Text("timestamp")
                                .font(.callout)
                            
                            Text("•")
                                .font(.callout)
                            
                            Text("69 votes")
                                .font(.callout)
                        }
                        .foregroundColor(.gray)
                        .padding(.top, 6)

                        VStack {
                            ForEach(0..<3) { key in
                                HStack {
                                    
                                    Spacer()
                                    
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 4)
                                            .frame(width: 200, height: 32)
                                            .foregroundColor(Color(red: 220/255, green: 220/255, blue: 220/255))
                                        
                                        RoundedRectangle(cornerRadius: 4)
                                            .frame(width: CGFloat(Int.random(in: 50...200)), height: 32)
                                            .foregroundColor(Color(red: 180/255, green: 180/255, blue: 180/255))

                                    }

                                    Spacer()
                                }
                            }
                        }
                        .padding(.top)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color(red: 240/255, green: 240/255, blue: 240/255))
                    )
                    .padding()
            }
        }
        .padding(.bottom)
        .redacted(reason: .placeholder)
    }
}

extension PollsView {
    
    func voteForPoll(index: Int, key: String) {
        contentHasLoaded = false
        updatePollVotesInFirestore(key: key, poll: allPolls[index])
        allPolls[index].results[key]! += 1
        allPolls[index].hasVoted = true
        polls_voted_for.append(allPolls[index].docID)
        options_voted_for.append(key)
    }
    
    func updatePollVotesInFirestore(key: String, poll: Poll) {
        let db = Firestore.firestore()
        let docRef = db.collection("polls").document(poll.docID)
        let valueKey = "votes" + String(poll.optionLiteralsAndGenerics[key]!.last!)
        //TODO: optimize (db) below

        docRef.updateData([
            valueKey : FieldValue.increment(1.0),
            "tVotes" : FieldValue.increment(1.0),
            "isNew" : poll.timestamp.seconds + 172_800 > Timestamp(date: .now).seconds
        ])
    }
    
    func getInitialPolls() {
        let db = Firestore.firestore()
        let colRef = db.collection("polls")
        colRef.getDocuments { (snapshot, error) in
            if let error = error { print(error.localizedDescription); return }
            if let snapshot = snapshot {
                if !snapshot.isEmpty {
                    for doc in snapshot.documents {

                        let question = doc["question"] as? String ?? "error"
                        let totalVotes = doc["tVotes"] as? Int ?? -1
                        let isNew = doc["isNew"] as? Bool ?? false
                        let timestamp = doc["timestamp"] as? Timestamp ?? Timestamp(date: .now)
                        let docID = doc.documentID

                        let option1 = doc["option1"] as? String ?? "error"
                        let votes1 = doc["votes1"] as? Int ?? -1

                        var results: [String : Int] = [option1 : votes1]
                        var optionsResultsAndLiterals: [String : String] = [option1 : "option1"]

                        var option2 = ""
                        var votes2: Int

                        var option3 = ""
                        var votes3: Int

                        var option4 = ""
                        var votes4: Int

                        var option5 = ""
                        var votes5: Int

                        if let _ = doc.get("option2") {
                            option2 = doc["option2"] as? String ?? "error"
                            votes2 = doc["votes2"] as? Int ?? -1
                            results[option2] = votes2
                            optionsResultsAndLiterals[option2] = "option2"
                        }

                        if let _ = doc.get("option3") {
                            option3 = doc["option3"] as? String ?? "error"
                            votes3 = doc["votes3"] as? Int ?? -1
                            results[option3] = votes3
                            optionsResultsAndLiterals[option3] = "option3"
                        }

                        if let _ = doc.get("option4") {
                            option4 = doc["option4"] as? String ?? "error"
                            votes4 = doc["votes4"] as? Int ?? -1
                            results[option4] = votes4
                            optionsResultsAndLiterals[option4] = "option4"
                        }

                        if let _ = doc.get("option5") {
                            option5 = doc["option5"] as? String ?? "error"
                            votes5 = doc["votes5"] as? Int ?? -1
                            results[option5] = votes5
                            optionsResultsAndLiterals[option5] = "option5"
                        }

                        allPolls.append(Poll(
                            optionsVotedFor: $options_voted_for,
                            docID: docID,
                            question: question,
                            isNew: isNew,
                            totalVotes: totalVotes,
                            results: results,
                            optionLiteralsAndGenerics: optionsResultsAndLiterals,
                            timestamp: timestamp))

                    }
                }
            }

            contentHasLoaded = true
        }
    }
}

struct Poll: Identifiable {
    
    @Binding var optionsVotedFor: [String]
    let id: String = UUID().uuidString
    var docID: String
    var question: String
    var isNew: Bool
    var totalVotes: Int
    var results: [String : Int]
    var optionLiteralsAndGenerics: [String : String]
    var timestamp: Timestamp
    var hasVoted: Bool = false
 
    mutating func getPercentVotes(forKey key: String) -> Double {
        
        totalVotes += 1
        if optionsVotedFor.contains(key) {
            results[key]! += 1
        }
        
        let total = 100.0 / Double(totalVotes) * Double(results[key]!)
        return total
    }
}

struct PollsView_Previews: PreviewProvider {
    static var previews: some View {
        PollsView()
    }
}
