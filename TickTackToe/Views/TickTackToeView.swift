//
//  TickTackToeView.swift
//  TickTackToe
//
//  Created by Sami Taha on 7/31/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import UIKit

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


class TickTackToeView: UIButton {

    private var viewState = TickTackToeViewRepresentation.none

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView(viewRepresentation: .none)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView(viewRepresentation: .none)
    }
    
    func configureView(viewRepresentation: TickTackToeViewRepresentation) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = viewState.stateColorRepresentation
    }
    
    
    


}
