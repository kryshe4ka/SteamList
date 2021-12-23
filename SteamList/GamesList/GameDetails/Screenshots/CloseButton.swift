//
//  CloseButton.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 17.12.21.
//

import Foundation
import UIKit

final class CloseButton: UIButton {
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.backgroundColor = .clear
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        if let image = UIImage(named: "xmark-2.png") {
            self.setImage(image, for: .normal)
        }
        if let image = UIImage(named: "xmark-3.png") {
            self.setImage(image, for: .highlighted)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
