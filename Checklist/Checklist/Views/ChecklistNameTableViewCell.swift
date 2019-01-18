import UIKit

class ChecklistNameTableViewCell: UITableViewCell {
    
    //Outlets
    
    @IBOutlet weak var nameTextField: UITextField!

    //Override functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Functions
    
    func set(_ name: String) {
        nameTextField.text = name
    }

}
