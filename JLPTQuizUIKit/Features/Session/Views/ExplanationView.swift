//
//  ExplanationView.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/29/24.
//

import UIKit

class ExplanationItemView: UIView {
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    
    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    var content: String? {
        get { return contentLabel.text }
        set { contentLabel.text = newValue }
    }
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExplanationItemView {
    private func configureViews() {
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = UIColor.label
        stackView.addArrangedSubview(titleLabel)
        contentLabel.font = .systemFont(ofSize: 17)
        contentLabel.textColor = UIColor.label
        contentLabel.numberOfLines = 0
        stackView.addArrangedSubview(contentLabel)
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        addSubview(stackView)
    }
    
    private func configureConstraints() {
        stackView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

