//
//  HomeModel.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 7/9/22.
//

import Foundation
import SwiftUI
import Firebase

struct Story: Identifiable {
    
    init(title: String, author: String, text: String, topic: NewsFilter, timestamp: Timestamp, views: Int, imageURL: String? = nil) {
        self.title = title
        self.author = author
        self.text = text
        self.topic = topic
        self.timestamp = timestamp
        self.views = views
        self.imageURL = imageURL
        
    }
    
    let id: UUID = UUID()
    let title: String
    let author: String
    let text: String
    let topic: NewsFilter
    let timestamp: Timestamp
    let views: Int
    let imageURL: String?
}
