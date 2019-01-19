import UIKit

class ItemEditTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var noteTextView: UITextView!

    //Properties
    
    var dataController: DataController!
    var item: Item!
    var usedItemNames: [String]?
    
    var image: UIImage?
    
    //Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Edit " + item.name
        setupTapGesture()
        
        nameTextField.text = item.name
        
        if let id = item.imageId {
            imageImageView.image = dataController.getImage(id)
        }
        
        noteTextView.text = item.note
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "SaveItemUnwind" {
            if nameTextField.text?.isEmpty ?? false {
                let alert = UIAlertController(title: "Hold on!", message: "The item name is empty.", preferredStyle: .alert)
                let tryAgain = UIAlertAction(title: "Try again", style: .default, handler: nil)
                
                alert.addAction(tryAgain)
                self.present(alert, animated: true)
                return false
            }
            
            if let names = usedItemNames {
                for name in names {
                    if nameTextField.text == name {
                        let alert = UIAlertController(title: "Hold on!", message: "The item name is already being used.", preferredStyle: .alert)
                        let tryAgain = UIAlertAction(title: "Try again", style: .default, handler: nil)
                        
                        alert.addAction(tryAgain)
                        self.present(alert, animated: true)
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveItemUnwind" else {
            return
        }
            
        item.name = nameTextField.text ?? ""
        
        if let image = self.image {
            if let id = item.imageId {
                dataController.writeImage(id, image)
            } else {
                let id = dataController.createImageId()
                
                item.imageId = id
                dataController.writeImage(id, image)
            }
        }
        
        item.note = noteTextView.text ?? ""
        dataController.updateData()
    }
    
    //Functions
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        
        imageImageView.isUserInteractionEnabled = true
        imageImageView.addGestureRecognizer(tapGesture)
    }
    
    /*
     CODE COPIED: How to implement an image picker controller
     SOURCE: Book - App Development with Swift
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.image = image
            imageImageView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleTapGesture() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Choose an image source", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let camera = UIAlertAction(title: "Camera", style: .default, handler: { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            
            alert.addAction(camera)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibrary = UIAlertAction(title: "Photo library", style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            
            alert.addAction(photoLibrary)
        }
        
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
