//
//  ControllerViewModel.swift
//  GameControllerTester
//
//  Created for GameControllerTester.
//

import Foundation
import GameController
import SwiftUI
import Combine

class ControllerViewModel: ObservableObject {
    // Published properties for UI updates
    @Published var connectedControllers: [ControllerModel] = []
    @Published var selectedController: ControllerModel?
    @Published var isDiscovering: Bool = false
    
    // Timer for periodic updates
    private var updateTimer: Timer?
    
    init() {
        setupControllerDiscovery()
        startUpdateTimer()
    }
    
    deinit {
        updateTimer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Controller Discovery
    
    private func setupControllerDiscovery() {
        print("Setting up controller discovery...")
        
        // Register for controller connection notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(controllerConnected),
            name: .GCControllerDidConnect,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(controllerDisconnected),
            name: .GCControllerDidDisconnect,
            object: nil
        )
        
        // Enable background controller connections
        if #available(iOS 14.0, *) {
            GCController.shouldMonitorBackgroundEvents = true
            print("Enabled background controller connections")
        }
        
        // Check for already connected controllers
        let existingControllers = GCController.controllers()
        print("Found \(existingControllers.count) already connected controllers")
        for controller in existingControllers {
            print("Controller found: \(controller.vendorName ?? "Unknown") - \(controller.productCategory ?? "Unknown")")
            addController(controller)
        }
        
        // Start discovery
        startDiscovery()
        
        // Set up a timer to periodically check for controllers
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            let controllers = GCController.controllers()
            print("Periodic check: Found \(controllers.count) controllers")
            
            if controllers.isEmpty {
                // Restart discovery if no controllers are found
                self?.startDiscovery()
            }
        }
    }
    
    func startDiscovery() {
        if isDiscovering {
            print("Already discovering controllers, skipping...")
            return
        }
        
        isDiscovering = true
        print("Starting controller discovery...")
        
        // Set to continuously monitor for controllers
        GCController.shouldMonitorBackgroundEvents = true
        
        GCController.startWirelessControllerDiscovery { [weak self] in
            print("Controller discovery completion handler called")
            self?.isDiscovering = false
            
            // Check if we found any controllers
            let controllers = GCController.controllers()
            print("After discovery, found \(controllers.count) controllers")
            
            for controller in controllers {
                print("Controller: \(controller.vendorName ?? "Unknown") - \(controller.productCategory ?? "Unknown")")
                self?.addController(controller)
            }
        }
    }
    
    @objc private func controllerConnected(_ notification: Notification) {
        if let controller = notification.object as? GCController {
            print("Controller connected: \(controller.vendorName ?? "Unknown")")
            addController(controller)
        }
    }
    
    @objc private func controllerDisconnected(_ notification: Notification) {
        if let controller = notification.object as? GCController {
            removeController(controller)
        }
    }
    
    public func addController(_ controller: GCController) {
        // Create model for the controller
        let controllerModel = ControllerModel(controller: controller)
        
        // Add to connected controllers if not already present
        if !connectedControllers.contains(where: { $0.id == controllerModel.id }) {
            print("Adding controller: \(controller.vendorName ?? "Unknown")")
            connectedControllers.append(controllerModel)
            
            // Select this controller if none is selected
            if selectedController == nil {
                selectedController = controllerModel
            }
            
            // Setup input handlers
            setupInputHandling(for: controllerModel)
        } else {
            print("Controller already added: \(controller.vendorName ?? "Unknown")")
        }
    }
    
    private func removeController(_ controller: GCController) {
        // Remove from connected controllers
        if let index = connectedControllers.firstIndex(where: { $0.controller == controller }) {
            let removedController = connectedControllers.remove(at: index)
            
            // Update selected controller if needed
            if selectedController?.id == removedController.id {
                selectedController = connectedControllers.first
            }
        }
    }
    
    // MARK: - Input Handling
    
    private func setupInputHandling(for controllerModel: ControllerModel) {
        let controller = controllerModel.controller
        
        // Setup handlers for extended gamepad profile
        if let gamepad = controller.extendedGamepad {
            // Button A
            gamepad.buttonA.valueChangedHandler = { [weak self] (button, value, pressed) in
                self?.updateButtonState(for: controllerModel, type: .buttonA, value: value, pressed: pressed)
            }
            
            // Button B
            gamepad.buttonB.valueChangedHandler = { [weak self] (button, value, pressed) in
                self?.updateButtonState(for: controllerModel, type: .buttonB, value: value, pressed: pressed)
            }
            
            // Button X
            gamepad.buttonX.valueChangedHandler = { [weak self] (button, value, pressed) in
                self?.updateButtonState(for: controllerModel, type: .buttonX, value: value, pressed: pressed)
            }
            
            // Button Y
            gamepad.buttonY.valueChangedHandler = { [weak self] (button, value, pressed) in
                self?.updateButtonState(for: controllerModel, type: .buttonY, value: value, pressed: pressed)
            }
            
            // Left Shoulder
            gamepad.leftShoulder.valueChangedHandler = { [weak self] (button, value, pressed) in
                self?.updateButtonState(for: controllerModel, type: .leftShoulder, value: value, pressed: pressed)
            }
            
            // Right Shoulder
            gamepad.rightShoulder.valueChangedHandler = { [weak self] (button, value, pressed) in
                self?.updateButtonState(for: controllerModel, type: .rightShoulder, value: value, pressed: pressed)
            }
            
            // Left Trigger
            gamepad.leftTrigger.valueChangedHandler = { [weak self] (trigger, value, pressed) in
                self?.updateTriggerState(for: controllerModel, type: .leftTrigger, value: value, pressed: pressed)
            }
            
            // Right Trigger
            gamepad.rightTrigger.valueChangedHandler = { [weak self] (trigger, value, pressed) in
                self?.updateTriggerState(for: controllerModel, type: .rightTrigger, value: value, pressed: pressed)
            }
            
            // Left Thumbstick
            gamepad.leftThumbstick.valueChangedHandler = { [weak self] (stick, xValue, yValue) in
                self?.updateJoystickState(for: controllerModel, type: .leftThumbstick, x: xValue, y: yValue)
            }
            
            // Right Thumbstick
            gamepad.rightThumbstick.valueChangedHandler = { [weak self] (stick, xValue, yValue) in
                self?.updateJoystickState(for: controllerModel, type: .rightThumbstick, x: xValue, y: yValue)
            }
            
            // D-Pad
            gamepad.dpad.valueChangedHandler = { [weak self] (dpad, xValue, yValue) in
                self?.updateDPadState(for: controllerModel, x: xValue, y: yValue)
            }
            
            // Menu Button
            gamepad.buttonMenu.valueChangedHandler = { [weak self] (button, value, pressed) in
                self?.updateButtonState(for: controllerModel, type: .buttonMenu, value: value, pressed: pressed)
            }
            
            // Options Button (if available)
            if #available(iOS 14.0, *) {
                gamepad.buttonOptions?.valueChangedHandler = { [weak self] (button, value, pressed) in
                    self?.updateButtonState(for: controllerModel, type: .buttonOptions, value: value, pressed: pressed)
                }
            }
            
            // Home Button (if available)
            if #available(iOS 14.0, *) {
                gamepad.buttonHome?.valueChangedHandler = { [weak self] (button, value, pressed) in
                    self?.updateButtonState(for: controllerModel, type: .buttonHome, value: value, pressed: pressed)
                }
            }
            
            // Thumbstick Buttons
            if #available(iOS 14.0, *) {
                gamepad.leftThumbstickButton?.valueChangedHandler = { [weak self] (button, value, pressed) in
                    self?.updateButtonState(for: controllerModel, type: .leftThumbstickButton, value: value, pressed: pressed)
                    if var joystickState = controllerModel.joysticks[.leftThumbstick] {
                        joystickState.isPressed = pressed
                        controllerModel.joysticks[.leftThumbstick] = joystickState
                    }
                }
                
                gamepad.rightThumbstickButton?.valueChangedHandler = { [weak self] (button, value, pressed) in
                    self?.updateButtonState(for: controllerModel, type: .rightThumbstickButton, value: value, pressed: pressed)
                    if var joystickState = controllerModel.joysticks[.rightThumbstick] {
                        joystickState.isPressed = pressed
                        controllerModel.joysticks[.rightThumbstick] = joystickState
                    }
                }
            }
        }
        
        // Setup handlers for DualShock/DualSense specific features
        if #available(iOS 14.0, *) {
            if let dualShock = controller.physicalInputProfile as? GCDualShockGamepad {
                // Touchpad Button
                dualShock.touchpadButton.valueChangedHandler = { [weak self] (button, value, pressed) in
                    self?.updateButtonState(for: controllerModel, type: .touchpadButton, value: value, pressed: pressed)
                    controllerModel.touchpad?.isPressed = pressed
                }
                
                // Touchpad (not directly accessible through the API)
            }
            
            if #available(iOS 14.5, *) {
                if let dualSense = controller.physicalInputProfile as? GCDualSenseGamepad {
                    // Touchpad Button
                    dualSense.touchpadButton.valueChangedHandler = { [weak self] (button, value, pressed) in
                        self?.updateButtonState(for: controllerModel, type: .touchpadButton, value: value, pressed: pressed)
                        controllerModel.touchpad?.isPressed = pressed
                    }
                    
                    // Touchpad (not directly accessible through the API)
                }
            }
        }
    }
    
    // MARK: - State Updates
    
    private func updateButtonState(for controller: ControllerModel, type: InputType, value: Float, pressed: Bool) {
        var buttonState = controller.buttons[type] ?? ButtonState()
        buttonState.isPressed = pressed
        buttonState.value = value
        controller.buttons[type] = buttonState
        
        // Trigger UI update
        objectWillChange.send()
    }
    
    private func updateJoystickState(for controller: ControllerModel, type: InputType, x: Float, y: Float) {
        var joystickState = controller.joysticks[type] ?? JoystickState()
        joystickState.x = x
        joystickState.y = y
        controller.joysticks[type] = joystickState
        
        // Trigger UI update
        objectWillChange.send()
    }
    
    private func updateTriggerState(for controller: ControllerModel, type: InputType, value: Float, pressed: Bool) {
        var triggerState = controller.triggers[type] ?? TriggerState()
        triggerState.value = value
        triggerState.isPressed = pressed
        controller.triggers[type] = triggerState
        
        // Trigger UI update
        objectWillChange.send()
    }
    
    private func updateDPadState(for controller: ControllerModel, x: Float, y: Float) {
        var dpadState = controller.dpad
        dpadState.up = y == 1.0
        dpadState.down = y == -1.0
        dpadState.left = x == -1.0
        dpadState.right = x == 1.0
        controller.dpad = dpadState
        
        // Trigger UI update
        objectWillChange.send()
    }
    
    // MARK: - Periodic Updates
    
    private func startUpdateTimer() {
        // Update battery info and other periodic tasks every 5 seconds
        updateTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.updateBatteryInfo()
        }
    }
    
    private func updateBatteryInfo() {
        for controller in connectedControllers {
            controller.updateBatteryInfo()
        }
        
        // Trigger UI update
        objectWillChange.send()
    }
    
    func exportResults() {
        // This would be implemented to export test results
        // For now, just a placeholder
        print("Exporting controller test results")
    }
    
    // MARK: - Helper Methods
    
    func getBatteryLevelString(for controller: ControllerModel) -> String {
        guard let level = controller.batteryLevel,
              let state = controller.batteryState else {
            return "Unknown"
        }
        
        let percentage = Int(level * 100)
        
        switch state {
        case .charging:
            return "Charging (\(percentage)%)"
        case .full:
            return "Full"
        case .discharging:
            return "\(percentage)%"
        default:
            return "Unknown"
        }
    }
    
    func logControllerDetails() {
        print("\n--- Controller Details ---")
        let controllers = GCController.controllers()
        print("Total controllers: \(controllers.count)")
        
        for (index, controller) in controllers.enumerated() {
            print("\nController \(index + 1):")
            print("Vendor Name: \(controller.vendorName ?? "Unknown")")
            print("Product Category: \(controller.productCategory ?? "Unknown")")
            print("Has Extended Gamepad: \(controller.extendedGamepad != nil)")
            print("Has Micro Gamepad: \(controller.microGamepad != nil)")
            
            if #available(iOS 14.0, *) {
                print("Current Input Profile: \(type(of: controller.physicalInputProfile))")
                print("Is DualShock: \(controller.physicalInputProfile is GCDualShockGamepad)")
                
                if #available(iOS 14.5, *) {
                    print("Is DualSense: \(controller.physicalInputProfile is GCDualSenseGamepad)")
                }
            }
            
            print("Has Battery Info: \(controller.battery != nil)")
            if let battery = controller.battery {
                print("Battery Level: \(battery.batteryLevel * 100)%")
                print("Battery State: \(battery.batteryState.rawValue)")
            }
        }
        print("--- End Controller Details ---\n")
    }
} 
