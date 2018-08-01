//
//  ViewController.swift
//  TickTackToe
//
//  Created by Sami Taha on 7/31/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import UIKit

class TickTackToeViewController: UIViewController {


    /// Container view for TickTackToe grid
    private var gridContainer : SquareGridContainer = {
        let grid = SquareGridContainer()
        grid.translatesAutoresizingMaskIntoConstraints = false
        return grid
    }()
    
    /// TickTackToe brain and model
    private lazy var game : TickTackToeGame = {
        let game = TickTackToeGame()
        game.matchDelegate = self
        return game
    }()
    
    // MARK: Lifecycle Methods
    
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
    
    /// Adds tap gesture for each view in the `gridContainer`
    private func addGesturesToViews() {
        let views = gridContainer.getViewsInGrid()
        
        for view in views {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(playerDidTapTickTackToe(_:)))
            view.addGestureRecognizer(gesture)
        }
    }
    
    /// Handler method for when a view in the `gridContainer` is tapped
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
    /**
     Updates the view based on the model.
     ## There are 3 different view states that need to be accounted for
     - Player 1 is occupying a space
     - Player 2 is occupying a space
     - The space is unoccupied
     */
    private func updateViewForModel() {
        
        /// Iterate through objects in data model
        for (rowIndex, row) in game.tickTackToeGrid.enumerated() {
            for col in row.indices {
                let tickTackToeObj = game.tickTackToeGrid[rowIndex][col]
                /// Find respective view in gridContainer
                guard let tickTackToeView = getTickTackToeViewFor(row: rowIndex, col: col) else {return}
               
                let occupationState = tickTackToeObj.occupationState
                switch occupationState {
                case .unoccupied:
                    /// The object is unoccupied, update viewRepresentation
                    tickTackToeView.configureView(viewRepresentation: .none)
                case .occupied(let player):
                    switch player.playerType {
                    case .player1:
                        /// The object is occupied by player1, update viewRepresentation
                        tickTackToeView.configureView(viewRepresentation: .x)
                    case .player2:
                        /// The object is occupied by player2, update viewRepresentation
                        tickTackToeView.configureView(viewRepresentation: .o)
                    }
                    
                }
            }
        }
    }
    
    private func animateGridObjectAt(row: Int, col: Int) {
        if let tickTackToeView = getTickTackToeViewFor(row: row, col: col) {
            print("About to animate")
            let propertyAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.3) {
                tickTackToeView.transform = CGAffineTransform(translationX: 3, y: 3)
            }
            
            propertyAnimator.addAnimations({
                tickTackToeView.transform = CGAffineTransform(translationX: 0, y: 0)

            }, delayFactor: 0.2)
            propertyAnimator.startAnimation()
        }
    }
    
    private func getTickTackToeViewFor(row: Int, col: Int) -> TickTackToeView? {
        guard let view = gridContainer.viewFor(row: row, col: col),
            let tickTackToeView = view as? TickTackToeView  else {
                return nil
        }
        
        return tickTackToeView
    }
    
    private func presentResultScreen(with title: String) {
        let destVC = GameResultViewController()
        destVC.titleForResults = title
        present(destVC, animated: true, completion: nil)
    }
    
}


extension TickTackToeViewController : MatchResultDelegate {
    func invalidMoveDidAttemptAt(row: Int, col: Int) {
        print("Invalid move")
        animateGridObjectAt(row: row, col: col)
    }
    
    func matchDidChangeStatus(result: MatchResult) {
        switch result {
        case .noWinnerGameOver:
            presentResultScreen(with: "There was no winner. Start over?")
        case .resultTBD:
            print("TBD")
        case .won(let winningPlayer):
            print(winningPlayer)
            presentResultScreen(with: "\(winningPlayer) is the winner! Play again?")
        }
    }
    
    
    
    
}
