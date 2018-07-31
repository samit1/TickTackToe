//
//  TickTackToeView.swift
//  TickTackToe
//
//  Created by Sami Taha on 7/31/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import UIKit

protocol GridViewConfigurable  {
    var row: Int {get set}
    var col: Int {get set}
}
enum TickTackToeViewRepresentation {
    case x
    case o
    case none
    
    var stateColorRepresentation : UIColor {
        switch self {
        case .none:
            return UIColor.white
        case .o:
            return UIColor.blue
        case .x:
            return UIColor.orange
        }
    }
}


class TickTackToeView: UIButton, GridViewConfigurable {

    private var viewState = TickTackToeViewRepresentation.none

    var row = 0
    var col = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView(viewRepresentation: .none)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView(viewRepresentation: .none)
    }
    
    func configureView(viewRepresentation: TickTackToeViewRepresentation) {
        viewState = viewRepresentation
        translatesAutoresizingMaskIntoConstraints = false
        print(backgroundColor)
        backgroundColor = viewState.stateColorRepresentation
        print(backgroundColor)
    }
    
    
    


}
