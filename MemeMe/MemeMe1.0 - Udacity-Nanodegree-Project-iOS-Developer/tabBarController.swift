//
//  tabBarController.swift
//  MemeMe1.0 - Udacity-Nanodegree-Project-iOS-Developer
//
//  Created by Matthew Folbigg on 11/01/2021.
//

import Foundation
import UIKit

class tabBarController: UITabBarController {
 
//    //MARK: FOR TESTING
//    let meme1 = Meme(topText: "Top Test", bottomeText: "Bot Test", originalImage: UIImage(systemName: "trash")!, memeImage: UIImage(systemName: "trash")!)
//    let meme2 = Meme(topText: "Top Test", bottomeText: "Bot Test", originalImage: UIImage(systemName: "folder")!, memeImage: UIImage(systemName: "folder")!)
//    //MARK: END OF TESTING
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .black
        tabBar.tintColor = .systemTeal
        
//        //MARK: FOR TESTING
//        let object = UIApplication.shared.delegate as! AppDelegate
//        object.memes = [meme1, meme2]
//        //MARK: END OF TESTING
    }
}
