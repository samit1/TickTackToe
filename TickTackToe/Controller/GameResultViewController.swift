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
    
    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    private lazy var newGameButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("New Game", for: .normal)
        btn.backgroundColor = UIColor.blue
        let gesture = UITapGestureRecognizer(target: self, action: #selector(newGamePressed))
        btn.addGestureRecognizer(gesture)
        return btn
    }()
    
    private lazy var dismissButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Nah", for: .normal)
        btn.backgroundColor = UIColor.orange
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissButtonPressed))
        btn.addGestureRecognizer(gesture)
        return btn
    }()
    
    private var vStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    weak var delegate : GameResultsPopOverDelegate?
    
    var titleForResults: String! {
        didSet {
            if let txt = titleForResults {
                titleLabel.text = txt
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    @objc private func newGamePressed() {
        delegate?.userDidSelectNewGame()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismissButtonPressed() {
        dismiss(animated: true, completion: nil)
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
    
    
}
