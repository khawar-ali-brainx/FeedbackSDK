//
//  FloatingButtonController.swift
//  
//
//  Created by BrainX 3096 on 17/02/2022.
//

import UIKit

class FloatingButtonController: UIViewController {
    //MARK: - Instance variables

    private let window = FeedbackWindow.shared
    
    private var sockets: [CGPoint] {
        let buttonSize = feedbackButton.bounds.size
        var rect: CGRect!
        if #available(iOS 11.0, *) {
            rect = view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: -2 + buttonSize.width / 2, dy: 4 + buttonSize.height / 2)
        } else {
            rect = view.bounds.insetBy(dx: -2 + buttonSize.width / 2, dy: 4 + buttonSize.height / 2)
        }
        let sockets: [CGPoint] = [
            CGPoint(x: rect.maxX, y: rect.minY),
            CGPoint(x: rect.maxX, y: rect.maxY),
            CGPoint(x: rect.maxX, y: rect.midY)
        ]
        return sockets
    }
    
    let feedbackButton: UIButton = {
        let button = UIButton(type: .custom)
        if let image = UIImage(packageResource: Image.feedback, ofType: .png) {
            button.setImage(image, for: .normal)
        }
        button.sizeToFit()
        button.frame = CGRect(origin: CGPoint(x: (UIScreen.main.bounds.maxX - button.bounds.size.width), y: UIScreen.main.bounds.maxY/2), size: button.bounds.size)
        button.autoresizingMask = []
        return button
    }()
    
    //MARK: - Init Methods

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        window.windowLevel = UIWindow.Level(CGFloat.greatestFiniteMagnitude)
        window.isHidden = false
        window.rootViewController = self
        window.floatingButtonController = self
        window.makeKeyAndVisible()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    //MARK: - Override Methods

    override func loadView() {
        let view = UIView()
        feedbackButton.addTarget(self, action: #selector(floatingButtonWasTapped), for: .touchUpInside)
        view.addSubview(feedbackButton)
        self.view = view
        let panner = UIPanGestureRecognizer(target: self, action: #selector(panDidFire))
        feedbackButton.addGestureRecognizer(panner)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        snapButtonToSocket()
    }
    
    //MARK: - Private Methods
    
    private func snapButtonToSocket() {
        var bestSocket = CGPoint.zero
        var distanceToBestSocket = CGFloat.infinity
        let centre = feedbackButton.center
        for socket in sockets {
            let distance = hypot(centre.x - socket.x, centre.y - socket.y)
            if distance < distanceToBestSocket {
                distanceToBestSocket = distance
                bestSocket = socket
            }
        }
        feedbackButton.center = bestSocket
    }
    
    //MARK: - Action Methods

    @objc
    func keyboardDidShow(note: NSNotification) {
        window.windowLevel = UIWindow.Level(0)
        window.windowLevel = UIWindow.Level(CGFloat.greatestFiniteMagnitude)
    }
    
    @objc
    func floatingButtonWasTapped() {
        FeedbackWindow.shared.isFeedbackViewVisible.toggle()
        let vc = LanguageSelectionViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    @objc
    func panDidFire(panner: UIPanGestureRecognizer) {
        let offset = panner.translation(in: view)
        panner.setTranslation(CGPoint.zero, in: view)
        var centre = feedbackButton.center
        centre.y += offset.y
        feedbackButton.center = centre
        
        if panner.state == .ended || panner.state == .cancelled {
            UIView.animate(withDuration: 0.3) {
                self.snapButtonToSocket()
            }
        }
    }
}
