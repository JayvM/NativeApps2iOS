import UIKit

class ItemsTableViewController: UITableViewController {
    
    //Properties
    
    var dataController: DataController!
    var checklist: Checklist!
  
    //Override functions

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = checklist.name
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
    
    //Actions

    @IBAction func addButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add a new item", message: nil, preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default, handler: { action in
            if let name = alert.textFields?.first?.text {
                let newIndexPath = IndexPath(row: self.checklist.items.count, section: 0)
                
                self.checklist.addItem(Item(name: name))
                self.dataController.updateData()
                self.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        })
        
        alert.addTextField(configurationHandler: { textField in
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: {_ in
                save.isEnabled = !(textField.text?.isEmpty ?? false)
            })
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(save)
        save.isEnabled = false
        self.present(alert, animated: true)
    }

}
