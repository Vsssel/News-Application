//
//  Controller.swift
//  News Application
//
//  Created by Assel Artykbay on 22.11.2024.
//

import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController {
    private let webView = WKWebView()
    private let actionContainer = UIView()
    private let doneButton = UIButton()
    private let shareButton = UIButton()
    
    private let url: String
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupWebView()
        setupActionButtons()
        loadWebContent()
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(80) // Leaves space for buttons
        }
    }
    
    private func setupActionButtons() {
        actionContainer.backgroundColor = .systemGray6
        view.addSubview(actionContainer)
        actionContainer.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.systemBlue, for: .normal)
        doneButton.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
        actionContainer.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        shareButton.setTitle("Share", for: .normal)
        shareButton.setTitleColor(.systemBlue, for: .normal)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        actionContainer.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    private func loadWebContent() {
        guard let validURL = URL(string: url) else {
            print("Error: Invalid URL \(url)")
            return
        }
        webView.load(URLRequest(url: validURL))
    }
    
    @objc private func didTapDone() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapShare() {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
}
