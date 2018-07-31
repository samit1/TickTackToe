//
//  ViewController.swift
//  TickTackToe
//
//  Created by Sami Taha on 7/31/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import UIKit

class TickTackToeViewController: UIViewController {
    
    var gridContainer = SquareGridContainer()
    var game = TickTackToeGame()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        
        gridContainer.configureGridWithViews(numberOfTotalItems: 3, numberPerRow: 3, viewType: TickTackToeView.self)
        addGesturesToViews()
    }
    
    
    private func addGesturesToViews() {
        let views = gridContainer.getViewsInGrid()
        
        for view in views {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(playerDidTapTickTackToe(_:)))
        }
    }
    
    @objc private func playerDidTapTickTackToe(_ recognizer: UITapGestureRecognizer) {
        guard let tappedView = recognizer.view as? TickTackToeView else {
            return
        }
        
        game.selected(by: game.playerUp, atRow: tappedView.row, atCol: tappedView.col)
        
        
        
        
    }
    
    
}

