import UIKit
import SnapKit

class NewsViewController: UIViewController {
    private let viewModel = NewsViewModel()
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchArticles()
    }
    
    private func setupUI() {
        title = "News"
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                // Show an alert
            }
        }
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.identifier, for: indexPath) as? ArticleCell else {
            return UITableViewCell()
        }
        
        let article = viewModel.articles[indexPath.row]
        cell.configure(with: article)
        
        cell.onLikeButtonTapped = { [weak self] in
            guard let self = self else { return }
            let isLiked = CoreDataManager.shared.isArticleLiked(link: article.url!)
            if isLiked {
                CoreDataManager.shared.unlikeArticle(link: article.url!)
                print("Article unliked: \(article.url!)")
            } else {
                CoreDataManager.shared.likeArticle(link: article.url!)
                print("Article liked: \(article.url!)")
            }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = viewModel.articles[indexPath.row]
        let webVC = WebViewController(url: article.url!)
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let article = viewModel.articles[indexPath.row]
        
        let likeAction = UIContextualAction(style: .normal, title: "Like") { [weak self] action, view, completionHandler in
            guard let self = self else { return }
            
            let isLiked = CoreDataManager.shared.isArticleLiked(link: article.url!)
            if isLiked {
                CoreDataManager.shared.unlikeArticle(link: article.url!)
                print("Article unliked: \(article.url! ?? "Unknown Link")")
            } else {
                CoreDataManager.shared.likeArticle(link: article.url!)
                print("Article liked: \(article.url! ?? "Unknown Link")")
            }
            
            // Reload the row to update the UI
            tableView.reloadRows(at: [indexPath], with: .none)
            completionHandler(true)
        }
        likeAction.backgroundColor = .systemGreen
        likeAction.image = UIImage(systemName: "hand.thumbsup")
        
        let configuration = UISwipeActionsConfiguration(actions: [likeAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

}
