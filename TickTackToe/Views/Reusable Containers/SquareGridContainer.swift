//
//  TickTackToeViewContainer.swift
//  TickTackToe
//
//  Created by Sami Taha on 7/31/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import Foundation
import UIKit

/// A reusable square grid of `UIViews` that can be configured 
class SquareGridContainer : UIView {
    
    /// Flag on whether to add view constraints
    private var viewsNeedConstains = true
    
    /// Vertical UIStackView which contains the Grid
    private var containingStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = CGFloat(12.0)
        return stackView
    }()
    
    /// - returns: The UIViews which are contained within in the Grid
    func getViewsInGrid() -> [UIView] {
        var views = [UIView]()
        
        for view in containingStackView.arrangedSubviews {
            if let stackView = view as? HorizontalStackView {
                views += stackView.arrangedSubviews
            }
        }
        
        return views
    }
 
    /// - parameter numberOfTotalItems: The total number of UIView types that should be shown in the Grid
    /// - parameter numberPerRow: The total number of items each that should be in each row of the swuare grid
    /// - parameter viewType: The type of view that is being added to the grid
    /// - note: A fatal errror will occur if you try to configuere a non-square grid. For example a 3x3 grid is a square, but a 4x3 grid is not. 
    func configureGridWithViews<T>(numberOfTotalItems : Int, numberPerRow: Int, viewType: T.Type) where T: UIView, T: GridViewConfigurable {
        /// Calculate number of rows required
        let totalRows = calculateRequiredRows(numberOfTotalItems: numberOfTotalItems, numberPerRow: numberPerRow)
        for row in 0..<totalRows {
            let rowStackView = HorizontalStackView()
            containingStackView.addArrangedSubview(rowStackView)
            
            for col in 0..<numberPerRow {
                var view = viewType.init()
                view.row = row
                view.col = col
                view.setContentCompressionResistancePriority(.required, for: .horizontal)
                view.setContentCompressionResistancePriority(.required, for: .vertical)
                view.setContentHuggingPriority(.required, for: .horizontal)
                view.setContentHuggingPriority(.required, for: .vertical)
                rowStackView.addArrangedSubview(view)
            }
        }
        
        addSubview(containingStackView)
    }
    
    func viewFor(row: Int, col: Int) -> UIView? {
        for view in getViewsInGrid() {
            if let gridObject = view as? GridViewConfigurable {
                if gridObject.row == row && gridObject.col == col {
                    return view
                }
            }
        }
        print("Nil was returned")
        return nil
    }
    
    // TODO: Get better at error handling
    private func calculateRequiredRows(numberOfTotalItems: Int, numberPerRow: Int) -> Int {
        if numberOfTotalItems % numberPerRow != 0 {
            fatalError("This is not a square.")
        }
        return numberOfTotalItems / numberPerRow
    }
    
    override func updateConstraints() {
        if viewsNeedConstains {
            viewsNeedConstains = !viewsNeedConstains
            
            let margins = safeAreaLayoutGuide
            containingStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
            containingStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
            containingStackView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
            containingStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        }
        super.updateConstraints()
    }
}
