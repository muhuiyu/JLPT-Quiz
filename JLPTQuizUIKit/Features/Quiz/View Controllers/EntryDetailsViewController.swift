//
//  EntryDetailsViewController.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/29/24.
//

import UIKit
import Combine

class EntryDetailsViewController: BaseViewController<EntryDetailsViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
        configureBindings()
    }
    
}

// MARK: - View Config
extension EntryDetailsViewController {
    private func configureViews() {
        view.backgroundColor = .orange
    }
    private func configureConstraints() {
        
    }
    private func configureBindings() {
        
    }
}
