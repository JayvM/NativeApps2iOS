import UIKit

class ChecklistTableViewCell: UITableViewCell {
    
    //Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accountNamesLabel: UILabel!
    @IBOutlet weak var itemsCountLabel: UILabel!
    
    //Override functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Functions
    
    func set(checklist: Checklist) {
        nameLabel.text = checklist.name
        
        var accounts = ""
        let count = checklist.accounts.count
        
        for index in 0...count - 1 {
            accounts += checklist.accounts[index].name
            
            if index < count - 1 {
                accounts += ", "
            }
        }
        
        accountNamesLabel.text = "Shared with " + accounts
        itemsCountLabel.text = "\(checklist.items.count) / \(checklist.items.count)"
    }
}
