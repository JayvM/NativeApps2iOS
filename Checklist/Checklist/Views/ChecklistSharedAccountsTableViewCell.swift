import UIKit

class ChecklistSharedAccountsTableViewCell: UITableViewCell {
    
    //Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    //Override functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Functions
    
    func set(_ account: Account) {
        nameLabel.text = account.name
        emailLabel.text = account.email
    }
}
