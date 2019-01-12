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
        
        loginButton.isEnabled = false
        errorLabel.text = ""
        
        if let accounts = Account.getAccounts() {
            self.accounts = accounts
        } else {
            accounts.append(Account(email: "test@mail.com", password: "test"))
        }
    }
    
    //Functions
    
    //Actions
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        loginButton.isEnabled = !email.isEmpty && !password.isEmpty
        errorLabel.text = ""
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        for account in accounts {
            if account.email == email && account.password == password {
                print("logged in")
                return
            }
        }
        
        errorLabel.text = "The E-mail or password is incorrect!"
    }
    
}
