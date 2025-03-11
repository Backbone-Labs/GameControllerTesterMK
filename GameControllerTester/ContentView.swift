//
//  ContentView.swift
//  GameControllerTester
//
//  Created by Maneet Khaira on 3/9/25.
//

import SwiftUI
import GameController

struct ContentView: View {
    @StateObject private var viewModel = ControllerViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if let controller = viewModel.selectedController {
                    // Controller is connected
                    ScrollView {
                        VStack(spacing: 20) {
                            // Controller Info
                            ControllerInfoView(
                                controller: controller,
                                batteryLevel: viewModel.getBatteryLevelString(for: controller)
                            )
                            
                            // Controller Inputs
                            ControllerView(viewModel: viewModel)
                            
                            // Advanced Features
                            VStack {
                                Text("Advanced Features")
                                    .font(.headline)
                                
                                HStack(spacing: 20) {
                                    
                                    Button(action: {
                                        viewModel.exportResults()
                                    }) {
                                        Label("Export Results", systemImage: "square.and.arrow.up")
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.black)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        }
                        .padding()
                    }
                } else {
                    // No controller connected
                    VStack(spacing: 20) {
                        Image(systemName: "gamecontroller")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        
                        Text("No Controller Connected")
                            .font(.title)
                        
                        Text("Connect a game controller to begin testing")
                            .foregroundColor(.secondary)
                        
                        VStack(spacing: 15) {
                            Button(action: {
                                viewModel.startDiscovery()
                            }) {
                                Label(
                                    viewModel.isDiscovering ? "Searching..." : "Start Controller Discovery",
                                    systemImage: viewModel.isDiscovering ? "antenna.radiowaves.left.and.right" : "magnifyingglass"
                                )
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            .disabled(viewModel.isDiscovering)
                            
                            Button(action: {
                                // Force refresh the controller list
                                let controllers = GCController.controllers()
                                print("Manual check: Found \(controllers.count) controllers")
                                
                                for controller in controllers {
                                    print("Controller: \(controller.vendorName ?? "Unknown") - \(controller.productCategory ?? "Unknown")")
                                    viewModel.addController(controller)
                                }
                                
                                // Restart discovery
                                GCController.stopWirelessControllerDiscovery()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    viewModel.startDiscovery()
                                }
                            }) {
                                Label("Force Refresh Controllers", systemImage: "arrow.clockwise")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        
                        Button(action: {
                            let controllers = GCController.controllers()
                            print("Available controllers: \(controllers.count)")
                            for (index, controller) in controllers.enumerated() {
                                print("Controller \(index): \(controller.vendorName ?? "Unknown"), Product: \(controller.productCategory ?? "Unknown")")
                                if #available(iOS 14.0, *) {
                                    print("  - Has DualShock profile: \(controller.physicalInputProfile is GCDualShockGamepad)")
                                    if #available(iOS 14.5, *) {
                                        print("  - Has DualSense profile: \(controller.physicalInputProfile is GCDualSenseGamepad)")
                                    }
                                }
                                print("  - Has extended gamepad: \(controller.extendedGamepad != nil)")
                            }
                            
                            // Force refresh controller list
                            viewModel.startDiscovery()
                        }) {
                            Label("Debug Controllers", systemImage: "ladybug")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                    }
                    .padding()
                }
            }
            .navigationTitle("Game Controller Tester")
            .toolbar {
                if viewModel.connectedControllers.count > 1 {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            ForEach(viewModel.connectedControllers) { controller in
                                Button(controller.name) {
                                    viewModel.selectedController = controller
                                }
                            }
                        } label: {
                            Label("Select Controller", systemImage: "gamecontroller")
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
