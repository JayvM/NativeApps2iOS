import Foundation

/*
    Resetting the simulator
    Simulator: Hardwarde > Erase all content and settings
*/

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
            //Test data
            let account1 = Account(id: 2, name: "Eric", email: "eric@mail.com", password: "pw", checklists: nil)
            let account2 = Account(id: 3, name: "Patsy", email: "patsy@mail.com", password: "pw", checklists: nil)
            
            let item1 = Item(name: "Bread")
            let item2 = Item(name: "Potatoes")
            let item3 = Item(name: "Chocolate")
            let item4 = Item(name: "Food")
            let item5 = Item(name: "Drinks")
            let item6 = Item(name: "Games")
            
            let items1 = [item1, item2, item3]
            let items2 = [item4, item5, item6]
            
            let accounts1 = [account1.id, account2.id]
            
            let checklist1 = Checklist(name: "Grocery store", items: items1, accounts: accounts1)
            let checklist2 = Checklist(name: "Party", items: items2, accounts: nil)
            let checklist3 = Checklist(name: "Vacation", items: nil, accounts: nil)
            
            let checklists1 = [checklist1, checklist2, checklist3]
            
            let account3 = Account(id: 1, name: "Jay", email: "jay@mail.com", password: "pw", checklists: checklists1)
            
            let accounts = [account1, account2, account3]
            
            self.accounts = accounts
        }
    }
    
    //Methods
    
    func getID() -> Int {
        var id: Int
        
        repeat {
            id = Int.random(in: 1...4)
            print(id)
        } while (!doesIdAlreadyExist(id))
        
        return id
    }
    
    func doesIdAlreadyExist(_ id: Int) -> Bool {
        for account in accounts {
            if account.id == id {
                return true
            }
        }
        
        return false
    }
    
    func getAccount(_ id: Int) -> Account? {
        for account in accounts {
            if account.id == id {
                return account
            }
        }
        
        return nil
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
