//
//  QuizSessionFooterView.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/9/24.
//

import UIKit

class SessionFooterView: UIView {
    
    private let masteredButton = UIButton()
    private let nextButton = UIButton()
    
    var didTapNext: (() -> Void)? {
        didSet {
//            nextButton.tapHandler = didTapNext
        }
    }
    
    var didTapMaster: (() -> Void)? {
        didSet {
//            masteredButton.tapHandler = didTapMaster
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
        nextButton.setTitle("Continue", for: .normal)
        addSubview(nextButton)
        masteredButton.setTitle("I mastered this question already", for: .normal)
        addSubview(masteredButton)
    }
    private func configureConstraints() {
        nextButton.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(masteredButton)
            make.bottom.equalTo(masteredButton.snp.top).offset(-12)
        }
        masteredButton.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}


