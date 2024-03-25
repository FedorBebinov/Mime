//
//  Gradient.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 31.01.2024.
//

import UIKit

struct Gradient {
    let name: String
    let colors: [UIColor]
}

let gradients = [Gradient(name: "pinkWhite", colors: [UIColor(red: 255/255, green: 154/255, blue: 158/255, alpha: 1), UIColor(red: 250/255, green: 208/255, blue: 196/255, alpha: 1), UIColor(red: 250/255, green: 208/255, blue: 196/255, alpha: 1)]), Gradient(name: "grayWhite", colors: [UIColor(red: 178/255, green: 204/255, blue: 192/255, alpha: 1), UIColor(red: 139/255, green: 117/255, blue: 134/255, alpha: 1)]), Gradient(name: "pinkOrange", colors: [UIColor(red: 237/255, green: 110/255, blue: 160/255, alpha: 1), UIColor(red: 236/255, green: 140/255, blue: 105/255, alpha: 1)]), Gradient(name: "yellowOrange", colors: [UIColor(red: 246/255, green: 211/255, blue: 101/255, alpha: 1), UIColor(red: 253/255, green: 160/255, blue: 133/255, alpha: 1)]), Gradient(name: "purplePink", colors: [UIColor(red: 255/255, green: 152/255, blue: 158/255, alpha: 1), UIColor(red: 79/255, green: 96/255, blue: 255/255, alpha: 1)])]
