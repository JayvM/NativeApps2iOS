import UIKit

class LoginViewController: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    //Properties
    
    var accounts = [Account]()
    
    //Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.text = Account.getTestAccount().email
        passwordTextField.text = Account.getTestAccount().password
        
        updateLoginButton()
        errorLabel.text = ""
        
        if let accounts = Account.getAccounts() {
            self.accounts = accounts
        } else {
            accounts.append(Account.getTestAccount())
        }
    }
    
    /*
     Stack Overflow: Passing data from a view controller to a tableview controller through a navigation controller
     https://stackoverflow.com/questions/25369412/swift-pass-data-through-navigation-controller
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChecklistsSegue" {
            let navigationController = segue.destination as? UINavigationController
            let checklistsTableViewController = navigationController?.viewControllers.first as! ChecklistsTableViewController
            
            checklistsTableViewController.account = sender as? Account
        }
    }
    
    //Functions
    
    func updateLoginButton() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        loginButton.isEnabled = !email.isEmpty && !password.isEmpty
        errorLabel.text = ""
    }
    
    //Actions
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        updateLoginButton()
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        for account in accounts {
            if account.email == email && account.password == password {
                performSegue(withIdentifier: "ChecklistsSegue", sender: account)
                return
            }
        }
        
        errorLabel.text = "The E-mail or password is incorrect!"
    }
    
}
