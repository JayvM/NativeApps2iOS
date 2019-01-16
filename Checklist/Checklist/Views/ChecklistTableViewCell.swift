import UIKit

class ChecklistTableViewCell: UITableViewCell {
    
    //Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sharedAccountsLabel: UILabel!
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
        var sharedAccounts = ""
    
        if !checklist.sharedAccounts.isEmpty {
            let names = checklist.sharedAccounts.map({ (account: Account) -> String in
                return account.name
            })
            
            sharedAccounts += "Shared with "
            
            for index in 0...names.count - 1 {
                sharedAccounts += names[index]
                sharedAccounts += index < names.count - 2 ? ", " : ""
                sharedAccounts += index < names.count - 1 ? " & " : ""
            }
        } else {
            sharedAccountsLabel.isHidden = true
        }
        
        nameLabel.text = checklist.name
        sharedAccountsLabel.text = sharedAccounts
        itemsCountLabel.text = String(checklist.items.count) + "/" + String(checklist.items.count)
    }
}
