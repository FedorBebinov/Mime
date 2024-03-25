//
//  MessageService.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 13.02.2024.
//

import Foundation
import KeychainAccess
import CoreHaptics

class MessageService: NSObject, URLSessionWebSocketDelegate {
    
    let baseUrl = "ws://34.32.59.134:8080"
    let keychain = Keychain(service: "ru.hse.Mime")
    let zoomLength = 7.0
    let longPressLength = 2.5
    
    lazy var engine: CHHapticEngine? = {
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        if hapticCapability.supportsHaptics{
            let engine = try! CHHapticEngine(audioSession: .sharedInstance())
            return engine
        } else {
            return nil
        }
    }()
    
    let session = URLSession(configuration: .default)
    var lastReceivedMessage: Message?
    var lastSentMessage: Message?
    var task: URLSessionWebSocketTask?
    weak var delegate: MessageServiceDelegate?
    
    func connectToRoomId(roomId: String){
        guard let token = keychain["token"] else{
            print("no token")
            return
        }
        var url: URL
        if roomId == "create" {
            url = URL(string: "\(baseUrl)/v1/ws/chat")!
        } else {
            url = URL(string: "\(baseUrl)/v1/ws/chat/\(roomId)")!
        }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        task = session.webSocketTask(with: request)
        task?.delegate = self
        task?.resume()
        receiveMessages()
    }
    
    func disconnect(){
        task?.cancel()
        task = nil
    }
    
    func receiveMessages(){
        task?.receive(completionHandler: { result in
            switch result {
            case .success(let success):
                switch success{
                case .string(let string):
                    print(string)
                    if string.hasPrefix("{") {
                        let decoder = JSONDecoder()
                        do {
                            let message = try decoder.decode(Message.self, from: Data(string.utf8))
                            self.delegate?.didReceiveMessage(message: message)
                            self.lastReceivedMessage = message
                            self.playZoomVibrationIfNeeded()
                            self.playLongPressVibrationIfNeeded()
                            print(message)
                        } catch {
                            print(error)
                        }
                    } else{
                        let components = string.components(separatedBy: " ")
                        if components[0] == "RoomId:"{
                            self.delegate?.didConnectToRoomId(roomId: components[1])
                        } else if components[0] == "There"{
                            self.delegate?.secondUserConnected()
                        } else if string.hasSuffix("joined the room"){
                            self.delegate?.secondUserConnected()
                        } else if string.hasSuffix("left the room"){
                            self.delegate?.secondUserDisconnected()
                        }
                        else if string.hasSuffix("not found!") {
                            self.delegate?.failedConnectToRoom()
                        }
                    }

                case .data(let data):
                    print(data)
                    let decoder = JSONDecoder()
                    do {
                        let message = try decoder.decode(Message.self, from: data)
                        self.delegate?.didReceiveMessage(message: message)
                        print(message)
                    } catch {
                        print(error)
                    }
                @unknown default:
                    fatalError()
                }
                self.receiveMessages()
            case .failure(let failure):
                print(failure)
            }
        })
    }
    
    func sendMessage(message: Message){
        self.lastSentMessage = message
        let encoder = JSONEncoder()
        playZoomVibrationIfNeeded()
        playLongPressVibrationIfNeeded()
        if let json = try? encoder.encode(message) {
            print(String(data: json, encoding: .utf8)!)
            task?.send(.string(String(data: json, encoding: .utf8)!), completionHandler: { error in
                print(error as Any)
            })
        }
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Connected to server")
        ping()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print(closeCode)
        print(reason)
    }
    
    func playZoomVibrationIfNeeded(){
        guard let lastSentMessage, let lastReceivedMessage else{
            return
        }
        if lastReceivedMessage.gesture == .zoom,
           Date.now.timeIntervalSince(lastReceivedMessage.date) <= zoomLength,
           lastSentMessage.gesture == .zoom,
           Date.now.timeIntervalSince(lastSentMessage.date) <= zoomLength {
            playVibration(forResourse: "zoomSound", duration: zoomLength)
        }
    }
    
    func playLongPressVibrationIfNeeded(){
        guard let lastSentMessage, let lastReceivedMessage else{
            return
        }
        if lastReceivedMessage.gesture == .longPress,
           Date.now.timeIntervalSince(lastReceivedMessage.date) <= longPressLength,
           lastSentMessage.gesture == .longPress,
           Date.now.timeIntervalSince(lastSentMessage.date) <= longPressLength {
            playVibration(forResourse: "longPressSound", duration: longPressLength)
        }
    }
    
    func playVibration(forResourse: String, duration: Double) {
        guard let engine = engine else{
            return
        }
        guard let url = Bundle.main.url(forResource: forResourse, withExtension: "mp3") else {
            return
        }
        do{
            let resourceId = try engine.registerAudioResource(url, options: [:])
            
            let pattern = try CHHapticPattern(
                events: [
                    CHHapticEvent(audioResourceID: resourceId, parameters: [], relativeTime: 0),
                    CHHapticEvent(eventType: .hapticContinuous, parameters: [
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.6)
                    ], relativeTime: 0, duration: duration)
                ],
                parameters: [
                    CHHapticDynamicParameter(parameterID: .hapticReleaseTimeControl, value: 0.7, relativeTime: 0)
                ]
            )
            let player = try engine.makePlayer(with: pattern)
            
            try engine.start()
            try player.start(atTime: 0)
        } catch{
            print(error)
        }
    }
    
    func ping() {
        task?.sendPing { error in
        if let error = error {
          print("Error when sending PING \(error)")
        } else {
            print("Web Socket connection is alive")
            DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                self.ping()
            }
        }
      }
    }

}
protocol MessageServiceDelegate: AnyObject {
    func didConnectToRoomId(roomId: String)
    func didReceiveMessage(message: Message)
    func secondUserConnected()
    func secondUserDisconnected()
    func failedConnectToRoom()
}
