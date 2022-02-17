//
//  FloatingButtonController.swift
//  
//
//  Created by BrainX 3096 on 17/02/2022.
//

import UIKit

private class FloatingButtonWindow: UIWindow {
    var button: UIButton?

    var floatingButtonController: FloatingButtonController?

    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let button = button else { return false }
        let buttonPoint = convert(point, to: button)
        return button.point(inside: buttonPoint, with: event)
    }
}

class FloatingButtonController: UIViewController {
    private(set) var button: UIButton!
    
    private let window = FloatingButtonWindow()
    
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
    
    @objc
    func keyboardDidShow(note: NSNotification) {
        window.windowLevel = UIWindow.Level(0)
        window.windowLevel = UIWindow.Level(CGFloat.greatestFiniteMagnitude)
    }
    
    override func loadView() {
        let view = UIView()
        let button = UIButton(type: .custom)
        if let image = UIImage(packageResource: "feed", ofType: "png") {
            button.setImage(image, for: .normal)
        }
        button.sizeToFit()
        button.frame = CGRect(origin: CGPoint(x: (UIScreen.main.bounds.maxX - button.bounds.size.width), y: UIScreen.main.bounds.maxY/2), size: button.bounds.size)
        button.autoresizingMask = []
        view.addSubview(button)
        self.view = view
        self.button = button
        window.button = button
        let panner = UIPanGestureRecognizer(target: self, action: #selector(panDidFire))
        button.addGestureRecognizer(panner)
    }
    
    @objc
    func panDidFire(panner: UIPanGestureRecognizer) {
        let offset = panner.translation(in: view)
        panner.setTranslation(CGPoint.zero, in: view)
        var center = button.center
        center.y += offset.y
        button.center = center
        
        if panner.state == .ended || panner.state == .cancelled {
            UIView.animate(withDuration: 0.3) {
                self.snapButtonToSocket()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        snapButtonToSocket()
    }
    
    private var sockets: [CGPoint] {
        let buttonSize = button.bounds.size
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
    
    private func snapButtonToSocket() {
        var bestSocket = CGPoint.zero
        var distanceToBestSocket = CGFloat.infinity
        let center = button.center
        for socket in sockets {
            let distance = hypot(center.x - socket.x, center.y - socket.y)
            if distance < distanceToBestSocket {
                distanceToBestSocket = distance
                bestSocket = socket
            }
        }
        button.center = bestSocket
    }
}
