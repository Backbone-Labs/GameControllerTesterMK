//
//  InputState.swift
//  GameControllerTester
//
//  Created for GameControllerTester.
//

import Foundation
import GameController

// Enum to represent different types of controller inputs
enum InputType: String, Identifiable {
    // Standard buttons
    case buttonA, buttonB, buttonX, buttonY
    case buttonMenu, buttonOptions, buttonHome
    case leftShoulder, rightShoulder
    
    // Triggers
    case leftTrigger, rightTrigger
    
    // Thumbsticks
    case leftThumbstick, rightThumbstick
    case leftThumbstickButton, rightThumbstickButton
    
    // D-Pad
    case dpadUp, dpadDown, dpadLeft, dpadRight
    
    // Touch pad (for PlayStation controllers)
    case touchpad, touchpadButton
    
    var id: String { self.rawValue }
    
    // Display name for the input
    var displayName: String {
        switch self {
        case .buttonA: return "A"
        case .buttonB: return "B"
        case .buttonX: return "X"
        case .buttonY: return "Y"
        case .buttonMenu: return "Menu"
        case .buttonOptions: return "Options"
        case .buttonHome: return "Home"
        case .leftShoulder: return "L1"
        case .rightShoulder: return "R1"
        case .leftTrigger: return "L2"
        case .rightTrigger: return "R2"
        case .leftThumbstick: return "Left Stick"
        case .rightThumbstick: return "Right Stick"
        case .leftThumbstickButton: return "L3"
        case .rightThumbstickButton: return "R3"
        case .dpadUp: return "Up"
        case .dpadDown: return "Down"
        case .dpadLeft: return "Left"
        case .dpadRight: return "Right"
        case .touchpad: return "Touchpad"
        case .touchpadButton: return "Touchpad Button"
        }
    }
}

// Represents the state of a digital button
struct ButtonState {
    var isPressed: Bool = false
    var value: Float = 0.0 // For pressure-sensitive buttons
}

// Represents the state of an analog stick
struct JoystickState {
    var x: Float = 0.0
    var y: Float = 0.0
    var isPressed: Bool = false // For clickable thumbsticks
}

// Represents the state of a trigger
struct TriggerState {
    var value: Float = 0.0
    var isPressed: Bool = false // For digital trigger state
}

// Represents the state of a D-pad
struct DPadState {
    var up: Bool = false
    var down: Bool = false
    var left: Bool = false
    var right: Bool = false
}

// Represents the state of a touchpad (for PlayStation controllers)
struct TouchpadState {
    var isPressed: Bool = false
    var touchPoints: [CGPoint] = []
} 