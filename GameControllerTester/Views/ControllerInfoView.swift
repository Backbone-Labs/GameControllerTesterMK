//
//  ControllerInfoView.swift
//  GameControllerTester
//
//  Created for GameControllerTester.
//

import SwiftUI
import GameController

struct ControllerInfoView: View {
    let controller: ControllerModel
    let batteryLevel: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "gamecontroller.fill")
                    .font(.title)
                    .foregroundColor(.blue)
                
                Text(controller.name)
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            Divider()
            
            HStack {
                Label("Type", systemImage: "info.circle")
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(controller.type.rawValue)
                    .fontWeight(.medium)
            }
            
            if controller.batteryLevel != nil {
                HStack {
                    Label("Battery", systemImage: batteryIcon)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(batteryLevel)
                        .fontWeight(.medium)
                }
            }
        }
        .padding()
        .background(Color(Color.black))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
    
    var batteryIcon: String {
        guard let state = controller.batteryState,
              let level = controller.batteryLevel else {
            return "battery.0"
        }
        
        if state == .charging {
            return "battery.100.bolt"
        }
        
        let percentage = Int(level * 100)
        if percentage <= 10 {
            return "battery.0"
        } else if percentage <= 25 {
            return "battery.25"
        } else if percentage <= 50 {
            return "battery.50"
        } else if percentage <= 75 {
            return "battery.75"
        } else {
            return "battery.100"
        }
    }
}

struct ControllerInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let mockController = GCController()
        let controllerModel = ControllerModel(controller: mockController)
        
        return ControllerInfoView(
            controller: controllerModel,
            batteryLevel: "75%"
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
} 
