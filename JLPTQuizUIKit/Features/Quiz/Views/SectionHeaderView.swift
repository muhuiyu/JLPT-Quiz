//
//  SectionHeaderView.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/9/24.
//

import UIKit

class SessionHeaderView: UIView {
    private let progressBar = ProgressBarView(frame: .zero, percentage: 0)
    private let titleLabel = UILabel()
    private let dismissButton = UIButton(type: .close)
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var progress: Double = 0 {
        didSet {
            progressBar.updateProgressBar(to: progress)
        }
    }
    
    var didTapClose: (() -> Void)? {
        didSet {
            dismissButton.addAction(UIAction(handler: { [weak self] _ in
                self?.didTapClose?()
            }), for: .touchUpInside)
        }
    }
    
    init(progress: Double = 0) {
        super.init(frame: .zero)
        
        titleLabel.text = "default"
        titleLabel.font = .systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.secondaryLabel
        addSubview(titleLabel)
        addSubview(progressBar)
        addSubview(dismissButton)
        
        progressBar.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.center.equalTo(dismissButton)
            make.leading.equalTo(progressBar).inset(12)
            make.bottom.equalToSuperview()
        }
        
        dismissButton.snp.remakeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(12)
            make.trailing.equalToSuperview()
            make.size.equalTo(24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

