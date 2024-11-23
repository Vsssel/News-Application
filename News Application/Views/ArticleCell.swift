import UIKit
import SnapKit

class ArticleCell: UITableViewCell {
    static let identifier = "ArticleCell"
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let likeButton = UIButton(type: .system)
    private let articleImageView = UIImageView()
    
    var onLikeButtonTapped: (() -> Void)?
    
    private var isLiked = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(articleImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likeButton)
        
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        articleImageView.layer.cornerRadius = 8
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        
        likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        likeButton.tintColor = .gray
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        articleImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalTo(articleImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(articleImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.leading.equalTo(articleImageView.snp.trailing).offset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configure(with article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        
        if let urlString = article.urlToImage, let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.articleImageView.image = image
                    }
                }
            }
        } else {
            articleImageView.image = UIImage(systemName: "questionmark.circle")
            articleImageView.tintColor = .gray
        }
        
        // Fetch like status from Core Data
        isLiked = CoreDataManager.shared.isArticleLiked(link: article.url!)
        updateLikeButton()
    }
    
    @objc private func likeButtonTapped() {
        isLiked.toggle()
        updateLikeButton()
        onLikeButtonTapped?()
    }
    
    private func updateLikeButton() {
        likeButton.tintColor = isLiked ? .systemGreen : .gray
    }
}
