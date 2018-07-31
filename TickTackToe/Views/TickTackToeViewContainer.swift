//
//  TickTackToeViewContainer.swift
//  TickTackToe
//
//  Created by Sami Taha on 7/31/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import Foundation
import UIKit
class SquareGridContainer : UIView {
    
    private var stackViews = [HorizontalStackView]()
    private var containingStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    func configureGridWithViews(numberOfTotalItems : Int, numberPerRow: Int, viewType: UIView.Type) {
        stackViews.removeAll()
        
        /// Calculate number of rows required
        var rows = calculateRequiredRows(numberOfTotalItems: numberOfTotalItems, numberPerRow: numberPerRow)
        while rows >= 0 {
            
            var numLeft = numberPerRow
            let rowStackView = HorizontalStackView()
            stackViews.append(rowStackView)
            while numLeft >= 0 {
                
                rowStackView.addArrangedSubview(viewType.init())
                numLeft -= 3
            }
            rows -= 3
        }
    }
    
    
    // TODO: Get better at error handling
    private func calculateRequiredRows(numberOfTotalItems: Int, numberPerRow: Int) -> Int {
        if numberOfTotalItems % numberPerRow != 0 {
            fatalError("This is not a square.")
        }
        return numberOfTotalItems / numberPerRow
    }
    
    
}
