import UIKit

class ItemViewController: UIViewController {
    
    //Properties
    
    var item: Item!
    
    //Override functions

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = item.name
    }

}
