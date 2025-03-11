//
//  ControllerView.swift
//  GameControllerTester
//
//  Created for GameControllerTester.
//

import SwiftUI
import GameController

struct ControllerView: View {
    @ObservedObject var viewModel: ControllerViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let controller = viewModel.selectedController {
                    // Face Buttons (A, B, X, Y)
                    VStack {
                        Text("Face Buttons")
                            .font(.headline)
                        
                        HStack(spacing: 20) {
                            // A Button
                            if let buttonState = controller.buttons[.buttonA] {
                                ButtonView(
                                    name: "A",
                                    isPressed: buttonState.isPressed,
                                    value: buttonState.value
                                )
                            }
                            
                            // B Button
                            if let buttonState = controller.buttons[.buttonB] {
                                ButtonView(
                                    name: "B",
                                    isPressed: buttonState.isPressed,
                                    value: buttonState.value
                                )
                            }
                            
                            // X Button
                            if let buttonState = controller.buttons[.buttonX] {
                                ButtonView(
                                    name: "X",
                                    isPressed: buttonState.isPressed,
                                    value: buttonState.value
                                )
                            }
                            
                            // Y Button
                            if let buttonState = controller.buttons[.buttonY] {
                                ButtonView(
                                    name: "Y",
                                    isPressed: buttonState.isPressed,
                                    value: buttonState.value
                                )
                            }
                        }
                    }
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    
                    // Shoulder Buttons and Triggers
                    VStack {
                        Text("Shoulders & Triggers")
                            .font(.headline)
                        
                        HStack(spacing: 20) {
                            VStack {
                                // L1 Button
                                if let buttonState = controller.buttons[.leftShoulder] {
                                    ButtonView(
                                        name: "L1",
                                        isPressed: buttonState.isPressed,
                                        value: buttonState.value
                                    )
                                }
                                
                                // L2 Trigger
                                if let triggerState = controller.triggers[.leftTrigger] {
                                    TriggerView(
                                        name: "L2",
                                        value: triggerState.value,
                                        isPressed: triggerState.isPressed
                                    )
                                }
                            }
                            
                            VStack {
                                // R1 Button
                                if let buttonState = controller.buttons[.rightShoulder] {
                                    ButtonView(
                                        name: "R1",
                                        isPressed: buttonState.isPressed,
                                        value: buttonState.value
                                    )
                                }
                                
                                // R2 Trigger
                                if let triggerState = controller.triggers[.rightTrigger] {
                                    TriggerView(
                                        name: "R2",
                                        value: triggerState.value,
                                        isPressed: triggerState.isPressed
                                    )
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    
                    // Thumbsticks
                    VStack {
                        Text("Thumbsticks")
                            .font(.headline)
                        
                        HStack(spacing: 40) {
                            // Left Thumbstick
                            if let joystickState = controller.joysticks[.leftThumbstick] {
                                JoystickView(
                                    name: "Left Stick",
                                    xValue: joystickState.x,
                                    yValue: joystickState.y,
                                    isPressed: joystickState.isPressed
                                )
                            }
                            
                            // Right Thumbstick
                            if let joystickState = controller.joysticks[.rightThumbstick] {
                                JoystickView(
                                    name: "Right Stick",
                                    xValue: joystickState.x,
                                    yValue: joystickState.y,
                                    isPressed: joystickState.isPressed
                                )
                            }
                        }
                    }
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    
                    // D-Pad
                    VStack {
                        Text("D-Pad")
                            .font(.headline)
                        
                        DPadView(
                            upPressed: controller.dpad.up,
                            downPressed: controller.dpad.down,
                            leftPressed: controller.dpad.left,
                            rightPressed: controller.dpad.right
                        )
                    }
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    
                    // Menu Buttons
                    VStack {
                        Text("Menu Buttons")
                            .font(.headline)
                        
                        HStack(spacing: 20) {
                            // Menu Button
                            if let buttonState = controller.buttons[.buttonMenu] {
                                ButtonView(
                                    name: "Menu",
                                    isPressed: buttonState.isPressed,
                                    value: buttonState.value
                                )
                            }
                            
                            // Options Button
                            if let buttonState = controller.buttons[.buttonOptions] {
                                ButtonView(
                                    name: "Options",
                                    isPressed: buttonState.isPressed,
                                    value: buttonState.value
                                )
                            }
                            
                            // Home Button
                            if let buttonState = controller.buttons[.buttonHome] {
                                ButtonView(
                                    name: "Home",
                                    isPressed: buttonState.isPressed,
                                    value: buttonState.value
                                )
                            }
                        }
                    }
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    
                    // PlayStation-specific controls (if applicable)
                    if controller.type == .playStation, let touchpad = controller.touchpad {
                        VStack {
                            Text("PlayStation Controls")
                                .font(.headline)
                            
                            HStack(spacing: 20) {
                                // Touchpad Button
                                if let buttonState = controller.buttons[.touchpadButton] {
                                    ButtonView(
                                        name: "Touchpad",
                                        isPressed: buttonState.isPressed,
                                        value: buttonState.value
                                    )
                                }
                            }
                        }
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }
                }
            }
            .padding()
        }
    }
}

struct ControllerView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ControllerViewModel()
        return ControllerView(viewModel: viewModel)
    }
} 
