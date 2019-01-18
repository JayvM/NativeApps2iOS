import UIKit

class ChecklistEditTableViewController: UITableViewController {
    
    //Properties
    
    var dataController: DataController!
    var checklist: Checklist!
    var usedChecklistNames: [String]?

    //Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Edit " + checklist.name
        
        //BUG: Hide footers
        tableView.sectionFooterHeight = 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : checklist.sharedAccounts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 44.0 : 64.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {        
        let width = tableView.frame.size.width
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 64))
        let label = UILabel(frame: CGRect(x: 20, y: 43, width: width, height: 13))
    
        label.textColor = UIColor.gray
        label.font = label.font.withSize(13)
        
        if section == 0 {
            label.text = "NAME"
            view.addSubview(label)
        } else {
            label.text = "SHARED WITH"
            
            let addButton = UIButton(frame: CGRect(x: width - 53, y: 43, width: 33, height: 13))
            
            addButton.setTitle("Add", for: .normal)
            addButton.setTitleColor(self.view.tintColor, for: .normal)
            addButton.setTitleColor(UIColor.gray, for: .highlighted)
            addButton.addTarget(self, action: #selector(self.addButtonTapped), for: .touchUpInside)
            
            view.addSubview(label)
            view.addSubview(addButton)
        }
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! ChecklistNameTableViewCell
            
            cell.set(checklist.name)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SharedAccountsCell", for: indexPath) as! ChecklistSharedAccountsTableViewCell
        
        cell.set(checklist.sharedAccounts[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 ? false : true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == 1 {
            checklist.removeSharedAccount(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "SaveChecklistUnwind" {
            if let names = usedChecklistNames {
                let indexPath = IndexPath(row: 0, section: 0)
                let checklistNameTableViewCell = tableView.cellForRow(at: indexPath) as! ChecklistNameTableViewCell
                
                for name in names {
                    if checklistNameTableViewCell.nameTextField.text == name {
                        let alert = UIAlertController(title: "Hold on!", message: "The checklist name is already being used.", preferredStyle: .alert)
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
        let indexPath = IndexPath(row: 0, section: 0)
        let checklistNameTableViewCell = tableView.cellForRow(at: indexPath) as! ChecklistNameTableViewCell
        
        if let name = checklistNameTableViewCell.nameTextField.text {
            checklist.name = name
        }
    }
    
    //Functions
    
    @objc func addButtonTapped() {
        let alert1 = UIAlertController(title: "Add an account to share with", message: nil, preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Add", style: .default, handler: { action in
            if let email = alert1.textFields?.first?.text {
                let newIndexPath = IndexPath(row: self.checklist.sharedAccounts.count, section: 1)
                
                if let account = self.dataController.getAccount(email) {
                    self.checklist.addSharedAccount(account)
                    self.dataController.updateData()
                    self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                } else {
                    let alert2 = UIAlertController(title: "Hold on!", message: "The E-mail does not exist in our database.", preferredStyle: .alert)
                    let tryAgain = UIAlertAction(title: "Try again", style: .default, handler: { action in
                        self.present(alert1, animated: true)
                    })
                    
                    alert2.addAction(tryAgain)
                    self.present(alert2, animated: true)
                }
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert1.addTextField(configurationHandler: { textField in
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: {_ in
                save.isEnabled = !(textField.text?.isEmpty ?? false)
            })
            
            textField.placeholder = "E-mail"
        })
        
        alert1.addAction(cancel)
        alert1.addAction(save)
        save.isEnabled = false
        self.present(alert1, animated: true)
    }
    
}
