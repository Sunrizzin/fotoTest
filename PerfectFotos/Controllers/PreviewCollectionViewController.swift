//
//  PreviewCollectionViewController.swift
//  PerfectFotos
//
//  Created by Алексей Усанов on 18.07.2018.
//  Copyright © 2018 Алексей Усанов. All rights reserved.
//

import UIKit
import Kingfisher
import EmptyDataSet_Swift

private let reuseIdentifier = "preview"

class PreviewCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, EmptyDataSetDelegate, EmptyDataSetSource {
    
    let yandex = URL(string: "http://api-fotki.yandex.ru/api/top/")
    var insets = CGFloat()
    var size = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.emptyDataSetSource = self
        self.collectionView?.emptyDataSetDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(PreviewCollectionViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PreviewCollectionViewController.fotoUpdate), name: NSNotification.Name(rawValue: "fotoUpdate"), object: nil)
        ImageManager.instance.get(url: yandex!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func fotoUpdate() {
        collectionView?.reloadData()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageManager.instance.foto.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PreviewCollectionViewCell
        let res = ImageResource(downloadURL: URL(string:ImageManager.instance.foto[indexPath.row])!, cacheKey: ImageManager.instance.foto[indexPath.row])
        cell.foto.kf.setImage(with: res, placeholder: UIImage(named: "wait"), options: nil, progressBlock: nil, completionHandler: nil)
        return cell
    }
    
    @objc func rotated() {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            insets = UIScreen.main.bounds.size.width * 0.04
            size = UIScreen.main.bounds.size.width * 0.20
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            insets = UIScreen.main.bounds.size.width * 0.10
            size = UIScreen.main.bounds.size.width * 0.35
        }
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: insets, left: insets, bottom: 0, right: insets)
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = insets
        layout.minimumLineSpacing = insets
        collectionView!.collectionViewLayout = layout
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "full" {
            if let indexPath = collectionView?.indexPathsForSelectedItems {
                let vc = segue.destination as! FullViewController
                vc.fotoURL = ImageManager.instance.foto[indexPath[0].row]
            }
        }
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        ImageManager.instance.foto.removeAll()
        self.collectionView?.reloadData()
        ImageManager.instance.get(url: yandex!)
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        let emptyView = UIView()
        emptyView.frame = CGRect.init(x: 0, y: (UIScreen.main.bounds.height / 2), width: UIScreen.main.bounds.width, height: 70)
        emptyView.backgroundColor = UIColor.clear
        
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        label.text = "Ой!"
        emptyView.addSubview(label)
        return emptyView
    }
    
}
