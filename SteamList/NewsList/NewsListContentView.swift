//
//  NewsListContentView.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 15.12.21.
//

import Foundation
import UIKit

class NewsListContentView: UIView {
    
    private var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            Colors.gradientTop.cgColor,
            Colors.gradientBottom.cgColor
        ]
        gradient.locations = [0.5, 1];
        return gradient
    }()
    
    init() {
        super.init(frame: .zero)
        layer.insertSublayer(self.gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
