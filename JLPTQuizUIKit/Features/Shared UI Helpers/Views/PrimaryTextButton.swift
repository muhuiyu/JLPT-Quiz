//
//  PrimaryTextButton.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/11/24.
//

import UIKit

class PrimaryTextButton: UIButton {
    
    var primaryAction: (() -> Void)? {
        didSet {
            addAction(UIAction(handler: { [weak self] _ in
                self?.primaryAction?()
            }), for: .touchUpInside)
        }
    }
    
    var buttonColor: UIColor? {
        didSet {
            backgroundColor = buttonColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 17)
        backgroundColor = .primary
        layer.cornerRadius = 12
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
