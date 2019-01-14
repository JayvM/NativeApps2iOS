import UIKit

class ChecklistsTableViewController: UITableViewController {
    
    //Properties
    
    var dataController: DataController!
    
    //Override functions

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? dataController.currentAccount.checklists.count : 0
    }

    /*
     USED AS GUIDANCE
     How to use the map function
     https://useyourloaf.com/blog/swift-guide-to-map-filter-reduce/
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistCell", for: indexPath) as! ChecklistTableViewCell
        
        let names = dataController.currentAccount.checklists[indexPath.row].accounts.map({(id: Int) -> String? in
            return dataController.getAccount(id)?.name
        })
        
        cell.set(checklist: dataController.currentAccount.checklists[indexPath.row], names: names)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataController.currentAccount.checklists.remove(at: indexPath.row)
            dataController.updateAccount(dataController.currentAccount)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
