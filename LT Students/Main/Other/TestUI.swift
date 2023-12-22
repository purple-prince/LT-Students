//
//  TestUI.swift
//  LT Reviews
//
//  Created by Charlie Reeder on 6/1/22.
//

import SwiftUI
import Firebase

struct OffsetPrefKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        
    }
}

struct OffsettableScrollView<T: View>: View {
    
    let axes: Axis.Set
    let showsIndicators: Bool
    let offsetChanged: (CGPoint) -> Void
    let content: T
    
    init(axes: Axis.Set = .vertical, showsIndicators: Bool = false, offsetChanged: @escaping (CGPoint) -> Void = { _ in }, @ViewBuilder content: () -> T) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.offsetChanged = offsetChanged
        self.content = content()
    }
    
    var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            GeometryReader { geo in
                Color.clear
                    .preference(key: OffsetPrefKey.self, value: geo.frame(in: .named("ScrollView")).origin)
            }
            .frame(width: 0, height: 0)
            
            content
        }
        .coordinateSpace(name: "ScrollView")
        .onPreferenceChange(OffsetPrefKey.self, perform: offsetChanged)
    }
}

struct TestUI: View {
    
    @State var vertOffset: CGFloat = 0.0
    
    var body: some View {
        VStack {
            
            Text("Offset: \(String(format: "%.2f", vertOffset))")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.purple)
            
            OffsettableScrollView { point in
                vertOffset = point.y
            } content: {
                LazyVStack {
                    ForEach(0..<200) { num in
                        Text("Row" + String(num))
                            .padding()
                    }
                }
            }
        }
    }
}

struct TestUI_Previews: PreviewProvider {
    static var previews: some View {
        TestUI()
    }
}
