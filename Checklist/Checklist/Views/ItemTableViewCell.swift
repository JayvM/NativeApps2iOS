import UIKit

protocol ItemTableViewCellDelegate {
    func checkedButtonTapped(sender: ItemTableViewCell)
}

class ItemTableViewCell: UITableViewCell {
    
    //Outlets

    @IBOutlet weak var checkedButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    //Properties
    
    var delegate: ItemTableViewCellDelegate?
    
    //Override functions

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Functions
    
    func set(_ item: Item) {
        let image = item.checked ? UIImage(named: "checked.png") : UIImage(named: "unchecked.png")
        
        nameLabel.text = item.name
        checkedButton.setImage(image, for: .normal)
    }

    //Actions
    
    @IBAction func checkedButtonTapped(_ sender: UIButton) {
        delegate?.checkedButtonTapped(sender: self)
    }
}
