//
//  JoystickView.swift
//  GameControllerTester
//
//  Created for GameControllerTester.
//

import SwiftUI

struct JoystickView: View {
    let name: String
    let xValue: Float
    let yValue: Float
    let isPressed: Bool
    
    var body: some View {
        VStack {
            Text(name)
                .font(.caption)
                .foregroundColor(.secondary)
            
            ZStack {
                // Outer circle (boundary)
                Circle()
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: 100, height: 100)
                
                // Cross hairs
                Group {
                    Rectangle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 1, height: 100)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 100, height: 1)
                }
                
                // Inner circle (joystick position)
                Circle()
                    .fill(isPressed ? Color.blue : Color.blue.opacity(0.7))
                    .frame(width: 40, height: 40)
                    .offset(
                        x: CGFloat(xValue) * 30,
                        y: CGFloat(-yValue) * 30
                    )
                    .shadow(radius: isPressed ? 5 : 2)
            }
            
            // X and Y values
            HStack {
                Text("X: \(String(format: "%.2f", xValue))")
                    .font(.caption)
                
                Text("Y: \(String(format: "%.2f", yValue))")
                    .font(.caption)
            }
        }
    }
}

struct JoystickView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            JoystickView(name: "Left Stick", xValue: 0.0, yValue: 0.0, isPressed: false)
                .previewLayout(.sizeThatFits)
                .padding()
            
            JoystickView(name: "Right Stick", xValue: 0.5, yValue: -0.5, isPressed: true)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
} 