//
//  FullViewController.swift
//  PerfectFotos
//
//  Created by Алексей Усанов on 18.07.2018.
//  Copyright © 2018 Алексей Усанов. All rights reserved.
//

import UIKit
import Kingfisher

class FullViewController: UIViewController {
    
    var fotoURL = String()
    
    @IBOutlet weak var foto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let img = ImageResource(downloadURL: URL(string: fotoURL)!, cacheKey: fotoURL)
        foto.kf.setImage(with: img, placeholder: UIImage(named: "wait"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
