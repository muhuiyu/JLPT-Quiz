//
//  QuizSessionFooterView.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/9/24.
//

import UIKit

class SessionFooterView: UIView {
    
    private let masteredButton = UIButton()
    private let nextButton = PrimaryTextButton()
    
    var didTapNext: (() -> Void)? {
        didSet {
            nextButton.primaryAction = didTapNext
        }
    }
    
    var didTapMaster: (() -> Void)? {
        didSet {
            masteredButton.addAction(UIAction(handler: { [weak self] _ in
                self?.didTapMaster?()
            }), for: .touchUpInside)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View Config
extension SessionFooterView {
    private func configureViews() {
        nextButton.setTitle(Text.QuizSessionViewController.continueButton, for: .normal)
        addSubview(nextButton)
        
        masteredButton.setTitleColor(.primary, for: .normal)
        masteredButton.setTitle(Text.QuizSessionViewController.masterQuestionButton, for: .normal)
        masteredButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        addSubview(masteredButton)
    }
    private func configureConstraints() {
        nextButton.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(masteredButton)
            make.bottom.equalTo(masteredButton.snp.top).offset(-12)
            make.height.equalTo(48)
        }
        masteredButton.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
