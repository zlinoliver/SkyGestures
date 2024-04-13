//
//  TelloSocket.swift
//  HandVectorDemo
//
//  Created by zlinoliver on 2024/4/5.
//

import Network

class TelloDrone {
    private var connection: NWConnection
    private let host: NWEndpoint.Host
    private let port: NWEndpoint.Port

    init(host: String, port: UInt16) {
        self.host = NWEndpoint.Host(host)
        self.port = NWEndpoint.Port(rawValue: port)!
        self.connection = NWConnection(host: self.host, port: self.port, using: .udp)
    }

    func tryConnect(completion: @escaping (Bool) -> Void) {
        connection.stateUpdateHandler = { [weak self] state in
            switch state {
            case .ready:
                print("Connected to Tello drone")
                self?.receiveResponse(completion: { response in
                    print("Drone response after connect: \(response)")
                    completion(true)
                })
            case .failed(let error):
                print("Connection failed: \(error)")
                completion(false)
            default:
                break
            }
        }
        connection.start(queue: .global())
        sendCommand("command") { response in
            print("Initial command response: \(response)")
        }
    }

    func takeoff(completion: @escaping (String) -> Void) {
        sendCommand("takeoff", completion: completion)
    }

    func land(completion: @escaping (String) -> Void) {
        sendCommand("land", completion: completion)
    }
    
    
    func move(direction: String, distance: Int, completion: @escaping (String) -> Void) {
        sendCommand("\(direction) \(distance)", completion: completion)
    }

    func moveForward(distance: Int, completion: @escaping (String) -> Void) {
        move(direction: "forward", distance: distance, completion: completion)
    }

    func moveBackward(distance: Int, completion: @escaping (String) -> Void) {
        move(direction: "back", distance: distance, completion: completion)
    }

    func setSpeed(speed: Int, completion: @escaping (String) -> Void) {
        sendCommand("speed \(speed)", completion: completion)
    }

    func flip(direction: String, completion: @escaping (String) -> Void) {
        sendCommand("flip \(direction)", completion: completion)
    }

    private func sendCommand(_ command: String, completion: @escaping (String) -> Void) {
        let data = command.data(using: .utf8)!
        connection.send(content: data, completion: .contentProcessed({ [weak self] error in
            if let error = error {
                print("Error sending command: \(error)")
                completion("Error")
                return
            }
            print("Command sent: \(command)")
            self?.receiveResponse(completion: completion)
        }))
    }

    private func receiveResponse(completion: @escaping (String) -> Void) {
        connection.receiveMessage { data, context, isComplete, error in
            if let data = data, let response = String(data: data, encoding: .utf8) {
                print("Received response: \(response)")
                completion(response)
            } else if let error = error {
                print("Error receiving response: \(error)")
                completion("Error")
            }
        }
    }
}
