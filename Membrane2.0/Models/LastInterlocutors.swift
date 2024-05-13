//
//  LastInterlocutors.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 11.04.2024.
//

import UIKit

struct LastInterlocutors: Codable{
    let name: String
    let avatarType: String
    let gradientName: String
    let roomId: String
}

extension UserDefaults {
    var interlocutors: [LastInterlocutors] {
        get {
            guard let data = self.data(forKey: "interlocutors") else {
                return []
            }
            let decoder = JSONDecoder()
            do{
                return try decoder.decode([LastInterlocutors].self, from: data)
            } catch {
                return []
            }
        }
        set {
            let encoder = JSONEncoder()
            do{
                let value = try encoder.encode(newValue)
                self.setValue(value, forKey: "interlocutors")
            } catch {
                print(error)
            }
        }
    }
}
