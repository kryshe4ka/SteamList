//
//  NewsListContentView.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 15.12.21.
//

import Foundation
import UIKit
import SnapKit

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
    let delegate = NewsListTableViewDelegate()
    let filterDelegate = FilterTableViewDelegate()
    var newsListTableView: TableView = {
        let table = TableView()
        table.register(NewsListTableViewCell.self, forCellReuseIdentifier: NewsListTableViewCell.reuseIdentifier)
        return table
    }()
    
    lazy var filterView: UIView = {
        let filterView = UIView()
        filterView.backgroundColor = Colors.gradientTop
        filterView.layer.borderWidth = 1
        filterView.layer.borderColor = Colors.content.cgColor
        return filterView
    }()
    
    lazy var saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = Colors.navBarBackground
        saveButton.tintColor = Colors.content
        saveButton.layer.cornerRadius = 10
        return saveButton
    }()
    lazy var filterTableView: UITableView = {
        let filterTableView = UITableView()
        filterTableView.backgroundColor = .clear
        filterTableView.separatorStyle = .none
        filterTableView.register(FilterTableViewCell.self, forCellReuseIdentifier: FilterTableViewCell.reuseIdentifier)
        return filterTableView
    }()
    
    lazy var topView: UIView = {
        let topView = UIView()
        topView.backgroundColor = .clear
        return topView
    }()
    
    init() {
        super.init(frame: .zero)
        layer.insertSublayer(self.gradientLayer, at: 0)
        newsListTableView.delegate = delegate
        newsListTableView.dataSource = delegate
        addSubview(topView)
        addSubview(newsListTableView)
        filterView.addSubview(saveButton)
        filterTableView.delegate = filterDelegate
        filterTableView.dataSource = filterDelegate
        filterView.addSubview(filterTableView)
        addConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        newsListTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        let saveButtonHeight: CGFloat = 40
        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(saveButtonHeight)
        }
        filterTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(saveButton.snp.top).offset(-10)
        }
    }
    
    func addConstraintsToFilterView() {
        filterView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.bottom.equalToSuperview().offset(-180)
            make.leading.trailing.equalToSuperview().inset(50)
        }
    }
}
