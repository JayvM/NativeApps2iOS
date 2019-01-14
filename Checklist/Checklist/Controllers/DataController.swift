import Foundation

class DataController {
    
    //Static properties
    static var directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let directoryURL = directory.appendingPathComponent("data").appendingPathExtension("plist")
    
    //Properties

    var accounts: [Account]
    var currentAccount: Account!
    
    //Initializer
    
    init() {
        if let encodedAccounts = try? Data(contentsOf: DataController.directoryURL), let accounts = try? PropertyListDecoder().decode([Account].self, from: encodedAccounts) {
            self.accounts = accounts
        } else {
            self.accounts = []
        }
    }
    
    //Methods
    
    func getTestAccount() -> Account {
        let item1 = Item(name: "Bread")
        let item2 = Item(name: "Potatoes")
        let item3 = Item(name: "Chocolate")
        let item4 = Item(name: "Food")
        let item5 = Item(name: "Drinks")
        let item6 = Item(name: "Games")
        
        let items1 = [item1, item2, item3]
        let items2 = [item4, item5, item6]
        
        let account1 = Account(name: "Patsy", email: "patsy@mail.com", password: "pw", checklists: nil)
        let account2 = Account(name: "Eric", email: "eric@mail.com", password: "pw", checklists: nil)
        let account3 = Account(name: "Max", email: "max@mail.com", password: "pw", checklists: nil)
        
        let accounts1 = [account1, account2, account3]
        
        let checklist1 = Checklist(name: "Grocery store", items: items1, accounts: accounts1)
        let checklist2 = Checklist(name: "Party", items: items2, accounts: nil)
        let checklist3 = Checklist(name: "Vacation", items: nil, accounts: nil)
        
        let checklists1 = [checklist1, checklist2, checklist3]
        
        return Account(name: "Jay", email: "jay@mail.com", password: "pw", checklists: checklists1)
    }
    
    func writeAccounts() {
        let encodedAccounts = try? PropertyListEncoder().encode(accounts)
        
        try? encodedAccounts?.write(to: DataController.directoryURL, options: .noFileProtection)
    }
    
    func insertAccount(_ account: Account) {
        accounts.append(account)
        writeAccounts()
    }
    
    func updateAccount(_ account: Account) {
        for index in 0...accounts.count - 1 {
            if accounts[index].email == account.email {
                accounts[index] = account
                break
            }
        }
        
        writeAccounts()
    }
}
