//
//  MainViewController.swift
//  iPolice
//
//  Created by Joshua Auriemma on 6/10/17.
//  Copyright © 2017 Joshua Auriemma. All rights reserved.
//

import UIKit
import GlidingCollection

class MainViewController: UIViewController, UIGestureRecognizerDelegate {
    
//    @IBOutlet var shineLabel: SwiftShineLabel!
    @IBOutlet var glidingCollection: GlidingCollection!
    fileprivate var collectionView: UICollectionView!
    fileprivate var images: [[UIImage?]] = []
    fileprivate let items = ["Test 1", "Test 2", "Sirens", "Test 3"]
    let shineLabel = SwiftShineLabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    var tapGesture = UIGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    fileprivate func setupImages() {
        // TODO: Add actual images
        let a = [#imageLiteral(resourceName: "dice"),#imageLiteral(resourceName: "dice"),#imageLiteral(resourceName: "dice")]
        let b = [#imageLiteral(resourceName: "siren"),#imageLiteral(resourceName: "dice")]
        let c = [#imageLiteral(resourceName: "siren")]
        let d = [#imageLiteral(resourceName: "dice")]
        images = [a,b,c,d]
    }
    
    fileprivate func setupCollectionView() {
        glidingCollection.dataSource = self
        let nib = UINib(nibName: "MainViewCollectionCell", bundle: nil)
        collectionView = glidingCollection.collectionView
        collectionView.register(nib, forCellWithReuseIdentifier: "mainCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = glidingCollection.backgroundColor
        
    }
    
}

extension MainViewController: GlidingCollectionDatasource {
    
    func numberOfItems(in collection: GlidingCollection) -> Int {
        return items.count
    }
    
    func glidingCollection(_ collection: GlidingCollection, itemAtIndex index: Int) -> String {
        return "– " + items[index]
    }
    
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = glidingCollection.expandedItemIndex
        return images[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = glidingCollection.expandedItemIndex
        let item = indexPath.item
        print("tapped \(item) in section \(section)")
        let image = images[section][indexPath.row]
        print("and image = \(image)")
//        if image == #imageLiteral(resourceName: "siren") {
//            performSegue(withIdentifier: "sirenSegue", sender: self)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as? MainViewCollectionCell else { return UICollectionViewCell() }
        let section = glidingCollection.expandedItemIndex
        let image = images[section][indexPath.row]
        cell.imageView.image = image
        cell.contentView.clipsToBounds = true
        
        let layer = cell.layer
        let config = GlidingConfig.shared
        layer.shadowOffset = config.cardShadowOffset
        layer.shadowColor = config.cardShadowColor.cgColor
        layer.shadowOpacity = config.cardShadowOpacity
        layer.shadowRadius = config.cardShadowRadius
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale

        return cell
    }
    
}
