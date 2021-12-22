//
//  NewsListTableViewDelegate.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 20.12.21.
//

import Foundation
import UIKit

class NewsListTableViewDelegate: NSObject, UITableViewDelegate {
    var controller: NewsListViewController?
    var state: NewsCellState!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = controller else { return }
        let content = AppDataSource.shared.news[indexPath.row].contents
        let newsDetailsViewController = NewsDetailsViewController(content: content ?? "", state: state)
        newsDetailsViewController.navigationItem.title = state.title
        controller.navigationController?.pushViewController(newsDetailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}

extension NewsListTableViewDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(AppDataSource.shared.news.count)
        return AppDataSource.shared.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsListTableViewCell.reuseIdentifier, for: indexPath) as! NewsListTableViewCell
        cell.setupCell()
        if AppDataSource.shared.news.count > indexPath.row {
            let news = AppDataSource.shared.news[indexPath.row]
            self.state = NewsCellState(appName: "\(news.appid ?? 0)", title: news.title ?? "title", author: news.author ?? "some author", date: "\(news.date ?? 0)")
            cell.update(state: state)
        }
        return cell
    }
}
