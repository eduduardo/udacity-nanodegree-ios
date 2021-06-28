//
//  MemeViewEditorController.swift
//  MemeMe is a project for Udacity iOS nanodegree :)
//
//  Created by Eduardo Ramos on 12/06/21.
//

import UIKit

class MemeViewEditorController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var toolbarTop: UIToolbar!
    @IBOutlet weak var toolbarBottom: UIToolbar!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.5,
        // the stroke needs to be negative (https://stackoverflow.com/questions/16047901/how-can-i-both-stroke-and-fill-with-nsattributedstring-w-uilabel)
    ]
    
    struct Texts {
        static let AppTitle = "Meme Me"
        static let TopText = "TOP"
        static let BottomText = "BOTTOM"
        
        static let ErrorPickingImage = "Error while picking the image, please try again"
        static let ErrorNoImageSelected = "You must selected one image before share"
        
        static let ShareSuccess = "Meme shared with success!"
        static let ShareError = "Error while sharing meme :/"
    }
    
    // MARK: lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
                
        setupTextField(topText, text: Texts.TopText)
        setupTextField(bottomText, text: Texts.BottomText)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: text setup
    func setupTextField(_ textField: UITextField, text: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.text = text
        
        textField.delegate = self
    }
    
    // MARK: pick image
    func pickAnImage(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(sourceType: .camera)
    }
    
    @IBAction func pickImageFromGallery(_ sender: Any) {
        pickAnImage(sourceType: .photoLibrary)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            
            shareButton.isEnabled = true
        } else {
            showAlert(Texts.ErrorPickingImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: save meme function
    func save() -> Meme {
        let memedImage = generateMemeImage()
        let meme = Meme(topText: self.topText.text!, bottomText: self.bottomText.text!, originalText: imageView.image!, memedImage: memedImage)
        
        return meme
    }
    
    func generateMemeImage() -> UIImage {
        toggleToolbars(false)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toggleToolbars(true)
        
        return memedImage
    }
    
    func toggleToolbars(_ show: Bool) {
        toolbarTop.isHidden = !show
        toolbarBottom.isHidden = !show
    }
    
    @IBAction func shareAction(_ sender: Any) {
        if(imageView.image == nil){
            showAlert(Texts.ErrorNoImageSelected)
            return
        }
        
        let meme = save()
        let shareController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        shareController.completionWithItemsHandler = { _, completed, _, error in
            if completed {
                self.showAlert(Texts.ShareSuccess)
            }
            if (error != nil) {
                self.showAlert(Texts.ShareError)
            }
        }
        present(shareController, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        topText.text = Texts.TopText
        bottomText.text = Texts.BottomText
        imageView.image = nil
    }
    
    // MARK: keyboard functions
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keybordWillShow(_ notification:Notification){
        if bottomText.isFirstResponder { // only trigges when is bottomText
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keybordWillHide(_ notification: Notification){
        if(bottomText.isFirstResponder){
            view.frame.origin.y = 0.0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // if user remove all text, let's replace with initial text
        if(textField.text!.count <= 0){
            textField.text = textField.tag == 1 ? Texts.TopText : Texts.BottomText
        }
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: Texts.AppTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

