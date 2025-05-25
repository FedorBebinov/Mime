//
//  UIColor + AppColors.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 22.08.2023.
//

import UIKit

extension UIColor{
    static let backgroundColor = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 19/255, green: 19/255, blue: 19/255, alpha: 1)
        }
        return UIColor(red: 236/255, green: 235/255, blue: 235/255, alpha: 1)
    }
    
    static let textColor = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return  UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        }
        return UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1)
    }
    
    static let awardColor = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return  UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        }
        return UIColor(red: 243/255, green: 242/255, blue: 242/255, alpha: 1)
    }
    
    static let buttonColor = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return  UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        }
        return UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 0.8)
    }
    
    static let roomIdButtonTextColor = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return  UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        }
        return UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1)
    }
    
    static let shadowColor = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 19/255, green: 19/255, blue: 19/255, alpha: 0.5)
        }
        return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
    }
    
    static let buttonTextColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    static let borderColor = UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 1)
    static let separatorColor = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1)
    static let paleSeparatorColor = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1)
    static let changeLabelColor = UIColor(red: 129/255, green: 129/255, blue: 129/255, alpha: 1)
    static let avatarBorderColor = UIColor(red: 218/255, green: 216/255, blue: 211/255, alpha: 1)
    static let destructiveRed = UIColor(red: 200/255, green: 74/255, blue: 74/255, alpha: 1)
}
