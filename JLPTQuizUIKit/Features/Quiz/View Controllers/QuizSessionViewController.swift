//
//  QuizSessionViewController.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/8/24.
//

import UIKit
import JLPTQuiz
import Combine
import AVFoundation

class QuizSessionViewController: BaseViewController<QuizSessionViewModel> {
    private let headerView = SessionHeaderView()
    private let questionLabel = UILabel()
    private let tableView = UITableView()
    private let footerView = SessionFooterView()
    
    private var answerSoundEffect: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureConstraints()
        
        viewModel.load()
    }
}

extension QuizSessionViewController {
    private func navigationToDetails() {
        
    }
}

extension QuizSessionViewController {
    func playSound(when isCorrect: Bool) {
        let soundFileName = viewModel.getSoundFileName(when: isCorrect)
        guard let path = Bundle.main.path(forResource: soundFileName, ofType: nil) else { return }
        let url = URL(fileURLWithPath: path)
        answerSoundEffect = try? AVAudioPlayer(contentsOf: url)
        answerSoundEffect?.play()
    }
}

// MARK: - View Config
extension QuizSessionViewController {
    private func configureViews() {
        navigationItem.largeTitleDisplayMode = .never
        headerView.title = viewModel.configureHeaderViewTitle()
        headerView.didTapClose = { [weak self] in
            self?.viewModel.endCurrentSession()
        }
        view.addSubview(headerView)
        
        questionLabel.font = .systemFont(ofSize: 17)
        questionLabel.textColor = UIColor.label
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .left
        view.addSubview(questionLabel)
        
        tableView.register(OptionCell.self, forCellReuseIdentifier: OptionCell.reuseID)
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        footerView.didTapNext = { [weak self] in
            self?.viewModel.goToNextQuestion()
        }
        footerView.didTapMaster = { [weak self] in
//            guard let self else { return }
//            let alert = self.viewModel.makeMasterQuestionConfirmationAlert()
//            self.present(alert, animated: true)
        }
        footerView.isHidden = true
        view.addSubview(footerView)
    }
    private func configureConstraints() {
        headerView.snp.remakeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide).offset(12)
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
        questionLabel.snp.remakeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(12)
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalTo(view.layoutMarginsGuide)
            make.bottom.equalTo(view.layoutMarginsGuide).inset(120)
        }
        footerView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.layoutMarginsGuide)
        }
    }
    
//    private func configureData(for state: GameState) {
//        headerView.progress = viewModel.currentProgress
//        
//        if state == .questionLoaded {
//            questionLabel.text = viewModel.getQuiz().question
//            footerView.isHidden = true
//        }
//        
//        if state == .answered {
//            footerView.isHidden = false
//        }
//        
//        tableView.reloadData()
//    }
    
    private func configureBindings() {
        viewModel.quizFlowManager.$currentState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .notStarted:
                    break
//                case .questionLoaded, .answered:
//                    self?.configureData(for: state)
//                case .sessionSummaryPresented:
//                    self?.presentSessionSummaryAlert()
                case .finished:
//                case .ended:
                    self?.dismiss(animated: true)
                default:
                    break
                }
            }
            .store(in: &subscriptions)
    }
}

extension QuizSessionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.quizFlowManager.currentState {
        case .showingQuiz(let quiz):
            return quiz.options.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.reuseID, for: indexPath) as? OptionCell else {
            return UITableViewCell()
        }
        cell.option = viewModel.currentQuiz?.options[indexPath.row]
//        cell.state = viewModel.getCellState(for: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if viewModel.isShowingQuiz {
            viewModel.didAnswerQuestion(with: indexPath.row)
        } else if viewModel.isShowingAnswer {
            navigationToDetails()
        }
    }
    
}

#Preview {
    let manager = QuizFlowManager(service: LocalQuizService())
    let viewModel = QuizSessionViewModel(quizFlowManager: manager, config: QuizConfig(numberOfQuestions: 5, level: .n1, type: .grammar))
    return QuizSessionViewController(viewModel: viewModel).embedInNavigationController()
}
