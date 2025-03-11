//
//  ButtonView.swift
//  GameControllerTester
//
//  Created for GameControllerTester.
//

import SwiftUI

struct ButtonView: View {
    let name: String
    let isPressed: Bool
    let value: Float
    
    var body: some View {
        ZStack {
            Circle()
                .fill(isPressed ? Color.blue : Color.gray.opacity(0.3))
                .frame(width: 60, height: 60)
            
            Text(name)
                .foregroundColor(isPressed ? .white : .black)
                .fontWeight(isPressed ? .bold : .regular)
        }
        .shadow(radius: isPressed ? 5 : 0)
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .animation(.spring(), value: isPressed)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ButtonView(name: "A", isPressed: false, value: 0.0)
                .previewLayout(.sizeThatFits)
                .padding()
            
            ButtonView(name: "B", isPressed: true, value: 1.0)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
} 