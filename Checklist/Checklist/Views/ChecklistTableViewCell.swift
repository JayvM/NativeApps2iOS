import UIKit

class ChecklistTableViewCell: UITableViewCell {
    
    //Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sharedWithLabel: UILabel!
    @IBOutlet weak var itemsCountLabel: UILabel!
    
    //Override functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Functions
    
    func set(checklist: Checklist, names: [String?]) {
        var sharedWith = ""
        
        if !names.isEmpty {
            sharedWith += "Shared with "
            
            for index in 0...names.count - 1 {
                if let name = names[index] {
                    sharedWith += name
                    sharedWith += index < names.count - 2 ? ", " : ""
                    sharedWith += index < names.count - 1 ? " & " : ""
                }
            }
        }
        
        nameLabel.text = checklist.name
        sharedWithLabel.text = sharedWith
        itemsCountLabel.text = "\(checklist.items.count) / \(checklist.items.count)"
    }
}
