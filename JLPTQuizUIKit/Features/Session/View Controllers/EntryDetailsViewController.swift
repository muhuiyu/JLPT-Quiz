//
//  EntryDetailsViewController.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/29/24.
//

import UIKit
import Combine

class EntryDetailsViewController: BaseViewController<EntryDetailsViewModel> {
    
    private let spinnerView = SpinnerView()
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let meaningView = ExplanationItemView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
        configureBindings()
    }
    
}

extension EntryDetailsViewController {
//    private func didTapRelatedItem(for id: String, as type: QuizType) {
//        let viewController = viewModel.makeEntryDetailViewController(for: id, as: type)
//        navigationController?.pushViewController(viewController, animated: true)
//    }
}

extension EntryDetailsViewController {
    private func configureBookmarkButton() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: bookmarkItemImage,
//                                                            style: .done,
//                                                            target: self,
//                                                            action: #selector(didTapBookmark))
    }
    private func configureViews() {
        navigationItem.largeTitleDisplayMode = .never
        
        spinnerView.isHidden = true
        view.addSubview(spinnerView)
        
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.label
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(meaningView)
        
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.alignment = .leading
        containerView.addSubview(stackView)
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
    }
    private func configureContent() {
//        titleLabel.text = viewModel.displayTitleLabelString
//        meaningView.title = viewModel.displayMeaningLabelTitleString
//        meaningView.content = viewModel.displayMeaningLabelContentString
        
//        if viewModel.isGrammar {
//            self.configureGrammarStackView()
//        }
    }
    private func configureGrammarStackView() {
//        guard let entry = viewModel.entry as? Grammar else { return }
//        let formationView = ExplanationItemView()
//        let examplesStackView = ExplanationItemExamplesView()
//        let relatedGrammarsView = RelatedItemListView()
//
//        formationView.title = viewModel.displayGrammarFormationLabelTitleString
//        formationView.content = entry.formation
//        stackView.addArrangedSubview(formationView)
//        
//        examplesStackView.title = viewModel.displayGrammarExamplesStackViewTitleString
//        examplesStackView.content = entry.examples
//        stackView.addArrangedSubview(examplesStackView)
//        
//        if !entry.remark.isEmpty {
//            let remarkView = ExplanationItemView()
//            remarkView.title = viewModel.displayGrammarRemarkViewTitleString
//            remarkView.content = entry.remark
//            stackView.addArrangedSubview(remarkView)
//        }
//        if !entry.relatedGrammar.isEmpty {
//            relatedGrammarsView.title = viewModel.displayGrammarRelatedGrammarsViewTitleString
//            let items = viewModel.getGrammarItems(for: entry.relatedGrammar)
//            relatedGrammarsView.content = items
//            relatedGrammarsView.didTapGrammarItemHandler = { [weak self] config in
//                self?.didTapRelatedItem(for: config.id, as: config.type)
//            }
//            self.stackView.addArrangedSubview(relatedGrammarsView)
//        }
    }
    private func configureConstraints() {
        spinnerView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
        }
        stackView.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        containerView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(scrollView)
            make.bottom.equalToSuperview().inset(16)
        }
        scrollView.snp.remakeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(view.bounds.width)
        }
    }
    private func configureBindings() {
//        viewModel.$entry
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] _ in
//                self?.configureContent()
//            }
//            .store(in: &subscriptions)
//        
//        viewModel.$bookmarkID
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] _ in
//                self?.configureBookmarkButton()
//            }
//            .store(in: &subscriptions)
    }
}
