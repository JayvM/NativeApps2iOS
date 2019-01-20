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
    
    func set(_ checklist: Checklist) {
        var sharedAccounts = ""
    
        if !checklist.sharedAccounts.isEmpty {
            let names = checklist.sharedAccounts.map({ (account: Account) -> String in
                return account.name
            })
            
            sharedAccounts += "Shared with "
            
            for index in 0...names.count - 1 {
                sharedAccounts += names[index]
                sharedAccounts += index < names.count - 2 ? ", " : ""
                sharedAccounts += index == names.count - 2 ? " & " : ""
            }
        } else {
            sharedAccountsLabel.isHidden = true
        }
        
        nameLabel.text = checklist.name
        sharedAccountsLabel.text = sharedAccounts
        
        var checked = 0
        
        for item in checklist.items {
            if item.checked {
                checked += 1
            }
        }
        
        itemsCountLabel.text = String(checked) + "/" + String(checklist.items.count)
    }
    
    func setSharedChecklist(_ mainAccount: Account, _ account: String, _ checklist: Checklist) {
        var sharedAccountsText = ""
        let sharedAccounts = checklist.sharedAccounts
        
        sharedAccountsText += "Shared with " + account
    
        for index in 0...sharedAccounts.count - 1 {
            if sharedAccounts[index].name != mainAccount.name {
                sharedAccountsText += index < sharedAccounts.count - 1 ? ", " : ""
                sharedAccountsText += index == sharedAccounts.count - 1 ? " & " : ""
                sharedAccountsText += sharedAccounts[index].name
            }
        }
        
        nameLabel.text = checklist.name
        sharedAccountsLabel.text = sharedAccountsText
        
        var checked = 0
        
        for item in checklist.items {
            if item.checked {
                checked += 1
            }
        }
        
        itemsCountLabel.text = String(checked) + "/" + String(checklist.items.count)
    }
}
