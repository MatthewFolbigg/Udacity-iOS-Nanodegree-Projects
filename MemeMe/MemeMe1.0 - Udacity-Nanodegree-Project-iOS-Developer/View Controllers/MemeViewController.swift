//
//  ViewController.swift
//  MemeMe1.0 - Udacity-Nanodegree-Project-iOS-Developer
//
//  Created by Matthew Folbigg on 14/12/2020.
//

import UIKit

//MARK: Meme Creator View Controller
class MemeViewController: UIViewController {
    
    //MARK:Outlets and Variables
    @IBOutlet var memeImageView: UIImageView!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var imageToolbar: UIToolbar!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var textFontButton: UIBarButtonItem!
    @IBOutlet var textSizeButton: UIBarButtonItem!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var memeView: UIView!
    
    //MARK: Variables
    //Meme details are svaed here once the share button is tapped
    var savedMeme: Meme!
    var memeIsSavedAtIndex: Int?
    
    var memeImage: UIImage!
    var isKeyboardShown: Bool!
    var keyboardCoversCurrentTextField: Bool!
    var allTextFields: [UITextField]!
    var textSize: CGFloat!
    
    //Text Style Settings
    var textModifier: CGFloat = 10
    var memeFont: String = "Impact"
    
    //MARK:Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        allTextFields = [topTextField, bottomTextField]
        setDefaultUI()
        topTextField.delegate = self
        bottomTextField.delegate = self
        if let index = memeIsSavedAtIndex {
            loadMeme(index: index)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        isKeyboardShown = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
            
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //Makes sure text size scales to maintain relative size to image.
        setMemeTextFieldStyle(for: allTextFields)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Removes observer for keyboard show/hide notifications
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:ToolBar IB Actions
    @IBAction func cameraButtonDidTapped(_ sender: Any) {
        getImageFrom(source: .camera)
    }
    
    @IBAction func photoLibaryButtonDidTapped(_ sender: Any) {
        getImageFrom(source: .photoLibrary)
    }
    
    //MARK: Reset IB Action
    @IBAction func resetButtonDidTapped() {
        returnAllTextFields()
        setDefaultUI()
        memeFont = "Impact"
        textModifier = 10
        setMemeTextFieldStyle(for: allTextFields)
    }
    
    //MARK: Share IB Action
    @IBAction func shareButtonDidTapped() {
        returnAllTextFields()
        memeImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memeImage!], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            (activity, completed, items, error) in
            if completed {
                self.saveMeme()
            }
        }
        present(activityController, animated: true)
    }
    
    //MARK: Done IB Action
    @IBAction func doneButtonDidTapped() {
        //If an image has been added but the meme has not already been saved, asks the user to decied if the meme should be saved or deleted.
        returnAllTextFields()
        if memeImageView.image != nil {
            let alertController = UIAlertController(title: "Save Changes", message: "Would you like to save changes made to this meme?", preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "Save", style: .default) {_ in
                self.memeImage = self.generateMemedImage()
                self.saveMeme()
                self.navigationController?.popToRootViewController(animated: true)
            }
            let dontSaveAction = UIAlertAction(title: "Don't Save", style: .destructive) {_ in
                self.navigationController?.popToRootViewController(animated: true)
            }
            alertController.addAction(saveAction)
            alertController.addAction(dontSaveAction)
            self.present(alertController, animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    //MARK: Set UI
    func setDefaultUI() {
        //Background Colour
        view.backgroundColor = .black
        memeImageView.backgroundColor = .darkGray
        //Text Field Defaults
        setupTextFields()
        //Image
        setupImageView()
        //Buttons & Bars
        setupShareButton()
        setupCameraButton()
        setupToolBar()
        setupTextFontButton()
        setupTextSizeButton()
    }
    
    //MARK: UI setup methods
    func setupTextFields() {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        setMemeTextFieldStyle(for: allTextFields)
    }
        
    func setupImageView() {
        memeImageView.backgroundColor = .darkGray
        memeImageView.image = nil
        memeImageView.contentMode = .scaleAspectFit
    }
    
    func setupToolBar() {
        imageToolbar.barTintColor = .black
        imageToolbar.tintColor = .systemTeal
    }
    
    func setupShareButton() {
        if memeImageView.image == nil {
            shareButton.isEnabled = false
        } else {
            shareButton.isEnabled = true
        }
    }
    
    func setupCameraButton() {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func setupTextFontButton() {
        let impactMenuItem = UIAction(title: "Impact") {_ in
            self.memeFont = "Impact"
            self.setMemeTextFieldStyle(for: self.allTextFields)
    }
        let helveticaMenuItem = UIAction(title: "Helvetica") {_ in
            self.memeFont = "Helvetica Bold"
            self.setMemeTextFieldStyle(for: self.allTextFields)
    }
        let futuraBoldMenuItem = UIAction(title: "Futura") {_ in
            self.memeFont = "Futura Bold"
            self.setMemeTextFieldStyle(for: self.allTextFields)
    }
        
        let fontMenu = UIMenu(title: "Font", children: [impactMenuItem, helveticaMenuItem, futuraBoldMenuItem])
        textFontButton.menu = fontMenu
    }
    
    func setupTextSizeButton() {
        let smallMenuItem = UIAction(title: "Small") {_ in
            self.textModifier = 14
            self.updateTextSize()
            self.setMemeTextFieldStyle(for: self.allTextFields)
    }
        let mediumMenuItem = UIAction(title: "Medium") {_ in
            self.textModifier = 10
            self.updateTextSize()
            self.setMemeTextFieldStyle(for: self.allTextFields)
    }
        let largeMenuItem = UIAction(title: "Large") {_ in
            self.textModifier = 6
            self.updateTextSize()
            self.setMemeTextFieldStyle(for: self.allTextFields)
    }
        
        let sizeMenu = UIMenu(title: "Text Size", children: [smallMenuItem, mediumMenuItem, largeMenuItem])
        textSizeButton.menu = sizeMenu
    }
}

//MARK: Meme Image Handling
extension MemeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func getImageFrom(source: UIImagePickerController.SourceType) {
        returnAllTextFields()
        let pickerController = UIImagePickerController()
        pickerController.sourceType = source
        pickerController.allowsEditing = true
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            memeImageView.image = image
            memeImageView.backgroundColor = .black
        }
        setupShareButton()
        dismiss(animated: true, completion: nil)
    }
}

//MARK: Meme Text Handling
extension MemeViewController: UITextFieldDelegate {
    
    //Text Field Sytle & Text style
    func setMemeTextFieldStyle(for textFields: [UITextField]) {
        
        updateTextSize()
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .strokeColor: UIColor.black,
            .font: UIFont(name: memeFont, size: textSize)!,
            .strokeWidth:  -5,
        ]

        for field in textFields {
            field.defaultTextAttributes = memeTextAttributes
            field.textAlignment = .center
            field.returnKeyType = .done
            field.autocapitalizationType = .allCharacters
            field.borderStyle = .none
            field.autocorrectionType = .no
        }
    }
    
    //Changes text size to maintain relative size compared to the meme image when roataing device
    func updateTextSize() {
        textSize = memeImageView.frame.height/textModifier
    }
    
    func returnAllTextFields() {
        //Used to prevent loosing current text if a text field is still selected when the share button or camera/photo library button is tapped.
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
    }
    
    //Text Field Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        if textField.tag == 1 {
            keyboardCoversCurrentTextField = true
        } else {
            keyboardCoversCurrentTextField = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Keyboard Nitifications
    //Prevent keyboard from hiding bottom text field
    @objc func keyboardWillShow(notification: NSNotification) {
        if isKeyboardShown == false && keyboardCoversCurrentTextField == true {
            if let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                view.frame.origin.y -= keyboardRect.height
            }
        }
        isKeyboardShown = true
    }
    
    @objc func keyboardWillHide() {
        view.frame.origin.y = 0
        isKeyboardShown = false
    }
    
}

//MARK: Meme Object Generation & Sharing
extension MemeViewController {
    
    func generateMemedImage() -> UIImage {

        let renderer = UIGraphicsImageRenderer(size: memeView.frame.size)
        let memedImage = renderer.image { ctx in
            memeView.drawHierarchy(in: memeView.bounds, afterScreenUpdates: true)
        }
        return memedImage
    }
    
    func saveMeme() {
        savedMeme = Meme(topText: topTextField.text!, bottomeText: bottomTextField.text!, originalImage: memeImageView.image!, memeImage: memeImage)
    
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        if let index = memeIsSavedAtIndex {
            //replaces existing if in edit mode
            appDelegate.memes[index] = savedMeme
        } else {
            appDelegate.memes.append(savedMeme)
            memeIsSavedAtIndex = appDelegate.memes.count - 1 //Prevents duplicate saves when shared multiple times.
        }
    }
    
    func loadMeme(index: Int) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        let meme = appDelegate.memes[index]
        
        topTextField.text = meme.topText
        bottomTextField.text = meme.bottomeText
        memeImageView.image = meme.originalImage
        memeImageView.backgroundColor = .black
        
        setupShareButton()
    }
}
