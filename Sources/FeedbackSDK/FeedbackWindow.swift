//
//  File.swift
//  
//
//  Created by BrainX 3096 on 18/02/2022.
//

import UIKit

class FeedbackWindow: UIWindow {
    //MARK: - Instance variables
    
    var isFeedbackViewVisible: Bool = false {
        didSet {
            floatingButtonController?.feedbackButton.isHidden = isFeedbackViewVisible
        }
    }
    
    var floatingButtonController: FloatingButtonController?
    
    static let shared = FeedbackWindow()
    
    //MARK: - Init Methods

    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Override Methods

    internal override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard FeedbackWindow.shared.isFeedbackViewVisible == false else { return true }
        guard let button = floatingButtonController?.feedbackButton else { return false }
        let buttonPoint = convert(point, to: button)
        return button.point(inside: buttonPoint, with: event)
    }
}
