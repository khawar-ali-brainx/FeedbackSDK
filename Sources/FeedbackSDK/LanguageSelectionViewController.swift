//
//  LanguageSelectionViewController.swift
//  
//
//  Created by BrainX 3096 on 17/02/2022.
//

import UIKit

class LanguageSelectionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let blueBg = UIImage(packageResource: Image.blueBg, ofType: .png),
           let smilyBg = UIImage(packageResource: Image.smilyBg, ofType: .png)  {
            let imageView = UIImageView(frame: view.frame)
            imageView.image = blueBg
            imageView.contentMode = .scaleAspectFill
            
            let smilyImageView = UIImageView(frame: CGRect(x: imageView.frame.maxX - 180, y: imageView.frame.maxY - 180, width: 200, height: 200))
            smilyImageView.image = smilyBg
            smilyImageView.contentMode = .scaleAspectFit
            imageView.addSubview(smilyImageView)
            self.view.addSubview(imageView)
        }
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: view.frame.maxX/100*8.5, y: view.frame.maxY/2 - 20, width: 41, height: 41)
        if let image = UIImage(packageResource: Image.cross, ofType: .png) {
            button.setImage(image, for: .normal)
        }
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc
    func buttonAction(sender: UIButton!) {
        FeedbackWindow.shared.isFeedbackViewVisible.toggle()
        self.dismiss(animated: true, completion: nil)
    }
}
