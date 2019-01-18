import UIKit

class ChecklistEditTableViewController: UITableViewController {
    
    //Properties
    
    var dataController: DataController!
    var checklist: Checklist!

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let name = (tableView.cellForRow(at: [0, 0]) as! ChecklistNameTableViewCell).nameTextField.text {
            checklist.name = name
        }
    }
    
    //Functions
    
    @objc func addButtonTapped() {
        print("hi")
    }
    
}
