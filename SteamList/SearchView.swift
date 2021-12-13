//
//  SearchView.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 13.12.21.
//

import Foundation
import UIKit

class SearchView: UIView {
    
    let offset = 10.0
    let viewHeight = 40.0
    
    let inputTextField: UITextField = {
        let inputTextField = UITextField(frame: .zero)
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: Colors.searchContent ?? .lightGray])
        inputTextField.textColor = Colors.searchContent
        return inputTextField
    }()
    
    let iconImageView: UIImageView = {
        let iconImageView = UIImageView(image: UIImage(named: "search"))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.tintColor = Colors.searchContent
        return iconImageView
    }()
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Colors.searchBackground
        layer.cornerRadius = 10.0
        addSubview(iconImageView)
        addSubview(inputTextField)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            inputTextField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: offset),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
            self.heightAnchor.constraint(equalToConstant: viewHeight)
        ])
    }
}
