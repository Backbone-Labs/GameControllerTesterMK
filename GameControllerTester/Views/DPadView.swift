//
//  DPadView.swift
//  GameControllerTester
//
//  Created for GameControllerTester.
//

import SwiftUI

struct DPadView: View {
    let upPressed: Bool
    let downPressed: Bool
    let leftPressed: Bool
    let rightPressed: Bool
    
    var body: some View {
        ZStack {
            // Center circle
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 30, height: 30)
            
            // Up button
            DPadButtonView(
                direction: "Up",
                isPressed: upPressed,
                rotation: 0
            )
            .offset(y: -40)
            
            // Right button
            DPadButtonView(
                direction: "Right",
                isPressed: rightPressed,
                rotation: 90
            )
            .offset(x: 40)
            
            // Down button
            DPadButtonView(
                direction: "Down",
                isPressed: downPressed,
                rotation: 180
            )
            .offset(y: 40)
            
            // Left button
            DPadButtonView(
                direction: "Left",
                isPressed: leftPressed,
                rotation: 270
            )
            .offset(x: -40)
        }
        .frame(width: 120, height: 120)
    }
}

struct DPadButtonView: View {
    let direction: String
    let isPressed: Bool
    let rotation: Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(isPressed ? Color.blue : Color.gray.opacity(0.5))
                .frame(width: 30, height: 30)
                .rotationEffect(.degrees(rotation))
                .shadow(radius: isPressed ? 3 : 0)
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .animation(.spring(), value: isPressed)
        }
    }
}

struct DPadView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DPadView(upPressed: false, downPressed: false, leftPressed: false, rightPressed: false)
                .previewLayout(.sizeThatFits)
                .padding()
            
            DPadView(upPressed: true, downPressed: false, leftPressed: true, rightPressed: false)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
} 