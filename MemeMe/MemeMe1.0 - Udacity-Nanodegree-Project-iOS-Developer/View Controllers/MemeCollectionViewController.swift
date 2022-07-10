//
//  MemeCollectionViewController.swift
//  MemeMe1.0 - Udacity-Nanodegree-Project-iOS-Developer
//
//  Created by Matthew Folbigg on 12/01/2021.
//

import Foundation
import UIKit

class MemeCollectionViewController: UIViewController {
    
    //MARK: IB Outlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    
    //MARK: Variables
    var savedMemes: [Meme] = []
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setCollectionViewFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Gets current saved memes array
        let object = UIApplication.shared.delegate as! AppDelegate
        savedMemes = object.memes
        
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.hidesBottomBarWhenPushed = true
    }
    

    //MARK: UI Setup
    func setUI() {
        view.backgroundColor = .black
        setupNavigationBar()
    }

    func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .systemTeal
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemTeal]
    }
    
}


//MARK: Collection View Setup
extension MemeCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedMemes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let meme = savedMemes[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionCell", for: indexPath) as! MemeCollectionCell
        
        //MARK: Cell UI
        cell.memeImageView.image = meme.memeImage
        
        return cell
    }
    
    //MARK: Flow Layout
    func setCollectionViewFlowLayout() {
        let space:CGFloat = 1
        let screenWidth = collectionView.frame.size.width
        let itemWidth = (screenWidth/3) - (space*2)

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationController = storyboard?.instantiateViewController(identifier: "MemeDetailViewController") as! MemeDetailViewController
        destinationController.selectedMemeIndex = indexPath.row
        destinationController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(destinationController, animated: true)
    }
    
}
