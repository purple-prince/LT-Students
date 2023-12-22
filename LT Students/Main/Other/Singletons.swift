//
//  Singletons.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 6/24/22.
//

import Foundation
import UIKit
import GoogleMobileAds

class HapticManager {
        
    enum HapticType { case light, medium, heavy, rigid, soft, success, warning, error }
    
    static let manager = HapticManager()
    
    func playHaptic(type: HapticType) {
        
        if User.instance.haptics_on {
            switch type {
                case .light:
                    let generator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.light)
                    generator.impactOccurred()
                case .medium:
                    let generator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.medium)
                    generator.impactOccurred()
                case .heavy:
                    let generator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.heavy)
                    generator.impactOccurred()
                case .rigid:
                    let generator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.rigid)
                    generator.impactOccurred()
                case .soft:
                    let generator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.soft)
                    generator.impactOccurred()
                case .success:
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                case .warning:
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning)
                case .error:
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.error)
            }
        }
    }
}

final class RewardedAd {//ca-app-pub-3940256099942544/1712485313 //ca-app-pub-3940256099942544/6978759866
    private let rewardId = "ca-app-pub-3940256099942544/1712485313" // TODO: replace this with your own Ad ID
    
    var rewardedAd: GADRewardedAd?
    
    init() {
        load()
    }
    
    func load(){
        let request = GADRequest()
        // add extras here to the request, for example, for not presonalized Ads
        GADRewardedAd.load(withAdUnitID: rewardId, request: request, completionHandler: {rewardedAd, error in
            if error != nil {
                // loading the rewarded Ad failed :(
                return
            }
            self.rewardedAd = rewardedAd
        })
    }
    
    func showAd(rewardFunction: @escaping () -> Void) -> Bool {
        guard let rewardedAd = rewardedAd else {
            return false
        }
        
        guard let root = UIApplication.shared.keyWindowPresentedController else {
            return false
        }
        rewardedAd.present(fromRootViewController: root, userDidEarnRewardHandler: rewardFunction)
        return true
    }
}
