//
//  ViewController.swift
//  TickTackToe
//
//  Created by Sami Taha on 7/31/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import UIKit

class TickTackToeViewController: UIViewController {
    
    var gridContainer : SquareGridContainer = {
        let grid = SquareGridContainer()
        grid.translatesAutoresizingMaskIntoConstraints = false
        return grid
    }()
    
    var game = TickTackToeGame()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        
        gridContainer.configureGridWithViews(numberOfTotalItems: 9, numberPerRow: 3, viewType: TickTackToeView.self)
        addGesturesToViews()
    }
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(gridContainer)
        let margins = view.safeAreaLayoutGuide
        
        gridContainer.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        gridContainer.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        gridContainer.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        gridContainer.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }
    
    private func addGesturesToViews() {
        let views = gridContainer.getViewsInGrid()
        
        for view in views {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(playerDidTapTickTackToe(_:)))
            view.addGestureRecognizer(gesture)
        }
    }
    
    @objc private func playerDidTapTickTackToe(_ recognizer: UITapGestureRecognizer) {
        guard let tappedView = recognizer.view as? TickTackToeView else {
            return
        }
        print("was tapped")
        print("Row is: \(tappedView.row)")
        print("Col is: \(tappedView.col)")
        
        var playerUp: TickTackToePlayer
        switch game.playerUp {
        case .player1Up(let player):
            playerUp = player
        case .player2Up(let player):
            playerUp = player
        }
        
        game.selected(by: playerUp, atRow: tappedView.row, atCol: tappedView.col)
        updateViewForModel()
    }
    
    private func updateViewForModel() {
        
        /// for each model object
        /// go through and update the view
        for (rowIndex, row) in game.tickTackToeGrid.enumerated() {
            for col in row.indices {
                let tickTackToeObj = game.tickTackToeGrid[rowIndex][col] /// model object
                guard let view = gridContainer.viewFor(row: rowIndex, col: col),
                    let tickTackToeView = view as? TickTackToeView  else {return}
                    let occupyingPlayer = tickTackToeObj.occupationState
                    switch occupyingPlayer {
                    case .unoccupied:
                        tickTackToeView.configureView(viewRepresentation: .none)
                    case .occupied(let player):
                        switch player.playerType {
                        case .player1:
                            tickTackToeView.configureView(viewRepresentation: .x)
                        case .player2:
                            tickTackToeView.configureView(viewRepresentation: .o)
                        }
                        
                }
                
                
            }
        }
    }
    
    
}

