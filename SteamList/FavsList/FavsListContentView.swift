//
//  FavsListContentView.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 13.12.21.
//

import Foundation
import UIKit
import SnapKit

class FavsListContentView: UIView {
    
    let searchView = SearchView()
    var delegate = FavsListTableViewDelegate()
    
    private var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            Colors.gradientTop.cgColor,
            Colors.gradientBottom.cgColor
        ]
        gradient.locations = [0.5, 1];
        return gradient
    }()
    
    let favsListTableView: TableView = {
        let table = TableView()
        table.register(FavsListTtableViewCell.self, forCellReuseIdentifier: FavsListTtableViewCell.reuseIdentifier)
        return table
    }()
    
    init() {
        super.init(frame: .zero)
        favsListTableView.delegate = delegate
        favsListTableView.dataSource = delegate
        addSubview(searchView)
        addSubview(favsListTableView)
        addConstraints()
        layer.insertSublayer(self.gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints() {
        searchView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        favsListTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
        }
    }
}
