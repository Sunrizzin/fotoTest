//
//  ImageManager.swift
//  PerfectFotos
//
//  Created by Алексей Усанов on 18.07.2018.
//  Copyright © 2018 Алексей Усанов. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

class ImageManager {
    static var instance = ImageManager()
    
    var foto = [String]()
    
    func get(url: URL) {
        Alamofire.request(url).responseString { (response) in
            switch response.result {
            case .success:
                if response.result.value != nil {
                    let xml = SWXMLHash.parse(response.result.value!)
                    self.foto.removeAll()
                    var temp = [String]()
                    for i in 0..<xml["feed"]["entry"].all.count {
                        if self.foto.count < 20 {
                        temp.append(xml["feed"]["entry"][i]["content"].element!.attribute(by: "src")!.text)
                        }
                    }
                    UserDefaults.standard.set(temp, forKey: "foto")
                    self.foto = UserDefaults.standard.array(forKey: "foto") as! [String]
                    NotificationCenter.default.post(name: NSNotification.Name("fotoUpdate"), object: self)
                }
            case .failure(let error):
                print(error.localizedDescription)
                if UserDefaults.standard.array(forKey: "foto") != nil {
                    self.foto = UserDefaults.standard.array(forKey: "foto") as! [String]
                    NotificationCenter.default.post(name: NSNotification.Name("fotoUpdate"), object: self)
                }
            }
        }
    }
    
}
