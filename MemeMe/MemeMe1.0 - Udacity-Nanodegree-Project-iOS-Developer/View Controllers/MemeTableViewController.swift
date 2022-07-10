//
//  File.swift
//  MemeMe1.0 - Udacity-Nanodegree-Project-iOS-Developer
//
//  Created by Matthew Folbigg on 11/01/2021.
//

import Foundation
import UIKit

class memeTableViewController: UIViewController {
    
    //MARK: IB Outlets
    @IBOutlet var tableView: UITableView!
    
    //MARK: Variables
    var savedMemes: [Meme] = []
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Gets current saved memes array
        let object = UIApplication.shared.delegate as! AppDelegate
        savedMemes = object.memes
        
        tableView.reloadData()
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


//MARK: Table View Setup
extension memeTableViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedMemes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell") as! MemeTableCell
        let meme = savedMemes[indexPath.row]
        
        //MARK: Cell UI
        cell.memeImageView.image = meme.memeImage
        cell.topMemeLabel.text = meme.topText
        cell.bottomMemeLabel.text = meme.bottomeText
        
        cell.memeImageView.layer.cornerRadius = 10
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationController = storyboard?.instantiateViewController(identifier: "MemeDetailViewController") as! MemeDetailViewController
        destinationController.selectedMemeIndex = indexPath.row
        destinationController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(destinationController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = UIApplication.shared.delegate as! AppDelegate
            object.memes.remove(at: indexPath.row)
            savedMemes = object.memes
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
