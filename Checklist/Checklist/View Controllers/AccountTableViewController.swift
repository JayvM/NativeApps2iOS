import UIKit

class AccountTableViewController: UITableViewController {
    
    //Outlets
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    //Properties

    var dataController: DataController!
    
    //Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButton()
    }
    
    /*
     USED AS GUIDANCE: How to cancel a segue
     SOURCE: https://stackoverflow.com/questions/28883050/swift-prepareforsegue-cancel
     */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "SaveAccountUnwind" {
            let email = emailTextField.text ?? ""
            
            if dataController.getAccount(email) != nil {
                let alert = UIAlertController(title: "Hold on!", message: "The E-mail is already being used.", preferredStyle: .alert)
                let tryAgain = UIAlertAction(title: "Try again", style: .default, handler: nil)
                
                alert.addAction(tryAgain)
                self.present(alert, animated: true)
                return false
            }
            
            let password = passwordTextField.text ?? ""
            let repeatPassword = repeatPasswordTextField.text ?? ""
            
            if password != repeatPassword {
                let alert = UIAlertController(title: "Hold on!", message: "The two passwords are not the same.", preferredStyle: .alert)
                let tryAgain = UIAlertAction(title: "Try again", style: .default, handler: nil)
                
                alert.addAction(tryAgain)
                self.present(alert, animated: true)
                return false
            }
        }

        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "SaveAccountUnwind" else {
            return
        }

        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        dataController.addAccount(Account(name: name, email: email, password: password, checklists: nil))
        dataController.updateData()
    }
    
    //Functions

    func updateSaveButton() {
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let repeatPassword = repeatPasswordTextField.text ?? ""
        
        saveButton.isEnabled = !name.isEmpty && !email.isEmpty && !password.isEmpty && !repeatPassword.isEmpty
    }
    
    //Actions
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        updateSaveButton()
    }
}
