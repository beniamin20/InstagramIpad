//
//  EmptyDetailViewcontroller.swift
//  SplitViewControllerTutorial
//
//  Created by james rochabrun on 3/29/20.
//  Copyright © 2020 james rochabrun. All rights reserved.
//

import UIKit

final class EmptyDetailViewcontroller: ViewController {
    
    let imageLogoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "instagramLogo")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageLogoView)
        imageLogoView.centerInSuperview(size: .init(width: 120.0, height: 120.0))
    }
}
