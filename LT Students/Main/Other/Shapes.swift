//
//  Shapes.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 5/28/22.
//

import Foundation
import SwiftUI

struct Arrow: Shape {
    
    let widthMultiplier: Double
    let heightMultiplier: Double
    // 1.
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            
            // 2.
            path.addLines( [
                CGPoint(x: width * 0.4 * widthMultiplier, y: height * heightMultiplier),
                CGPoint(x: width * 0.4 * widthMultiplier, y: height * 0.5 * heightMultiplier),
                CGPoint(x: width * 0.2 * widthMultiplier, y: height * 0.5 * heightMultiplier),
                CGPoint(x: width * 0.5 * widthMultiplier, y: height * 0.1 * heightMultiplier),
                CGPoint(x: width * 0.8 * widthMultiplier, y: height * 0.5 * heightMultiplier),
                CGPoint(x: width * 0.6 * widthMultiplier, y: height * 0.5 * heightMultiplier),
                CGPoint(x: width * 0.6 * widthMultiplier, y: height * heightMultiplier)
                
            ])
            // 3.
            path.closeSubpath()
        }
    }
}
