//
//  OptionCell.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/9/24.
//

import UIKit
import JLPTQuiz

class OptionCell: UITableViewCell {
    
    static let reuseID = NSStringFromClass(OptionCell.self)
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let buttonLabel = UILabel()
    
    var option: QuizOptionEntry? {
        didSet {
            titleLabel.text = option?.wording
        }
    }
    
    var state: State = .unselected {
        didSet {
            reconfigureViews(for: state)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK: - View Config
extension OptionCell {
    
    enum State {
        case unanswered
        case unselected
        case correctAnswer
        case selectedWrongly
        
        var canShowLinkedEntry: Bool {
            return self != .unanswered
        }
    }
    
    private func configureViews() {
        titleLabel.textColor = UIColor.label
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        containerView.addSubview(titleLabel)
        
        buttonLabel.isUserInteractionEnabled = true
        buttonLabel.font = .systemFont(ofSize: 12)
        buttonLabel.textColor = UIColor.label
        buttonLabel.text = Text.QuizSessionViewController.viewMoreButton
        buttonLabel.isHidden = true
        containerView.addSubview(buttonLabel)
        
        containerView.layer.cornerRadius = 12
        containerView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(containerView)
        
        selectionStyle = .none
    }
    
    private var shouldHideButtonLabel: Bool {
        guard let option else { return false }
        return !state.canShowLinkedEntry || option.linkedEntryID.isEmpty
    }
    
    private func reconfigureViews(for state: State) {
        switch state {
        case .correctAnswer:
            containerView.backgroundColor = .QuizSession.correct
        case .selectedWrongly:
            containerView.backgroundColor = .QuizSession.wrong
        default:
            containerView.backgroundColor = .secondarySystemBackground
        }
        buttonLabel.isHidden = shouldHideButtonLabel
    }
    
    private func configureConstraints() {
        titleLabel.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(18)
            make.trailing.equalTo(buttonLabel.snp.leading).offset(-12)
        }
        buttonLabel.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().inset(18)
            make.centerY.equalTo(titleLabel)
        }
        
        buttonLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        containerView.snp.remakeConstraints { make in
            make.top.bottom.equalTo(contentView.layoutMarginsGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
}

