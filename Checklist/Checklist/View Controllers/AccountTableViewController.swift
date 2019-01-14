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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "SaveAccountUnwind" else {
            return
        }
        
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
    
        dataController.insertAccount(Account(id: dataController.getID(), name: name, email: email, password: password, checklists: nil))
    }
    
    //Functions

    func updateSaveButton() {
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let repeatPassword = repeatPasswordTextField.text ?? ""
        
        saveButton.isEnabled = false
        
        if !name.isEmpty && !email.isEmpty && !password.isEmpty && !repeatPassword.isEmpty {
            if password == repeatPassword {
                saveButton.isEnabled = true
            }
        }
    }
    
    //Actions
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        updateSaveButton()
    }
}
