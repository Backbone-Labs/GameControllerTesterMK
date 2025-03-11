//
//  TriggerView.swift
//  GameControllerTester
//
//  Created for GameControllerTester.
//

import SwiftUI

struct TriggerView: View {
    let name: String
    let value: Float
    let isPressed: Bool
    
    var body: some View {
        VStack {
            Text(name)
                .font(.caption)
                .foregroundColor(.secondary)
            
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 30)
                
                // Fill based on value
                RoundedRectangle(cornerRadius: 5)
                    .fill(isPressed ? Color.blue : Color.blue.opacity(0.7))
                    .frame(width: CGFloat(value) * 120, height: 30)
                    .animation(.spring(), value: value)
                
                // Value text
                Text(String(format: "%.2f", value))
                    .foregroundColor(.white)
                    .padding(.leading, 8)
                    .shadow(radius: 1)
            }
        }
    }
}

struct TriggerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TriggerView(name: "L2", value: 0.0, isPressed: false)
                .previewLayout(.sizeThatFits)
                .padding()
            
            TriggerView(name: "R2", value: 0.75, isPressed: true)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
} 