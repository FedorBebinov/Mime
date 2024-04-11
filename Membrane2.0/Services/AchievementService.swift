//
//  AchievementService.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 08.04.2024.
//

import UIKit

class AchievementService {
    static let shared = AchievementService()
    
    var messageAchievement: Achievement = {
        let data = UserDefaults.standard.object(forKey: "messageAchievement") as? Data
        guard let data else{
            return Achievement(unlocked: false, id: "message")
        }
        let decoder = JSONDecoder()
        let achievement = try? decoder.decode(Achievement.self, from: data)
        guard let achievement else{
            return Achievement(unlocked: false, id: "message")
        }
        return achievement
    }()
    
    
    var messageCounter = UserDefaults.standard.integer(forKey: "messageCounter")
    
    func trackSendMessage(){
        messageCounter += 1
        UserDefaults.standard.setValue(messageCounter, forKey: "messageCounter")
        if messageCounter >= 5 {
            messageAchievement.unlocked = true
            save()
        }
    }
    
    func save(){
        let encoder = JSONEncoder()
        let data = try? encoder.encode(messageAchievement)
        UserDefaults.standard.set(data, forKey: "messageAchievement")
    }
}

struct Achievement: Codable {
    var unlocked = false
    let id: String
}
