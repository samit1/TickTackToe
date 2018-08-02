//
//  GameResultViewController.swift
//  TickTackToe
//
//  Created by Sami Taha on 8/1/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import UIKit

protocol GameResultsPopOverDelegate : class {
    /// Called when the user asked for a new game 
    func userDidSelectNewGame()
}

class GameResultViewController: UIViewController {
    
    /// The title that is shown on screen
    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    /// The new game button
    private lazy var newGameButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("New Game", for: .normal)
        btn.backgroundColor = UIColor.blue
        btn.addTarget(self, action: #selector(newGamePressed), for: .touchUpInside)
        return btn
    }()
    
    /// The dismiss button
    private lazy var dismissButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Nah", for: .normal)
        btn.backgroundColor = UIColor.orange
        btn.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        return btn
    }()
    
    /// The containing vertical `UIStackView`
    private var vStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    /// The delegate responsible for managing what the user does after ViewController is presented
    weak var delegate : GameResultsPopOverDelegate?
    
    /// The text representation for the title that should be shown on screen
    var titleForResults: String! {
        didSet {
            if let txt = titleForResults {
                titleLabel.text = txt
            }
        }
    }
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }

    override func loadView() {
        super.loadView()
        
        /* Add subviews */
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(newGameButton)
        vStackView.addArrangedSubview(dismissButton)
        view.addSubview(vStackView)
    
        /* Add compression and hugging priorities */
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    
        let margins = view.safeAreaLayoutGuide
        
        vStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        vStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        vStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        vStackView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
    }
    
    
    /// MARK: Gesture handlers
    
    /// Dismisses the screen and notifies the delegate the user requested for a new game
    @objc private func newGamePressed() {
        delegate?.userDidSelectNewGame()
        dismiss(animated: true, completion: nil)
    }
    
    /// Dismisses the screen
    @objc private func dismissButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
