//
//  ViewController.swift
//  TickTackToe
//
//  Created by Sami Taha on 7/31/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import UIKit


/// The controller for the TickTackToe game
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
        
        setTitleForLoad()
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
    
    // MARK: Game states
    
    /// Presents an instance of the `GameResultsViewController`
    private func presentResultScreen(with title: String) {
        let destVC = GameResultViewController()
        destVC.titleForResults = title
        destVC.delegate = self
        present(destVC, animated: true, completion: nil)
    }
    
    /// Begins a new game
    private func beginNewGame() {
        game.newGame()
        updateViewForModel()
    }
    
    /// Handles whether `presentResultScreen` should be called based on the `MatchResult`
    private func showResultScreenIfNeeded(result: MatchResult) {
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
    
    /**
     Responsible for updating the view based on the model.
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
    
    // MARK: Gestures
    
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
        
        game.selected(atRow: tappedView.row, atCol: tappedView.col)
        updateViewForModel()
    }
    
    // MARK: Animation
    
    /// Provides a shake animation for a `gridContainer` row and cell
    private func animateShakingOfGridObjectAt(row: Int, col: Int) {
        if let tickTackToeView = getTickTackToeViewFor(row: row, col: col) {
            let propertyAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.3) {
                tickTackToeView.transform = CGAffineTransform(translationX: 3, y: 3)
            }
            
            propertyAnimator.addAnimations({
                tickTackToeView.transform = CGAffineTransform(translationX: 0, y: 0)

            }, delayFactor: 0.2)
            propertyAnimator.startAnimation()
        }
    }
    
    // MARK: Private
    
    /// Gets the a `TickTackToeView` for a cooresponing `row` and `col`
    private func getTickTackToeViewFor(row: Int, col: Int) -> TickTackToeView? {
        guard let view = gridContainer.viewFor(row: row, col: col),
            let tickTackToeView = view as? TickTackToeView  else {
                return nil
        }
        return tickTackToeView
    }
    
    /// Creates the title for which player is up
    private func createTitleForPlayer(player: TickTackToePlayer) -> String {
        return "\(player.playerType.rawValue) is up!"
    }
    
    /// Sets the navigation title
    private func setNavTitle(to title: String) {
        navigationItem.title = title
    }
    
    /// Sets the navigation title at the first load of the game. This is done because the navigation title is only changed when it is notified by the delegate that it's another player's turn.
    /// To ensure that the title is shown at the first load, this method is added to explicitly set the title
    private func setTitleForLoad() {
        switch game.playerUp {
        case .player1Up(let player):
            setNavTitle(to: createTitleForPlayer(player: player))
        case .player2Up(let player):
            setNavTitle(to: createTitleForPlayer(player: player))
        }
    }
}

// MARK: MatchResultDelegate methods
extension TickTackToeViewController : MatchResultDelegate {
    func userDidAttemptMoveAfterGame(result: MatchResult) {
        showResultScreenIfNeeded(result: result)
    }
    
    func playerUpDidChangeTo(player: TickTackToePlayer) {
        setNavTitle(to: createTitleForPlayer(player: player))
    }
    
    func invalidMoveDidAttemptAt(row: Int, col: Int) {
        animateShakingOfGridObjectAt(row: row, col: col)
    }
    
    func matchDidChangeStatus(result: MatchResult) {
        showResultScreenIfNeeded(result: result)
    }
}

// MARK: GameResultsPopOverDelegate
extension TickTackToeViewController : GameResultsPopOverDelegate {
    func userDidSelectNewGame() {
        beginNewGame()
    }
}
