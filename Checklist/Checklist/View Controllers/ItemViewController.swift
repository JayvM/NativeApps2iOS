import UIKit

class ItemViewController: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var noteTextView: UITextView!
    
    //Properties
    
    var dataController: DataController!
    var item: Item!
    
    //Override functions

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = item.name
        
        if let id = item.imageId {
            imageImageView.image = dataController.getImage(id)
        }
        
        noteTextView.text = item.note
    }

}
