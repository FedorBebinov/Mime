//
//  AvatarImage.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 10.02.2024.
//

import UIKit

enum AvatarImage: String {
    case door
    case drum
    case shield
    case spinner
    case portal
    
    var image: UIImage {
        switch self {
        case .door:
            return UIImage(named: "door")!
        case .drum:
            return UIImage(named: "drum")!
        case .shield:
            return UIImage(named: "shield")!
        case .spinner:
            return UIImage(named: "spinner")!
        case .portal:
            return UIImage(named: "portal")!
        }
    }
}

