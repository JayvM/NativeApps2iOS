import UIKit

class ItemsTableViewController: UITableViewController {
    
    //Properties
    
    var dataController: DataController!
    var checklist: Checklist!
  
    //Override functions

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLongPressGesture()
        self.navigationItem.title = checklist.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? checklist.items.count : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        
        cell.set(checklist.items[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            checklist.removeItem(indexPath.row)
            dataController.updateData()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ItemSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemSegue" {
            let itemViewController = segue.destination as! ItemViewController
            
            itemViewController.dataController = dataController
            itemViewController.item = checklist.items[tableView.indexPathForSelectedRow!.row]
        }
        
        if segue.identifier == "ItemEditSegue" {
            let navigationController = segue.destination as? UINavigationController
            let itemEditTableViewController = navigationController?.viewControllers.first as! ItemEditTableViewController
            
            let item = sender as! Item
            
            itemEditTableViewController.dataController = dataController
            itemEditTableViewController.item = item
            itemEditTableViewController.usedItemNames = checklist.items.compactMap({ i in
                return item.name != i.name ? i.name : nil
            })
        }
    }
    
    //Functions
    
    func setupLongPressGesture() {
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        
        longPressGesture.minimumPressDuration = 1.0 //One second
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == .began {
            let touchPoint = longPressGestureRecognizer.location(in: tableView)
            
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                performSegue(withIdentifier: "ItemEditSegue", sender: checklist.items[indexPath.row])
            }
        }
    }
    
    //Actions

    @IBAction func addButtonTapped(_ sender: Any) {
        let alert1 = UIAlertController(title: "Add a new item", message: nil, preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default, handler: { action in
            if let name = alert1.textFields?.first?.text {
                let newIndexPath = IndexPath(row: self.checklist.items.count, section: 0)
                
                for item in self.checklist.items {
                    if item.name == name {
                        let alert2 = UIAlertController(title: "Hold on!", message: "This name is already being used.", preferredStyle: .alert)
                        let tryAgain = UIAlertAction(title: "Try again", style: .default, handler: { action in
                            self.present(alert1, animated: true)
                        })
                        
                        alert2.addAction(tryAgain)
                        self.present(alert2, animated: true)
                        return
                    }
                }
                
                self.checklist.addItem(Item(name: name, imageId: nil, note: nil))
                self.dataController.updateData()
                self.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        })
        
        alert1.addTextField(configurationHandler: { textField in
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: {_ in
                save.isEnabled = !(textField.text?.isEmpty ?? false)
            })
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert1.addAction(cancel)
        alert1.addAction(save)
        save.isEnabled = false
        self.present(alert1, animated: true)
    }
    
    @IBAction func unwindToItemsTableViewController(segue: UIStoryboardSegue) {
    }

}
