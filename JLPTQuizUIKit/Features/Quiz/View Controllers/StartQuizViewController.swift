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
    private let startButton = PrimaryTextButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
        configureBindings()
        
        viewModel.setup()
    }
}

// MARK: - View Config
extension StartQuizViewController {
    
    private func configureViews() {
        title = Text.StartQuizViewController.title
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemGroupedBackground
        
        configureTableView()
        configureStartButton()
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
    
    private func configureBindings() {
        viewModel.$quizConfig
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StartQuizConfigCell.self, forCellReuseIdentifier: StartQuizConfigCell.reuseID)
        view.addSubview(tableView)
    }
    
    private func configureStartButton() {
        startButton.setTitle(Text.StartQuizViewController.startButtonTitle, for: .normal)
        startButton.primaryAction = { [weak self] in
            self?.viewModel.didTapStart()
        }
        view.addSubview(startButton)
    }
}

// MARK: - TableView DataSource and Delegate
extension StartQuizViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellConfigs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StartQuizConfigCell.reuseID, for: indexPath) as? StartQuizConfigCell else {
             return UITableViewCell()
        }
        
        let cellConfig = viewModel.cellConfigs[indexPath.row]
        cell.label = cellConfig.label
        cell.value = viewModel.quizConfig.getStringValue(for: cellConfig.type)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        presentActionSheet(for: viewModel.cellConfigs[indexPath.row])
    }
    
    private func presentActionSheet(for cellConfig: StartQuizViewModel.CellConfig) {
        let alert = UIAlertController(title: cellConfig.type.alertTitle, message: nil, preferredStyle: .actionSheet)
        cellConfig.choices.forEach { choice in
            alert.addAction(UIAlertAction(title: choice.wording, style: .default, handler: { _ in
                choice.didSelect()
            }))
        }
        alert.addAction(UIAlertAction(title: Text.Shared.cancel, style: .cancel))
        present(alert, animated: true)
    }
}

#Preview {
    let viewModel = StartQuizViewModel(quizService: LocalQuizService())
    return StartQuizViewController(viewModel: viewModel).embedInNavigationController()
}
