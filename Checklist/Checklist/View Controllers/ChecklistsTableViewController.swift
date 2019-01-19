import UIKit

class ChecklistsTableViewController: UITableViewController {
    
    //Properties
    
    var dataController: DataController!
    var account: Account!
    
    var selectedRow: IndexPath?

    //Override functions

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLongPressGesture()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ItemsSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemsSegue" {
            let itemsTableViewController = segue.destination as! ItemsTableViewController
            
            itemsTableViewController.dataController = dataController
            itemsTableViewController.checklist = account.checklists[tableView.indexPathForSelectedRow!.row]
        }
        
        if segue.identifier == "ChecklistEditSegue" {
            if let checklist = sender as? Checklist {
                let navigationController = segue.destination as? UINavigationController
                let checklistEditTableViewController = navigationController?.viewControllers.first as! ChecklistEditTableViewController
                
                checklistEditTableViewController.dataController = dataController
                checklistEditTableViewController.checklist = checklist.copy()
                checklistEditTableViewController.usedChecklistNames = account.checklists.compactMap({ c in
                    return checklist.name != c.name ? c.name : nil
                })
            }
        }
    }
    
    //Functions
    
    /*
     CODE COPIED: How to detect a long press gesture in a table view cell
     SOURCE: https://stackoverflow.com/questions/30839275/how-to-select-a-table-row-during-a-long-press-in-swift
     */
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
                selectedRow = indexPath
                performSegue(withIdentifier: "ChecklistEditSegue", sender: account.checklists[indexPath.row])
            }
        }
    }

    //Actions
    
    /*
     USED AS GUIDANCE: How to use an UIAlertController
     SOURCE: https://learnappmaking.com/uialertcontroller-alerts-swift-how-to/
     
     CODE COPIED: How to add an observer on a textfield in an UIAlertController
     SOURCE: https://gist.github.com/TheCodedSelf/c4f3984dd9fcc015b3ab2f9f60f8ad51
     */
    @IBAction func addButtonTapped(_ sender: Any) {
        let alert1 = UIAlertController(title: "Add a new checklist", message: nil, preferredStyle: .alert)

        let save = UIAlertAction(title: "Save", style: .default, handler: { action in
            if let name = alert1.textFields?.first?.text {
                let newIndexPath = IndexPath(row: self.account.checklists.count, section: 0)
                
                for c in self.account.checklists {
                    if c.name == name {
                        let alert2 = UIAlertController(title: "Hold on!", message: "This name is already being used.", preferredStyle: .alert)
                        let tryAgain = UIAlertAction(title: "Try again", style: .default, handler: { action in
                            self.present(alert1, animated: true)
                        })
                        
                        alert2.addAction(tryAgain)
                        self.present(alert2, animated: true)
                        return
                    }
                }
                
                self.account.addChecklist(Checklist(name: name, items: nil, sharedAccounts: nil))
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
    
    @IBAction func unwindToChecklistsTableViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveChecklistUnwind" else {
            return
        }
        
        let checklistEditTableViewController = segue.source as! ChecklistEditTableViewController
        
        if let selected = selectedRow {
            account.checklists[selected.row] = checklistEditTableViewController.checklist
            dataController.updateData()
            tableView.reloadRows(at: [selected], with: .none)
        }
    }
    
}
