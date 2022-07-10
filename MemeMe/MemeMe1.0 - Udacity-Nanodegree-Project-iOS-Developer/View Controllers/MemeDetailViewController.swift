//
//  MemeDetailViewController.swift
//  MemeMe1.0 - Udacity-Nanodegree-Project-iOS-Developer
//
//  Created by Matthew Folbigg on 18/01/2021.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet var memeImageView: UIImageView!
    
    var selectedMemeIndex: Int!
    var selectedMeme: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        let object = UIApplication.shared.delegate as! AppDelegate
        selectedMeme = object.memes[selectedMemeIndex]
        
        memeImageView.image = selectedMeme.memeImage
    }
    
    @IBAction func editButtonDidTapped() {
        let destinationController = storyboard?.instantiateViewController(identifier: "MemeViewController") as! MemeViewController
        destinationController.memeIsSavedAtIndex = selectedMemeIndex
        navigationController?.pushViewController(destinationController, animated: true)
    }

}
