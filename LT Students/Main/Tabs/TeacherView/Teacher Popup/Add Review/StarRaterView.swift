//
//  StarRaterView.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 5/28/22.
//

import SwiftUI

struct StarRaterView: View {
    let title: String
    let mode: RateModes

    @Binding var niceStars: Double
    @Binding var critStars: Double
    @Binding var teachStars: Double
    
    enum RateModes { case nice, teach, crit }
    
    @State public var starsSelected: Double = 1
    
    var body: some View {
        HStack(spacing: 4) { //.font(Font.system(size: 40))
            
            Text(title)
                .fontWeight(.light)
                .font(.title2)
            
            Spacer()
            
            ForEach(1..<6) { num in
                Image(systemName: starsSelected >= Double(num) ? "star.fill" : "star")
                    .font(.title)
                    .foregroundColor( starsSelected >= Double(num) ? .orange : .black)
                    .onTapGesture {
                        switch num {
                            case 1: starsSelected = 1
                            case 2: starsSelected = 2
                            case 3: starsSelected = 3
                            case 4: starsSelected = 4
                            case 5: starsSelected = 5
                            default: return
                        }
                        
                        switch mode {
                            case .nice: niceStars = starsSelected
                            case .crit: critStars = starsSelected
                            case .teach: teachStars = starsSelected
                        }
                    }
            }
        }
    }
}

struct StarRaterView_Previews: PreviewProvider {
    static var previews: some View {
        StarRaterView(title: "title", mode: .crit, niceStars: .constant(2.0), critStars: .constant(1.0), teachStars: .constant(4.0))
    }
}
