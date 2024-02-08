//
//  StartQuizConfigCell.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/8/24.
//

import UIKit

class StartQuizConfigCell: TableViewCell {
    
    private let labelLabel = UILabel()
    private let valueLabel = UILabel()
    
    var label: String? {
        didSet {
            labelLabel.text = label
        }
    }
    
    var value: String? {
        didSet {
            valueLabel.text = value
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        configureConstraints()
    }
}

// MARK: - View Config
extension StartQuizConfigCell {
    
    private func configureViews() {
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(labelLabel)
        
        valueLabel.textColor = .secondaryLabel
        valueLabel.textAlignment = .right
        contentView.addSubview(valueLabel)
    }
    
    private func configureConstraints() {
        labelLabel.snp.remakeConstraints { make in
            make.leading.top.bottom.equalTo(contentView.layoutMarginsGuide)
        }
        valueLabel.snp.remakeConstraints { make in
            make.leading.equalTo(labelLabel.snp.trailing)
            make.top.bottom.equalTo(labelLabel)
            make.trailing.equalTo(contentView.layoutMarginsGuide)
        }
    }
    
}

