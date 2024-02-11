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
    
    private var answerSoundEffectPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureConstraints()
        configureBindings()
        
        viewModel.load()
    }
}

extension QuizSessionViewController {
    private func navigationToDetails() {
        
    }
}

extension QuizSessionViewController {
    private func playSound(when isCorrect: Bool) {
        let soundFileName = viewModel.getSoundFileName(when: isCorrect)
        guard let path = Bundle.main.path(forResource: soundFileName, ofType: "wav") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        answerSoundEffectPlayer = try? AVAudioPlayer(contentsOf: url)
        answerSoundEffectPlayer?.play()
    }
    
    private func presentResultAlert() {
        let alert = JLPTQuizAlertComposer.makeQuizSessionResultAlert(score: viewModel.currentScore, numberOfQuestions: viewModel.numberOfQuestions) { [weak self] in
            self?.dismiss(animated: true)
        }
        present(alert, animated: true)
    }
}

extension QuizSessionViewController {
    private func configureData() {
        headerView.progress = viewModel.currentProgress
        
        if viewModel.isShowingQuiz {
            headerView.title = viewModel.configureHeaderViewTitle()
            questionLabel.text = viewModel.currentQuiz?.question
            footerView.isHidden = true
        } else if viewModel.isShowingAnswer {
            footerView.isHidden = false
        }
        
        tableView.reloadData()
    }
}

// MARK: - View Config
extension QuizSessionViewController {
    private func configureViews() {
        configureHeaderView()
        configureQuestionLabel()
        configureTableView()
        configureFooterView()
    }
    
    private func configureConstraints() {
        headerView.snp.remakeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide).offset(24)
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
        questionLabel.snp.remakeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(12)
            make.leading.trailing.equalTo(headerView)
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
    
    private func configureBindings() {
        viewModel.quizFlowManager.$currentState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .showingAnswer(_ , let result):
                    self?.playSound(when: result.isCorrect)
                    self?.configureData()
                case .showingQuiz:
                    self?.configureData()
                case .ended:
                    self?.presentResultAlert()
                default:
                    break
                }
            }
            .store(in: &subscriptions)
    }
    
    private func configureHeaderView() {
        navigationItem.largeTitleDisplayMode = .never
        headerView.title = viewModel.configureHeaderViewTitle()
        headerView.didTapClose = { [weak self] in
            self?.viewModel.endCurrentSession()
        }
        view.addSubview(headerView)
    }
    
    private func configureQuestionLabel() {
        questionLabel.font = .systemFont(ofSize: 17)
        questionLabel.textColor = UIColor.label
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .left
        view.addSubview(questionLabel)
    }
    
    private func configureTableView() {
        tableView.register(OptionCell.self, forCellReuseIdentifier: OptionCell.reuseID)
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    private func configureFooterView() {
        footerView.didTapNext = { [weak self] in
            self?.viewModel.goToNextQuestion()
        }
        footerView.didTapMaster = { [weak self] in
            let alert = JLPTQuizAlertComposer.makeMasterQuizConfirmationAlert(with: {
                self?.viewModel.masterCurrentQuestion()
            })
            self?.present(alert, animated: true)
        }
        view.addSubview(footerView)
    }
}

extension QuizSessionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.quizFlowManager.currentState {
        case .showingQuiz(let quiz), .showingAnswer(let quiz, _):
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
        cell.state = viewModel.getOptionCellState(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if viewModel.isShowingQuiz {
            viewModel.didSelectOption(at: indexPath.row)
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
