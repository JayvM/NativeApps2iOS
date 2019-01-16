import UIKit

class ChecklistsTableViewController: UITableViewController {
    
    //Properties
    
    var dataController: DataController!
    var account: Account!

    //Override functions

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? account.checklists.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistCell", for: indexPath) as! ChecklistTableViewCell
        
        cell.set(checklist: account.checklists[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            account.removeChecklist(indexPath.row)
            dataController.updateData()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemsSegue" {
            let itemsTableViewController = segue.destination as! ItemsTableViewController
            
            itemsTableViewController.dataController = dataController
            itemsTableViewController.checklist = account.checklists[tableView.indexPathForSelectedRow!.row]
        }
    }

    //Actions
    
    /*
     USED AS GUIDANCE: How to use an UIAlertController
     SOURCE: https://learnappmaking.com/uialertcontroller-alerts-swift-how-to/
     
     USED AS GUIDANCE: How to add an observer on a textfield in an UIAlertController
     SOURCE: https://gist.github.com/TheCodedSelf/c4f3984dd9fcc015b3ab2f9f60f8ad51
     */
    @IBAction func addButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add a new checklist", message: nil, preferredStyle: .alert)

        let save = UIAlertAction(title: "Save", style: .default, handler: { action in
            if let name = alert.textFields?.first?.text {
                let newIndexPath = IndexPath(row: self.account.checklists.count, section: 0)
                
                self.account.addChecklist(name)
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
