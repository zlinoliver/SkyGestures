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
    func pressTakeoff() {
        telloDrone?.takeoff { response in
            DispatchQueue.main.async {
                print("Takeoff response: \(response)")
            }
        }
    }

    //Land
    func pressLand() {
        telloDrone?.land { response in
            DispatchQueue.main.async {
                print("Land response: \(response)")
            }
        }
    }

    //Move forward
    //distance (int): Distance to move.
    func pressMoveForward(distance: Int) {
        
        //This method expects KPH or MPH. The Tello API expects speeds from 1 to 100 centimeters/second.
        //Metric: .1 to 3.6 KPH
        //Args: speed (int|float): Speed.
        telloDrone?.setSpeed(speed: 10, completion: { response in
            DispatchQueue.main.async {
                print("setSpeed response: \(response)")
            }
        })
        
        telloDrone?.moveForward(distance: distance) { response in
            DispatchQueue.main.async {
                print("Move Forward response: \(response)")
            }
        }
    }

    //Move backward
    //distance (int): Distance to move.
    func pressMoveBackward(distance: Int) {
        
        //This method expects KPH or MPH. The Tello API expects speeds from 1 to 100 centimeters/second.
        //Metric: .1 to 3.6 KPH
        //Args: speed (int|float): Speed.
        telloDrone?.setSpeed(speed: 10, completion: { response in
            DispatchQueue.main.async {
                print("setSpeed response: \(response)")
            }
        })
        
        telloDrone?.moveBackward(distance: distance) { response in
            DispatchQueue.main.async {
                print("Move Backward response: \(response)")
            }
        }
    }

    //Flip the drone
    //direction (str): Direction to flip, 'l', 'r', 'f', 'b'.
    func pressFlip(direction: String) {
        telloDrone?.flip(direction: direction) { response in
            DispatchQueue.main.async {
                print("Flip \(direction) response: \(response)")
            }
        }
    }
    
}
