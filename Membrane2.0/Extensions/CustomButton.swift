//
//  CustomButton.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 30.10.2024.
//

import UIKit

class CustomButton: UIButton {
    // Определяем отступы для увеличения области нажатия
    var touchAreaInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Создаем область, увеличенную на отступы
        let largerArea = self.bounds.inset(by: touchAreaInsets)
        // Проверяем, попадает ли точка внутри увеличенной области
        return largerArea.contains(point) ? self : nil
    }
}
