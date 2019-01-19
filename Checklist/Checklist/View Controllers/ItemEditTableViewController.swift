import UIKit

class ItemEditTableViewController: UITableViewController {

    //Properties
    
    var dataController: DataController!
    var item: Item!
    
    //Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Edit " + item.name
    }
}
