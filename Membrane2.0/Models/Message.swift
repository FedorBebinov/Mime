//
//  Message.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 13.02.2024.
//

import Foundation

struct Message: Codable {
    
    let points: [Point]
    let gesture: GestureType
    let date: Date
    
    enum GestureType: String, Codable{
        case touch
        case longPress
        case zoom
        case pan
    }
    
    struct Point: Codable {
        let x: Double
        let y: Double
    }
}
