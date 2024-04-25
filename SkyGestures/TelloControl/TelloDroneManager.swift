//
//  TelloDrone.swift
//  HandVectorDemo
//
//  Created by zlinoliver on 2024/4/5.
//

import Foundation

class TelloDroneManager: ObservableObject {
    @Published var isConnected: Bool = false
    private var telloDrone: TelloDrone?

    init() {
        self.telloDrone = TelloDrone(host: "192.168.10.1", port: 8889)
    }

    func connectToDrone() {
        telloDrone?.tryConnect { [weak self] success in
            DispatchQueue.main.async {
                self?.isConnected = success
                if success {
                    print("Connected to Tello drone")
                } else {
                    print("Failed to connect to Tello drone")
                }
            }
        }
    }

    //Take off
    func takeoff() {
        telloDrone?.takeoff { response in
            DispatchQueue.main.async {
                print("Takeoff response: \(response)")
            }
        }
    }

    //Land
    func land() {
        telloDrone?.land { response in
            DispatchQueue.main.async {
                print("Land response: \(response)")
            }
        }
    }
    
    // Set the speed of the drone in KPH
    // speed value: 1 ~ 5
    func setSpeed(kph: Int) {
        // Define the input range and desired speed range in KPH
        let inputRange: ClosedRange<Int> = 1...5
        let speedRange: ClosedRange<Double> = 0.1...3.6
        
        // Convert the input KPH from the range of 1-5 to a speed value in the range of 0.1 KPH to 3.6 KPH
        let speedValue = Double(kph - inputRange.lowerBound) / Double(inputRange.upperBound - inputRange.lowerBound) * (speedRange.upperBound - speedRange.lowerBound) + speedRange.lowerBound
        
        // Convert KPH to centimeters/second, ensuring the result is within the API's expected range (1 to 100)
        let telloSpeed = min(max(Int(speedValue * 27.778), 1), 100)
        
        telloDrone?.setSpeed(speed: telloSpeed, completion: { response in
            DispatchQueue.main.async {
                print("Set Speed to \(speedValue) KPH (\(telloSpeed) cm/s) response: \(response)")
            }
        })
    }

    //Fly forward
    //distance (int): Distance to move.
    func flyForward(distance: Int) {
        
        telloDrone?.moveForward(distance: distance) { response in
            DispatchQueue.main.async {
                print("Move Forward response: \(response)")
            }
        }
    }

    //Fly backward
    //distance (int): Distance to move.
    func flyBackward(distance: Int) {
        
        telloDrone?.moveBackward(distance: distance) { response in
            DispatchQueue.main.async {
                print("Move Backward response: \(response)")
            }
        }
    }

    //Flip the drone
    //direction (str): Direction to flip, 'l', 'r', 'f', 'b'.
    func flip(direction: String) {
        
        telloDrone?.flip(direction: direction) { response in
            DispatchQueue.main.async {
                print("Flip \(direction) response: \(response)")
            }
        }
    }
    
    
    // Fly upward
    //distance (int): Distance to move.
    func flyUpward(distance: Int) {
        telloDrone?.flyUpward(distance: distance) { response in
            DispatchQueue.main.async {
                print("Fly Upward response: \(response)")
            }
        }
    }

    // Fly downward
    //distance (int): Distance to move.
    func flyDownward(distance: Int) {
        telloDrone?.flyDownward(distance: distance) { response in
            DispatchQueue.main.async {
                print("Fly Downward response: \(response)")
            }
        }
    }

    // Fly leftward
    //distance (int): Distance to move.
    func flyLeftward(distance: Int) {
        telloDrone?.flyLeftward(distance: distance) { response in
            DispatchQueue.main.async {
                print("Fly Leftward response: \(response)")
            }
        }
    }

    // Fly rightward
    //distance (int): Distance to move.
    func flyRightward(distance: Int) {
        telloDrone?.flyRightward(distance: distance) { response in
            DispatchQueue.main.async {
                print("Fly Rightward response: \(response)")
            }
        }
    }

    // Rotate leftward
    //degrees (int): Degrees to rotate, 1 to 360.
    func rotateLeftward(degrees: Int) {
        telloDrone?.rotateLeftward(degrees: degrees) { response in
            DispatchQueue.main.async {
                print("Rotate Leftward response: \(response)")
            }
        }
    }

    // Rotate rightward
    //degrees (int): Degrees to rotate, 1 to 360.
    func rotateRightward(degrees: Int) {
        telloDrone?.rotateRightward(degrees: degrees) { response in
            DispatchQueue.main.async {
                print("Rotate Rightward response: \(response)")
            }
        }
    }

    // Stop movement
    func stop() {
        telloDrone?.stop(completion: { response in
            DispatchQueue.main.async {
                print("Stop response: \(response)")
            }
        })
    }
    
}
