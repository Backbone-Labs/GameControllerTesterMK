//
//  ControllerModel.swift
//  GameControllerTester
//
//  Created for GameControllerTester.
//

import Foundation
import GameController

// Enum to represent different controller types
enum ControllerType: String {
    case unknown = "Unknown Controller"
    case xbox = "Xbox Controller"
    case playStation = "PlayStation Controller"
    case mfi = "MFi Controller"
    case nintendo = "Nintendo Controller"
    
    // Determine controller type based on GCController
    static func from(_ controller: GCController) -> ControllerType {
        let vendorName = controller.vendorName?.lowercased() ?? ""
        let productCategory = controller.productCategory.lowercased() ?? ""
        
        print("Detecting controller type: vendorName=\(vendorName), productCategory=\(productCategory)")
        
        if vendorName.contains("xbox") || vendorName.contains("microsoft") {
            return .xbox
        } else if vendorName.contains("playstation") || 
                  vendorName.contains("sony") || 
                  vendorName.contains("dualsense") || 
                  vendorName.contains("dualshock") ||
                  productCategory.contains("dualsense") ||
                  productCategory.contains("dualshock") ||
                  productCategory.contains("playstation") {
            return .playStation
        } else if vendorName.contains("nintendo") || vendorName.contains("switch") {
            return .nintendo
        } else if controller.extendedGamepad != nil {
            // Check if it might be a PlayStation controller that wasn't detected by name
            if #available(iOS 14.0, *) {
                if controller.physicalInputProfile is GCDualShockGamepad {
                    return .playStation
                }
                
                if #available(iOS 14.5, *) {
                    if controller.physicalInputProfile is GCDualSenseGamepad {
                        return .playStation
                    }
                }
            }
            return .mfi
        } else {
            return .unknown
        }
    }
}

// Model to represent a connected controller and its state
class ControllerModel: Identifiable {
    let id: String
    let controller: GCController
    let type: ControllerType
    
    // Controller information
    var name: String
    var batteryLevel: Float?
    var batteryState: GCDeviceBattery.State?
    
    // Input states
    var buttons: [InputType: ButtonState]
    var joysticks: [InputType: JoystickState]
    var triggers: [InputType: TriggerState]
    var dpad: DPadState
    var touchpad: TouchpadState?
    
    init(controller: GCController) {
        self.controller = controller
        self.id = controller.vendorName ?? UUID().uuidString
        self.type = ControllerType.from(controller)
        
        // Set controller name
        if let vendorName = controller.vendorName {
            self.name = vendorName
        } else {
            self.name = "Game Controller"
        }
        
        // Initialize battery info if available
        if let battery = controller.battery {
            self.batteryLevel = battery.batteryLevel
            self.batteryState = battery.batteryState
        }
        
        // Initialize input states
        self.buttons = [:]
        self.joysticks = [:]
        self.triggers = [:]
        self.dpad = DPadState()
        
        // Initialize button states
        for inputType in [
            InputType.buttonA, .buttonB, .buttonX, .buttonY,
            .buttonMenu, .buttonOptions, .buttonHome,
            .leftShoulder, .rightShoulder,
            .leftThumbstickButton, .rightThumbstickButton
        ] {
            buttons[inputType] = ButtonState()
        }
        
        // Initialize joystick states
        joysticks[.leftThumbstick] = JoystickState()
        joysticks[.rightThumbstick] = JoystickState()
        
        // Initialize trigger states
        triggers[.leftTrigger] = TriggerState()
        triggers[.rightTrigger] = TriggerState()
        
        // Initialize touchpad for PlayStation controllers
        if type == .playStation {
            touchpad = TouchpadState()
        }
    }
    
    // Update battery information
    func updateBatteryInfo() {
        if let battery = controller.battery {
            self.batteryLevel = battery.batteryLevel
            self.batteryState = battery.batteryState
        }
    }
} 
