//
//  FeedbackView.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 6/2/22.
//

import SwiftUI

struct FeedbackView: View {
    @Binding var showMenuView: Bool
    @Binding var showFeedbackView: Bool
}

extension FeedbackView {
    var body: some View {
        ZStack {
            Color.appGreen.ignoresSafeArea()
            
            CloseButton(mode: .back, size: .big) { showMenuView = true; showFeedbackView = false; }
        }
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView(showMenuView: .constant(false), showFeedbackView: .constant(true))
    }
}
