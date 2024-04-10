//
//  MainView.swift
//  AesWebViewSample
//
//  Created by Rebert Matheus Teixeira on 03/04/24.
//

import UIKit

class MainView: UIView {
    
    var aesResultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "result..."
        label.font = .systemFont(ofSize: 24)
        label.textColor = .darkText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("Not Implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupView()
    }
    
    private func setupView() {
        addSubviews(
//            aesResultLabel
        )
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
//            aesResultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
//            aesResultLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

extension MainView: ViewControllerDelegate {
    func updateAesResult(result: String) {
        self.aesResultLabel.text = result
    }
}
