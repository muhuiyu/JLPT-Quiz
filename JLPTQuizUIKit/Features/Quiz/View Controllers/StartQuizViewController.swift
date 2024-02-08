//
//  StartQuizViewController.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/8/24.
//

import UIKit
import JLPTQuiz

class StartQuizViewController: BaseViewController<StartQuizViewModel> {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
    }
}

// MARK: - View Config
extension StartQuizViewController {
    
    private func configureViews() {
        title = Text.startQuizViewController.title
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemGroupedBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StartQuizConfigCell.self, forCellReuseIdentifier: StartQuizConfigCell.reuseID)
        view.addSubview(tableView)
        
        startButton.setTitle(Text.startQuizViewController.startButtonTitle, for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        startButton.backgroundColor = .systemBlue
        startButton.layer.cornerRadius = 12
        view.addSubview(startButton)
    }
    
    private func configureConstraints() {
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide).inset(12)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(startButton.snp.top)
        }
        startButton.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(48)
        }
    }
    
}

// MARK: - TableView DataSource and Delegate
extension StartQuizViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StartQuizConfigCell.reuseID, for: indexPath) as? StartQuizConfigCell else {
             return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            cell.label = Text.startQuizViewController.numberOfQuestions
            cell.value = String(viewModel.config.numberOfQuestions)
        case 1:
            cell.label = Text.startQuizViewController.level
            cell.value = viewModel.config.level.toText
        case 2:
            cell.label = Text.startQuizViewController.type
            cell.value = viewModel.config.type.toText
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        print(indexPath)
    }
    
}

#Preview {
    let viewModel = StartQuizViewModel(coordinator: nil, quizService: LocalQuizService())
    return StartQuizViewController(viewModel: viewModel).embedInNavigationController()
}
