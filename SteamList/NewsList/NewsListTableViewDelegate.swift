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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = controller else { return }
        let news = AppDataSource.shared.news[indexPath.row]
        let state = getNewsCellStateFrom(news: news)
        let content = news.contents
        let newsDetailsViewController = NewsDetailsViewController(content: content ?? "", state: state)
        newsDetailsViewController.navigationItem.title = state.title
        controller.navigationController?.pushViewController(newsDetailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.newsTableHeightForRow
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
            let state = getNewsCellStateFrom(news: news)
            cell.update(state: state)
        }
        return cell
    }
    
    private func getNewsCellStateFrom(news: Newsitem) -> NewsCellState {
        let date = "\(news.date ?? 0)".toDateFormat
        let name = AppDataSource.shared.apps.first { app in
            app.appid == news.appid
        }?.name
        let state = NewsCellState(appName: name ?? "Unknown app", title: news.title ?? "Unknown title", author: news.author ?? "Unknown author", date: date)
        return state
    }
}
