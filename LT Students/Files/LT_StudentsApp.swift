//
//  LT_ReviewsApp.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 5/14/22.
//

import SwiftUI
import Firebase
import AppTrackingTransparency
import GoogleMobileAds

@main
struct LT_ReviewsApp: App {
    
    init() {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            //Main()
            //TeacherView()
            //FeedbackView(showMenuView: .constant(false), showFeedbackView: .constant(true))
            MenuView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
//                    ATTrackingManager.requestTrackingAuthorization { status in
//                        switch status {
//                            case .authorized:
//                                ContentView.canShowPersonalizedAds = true
//                                print("w")
//                            case .denied:
//                                ContentView.canShowPersonalizedAds = false
//                            case .notDetermined:
//                                ContentView.canShowPersonalizedAds = false
//                            case .restricted:
//                                ContentView.canShowPersonalizedAds = false
//                            @unknown default:
//                                ContentView.canShowPersonalizedAds = false
//                        }
                        
                        GADMobileAds.sharedInstance().start(completionHandler: nil)
//                    }
                }
        }
    }
}
