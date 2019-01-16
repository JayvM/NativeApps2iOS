import Foundation

class Checklist: Codable {
    
    //Properties
    
    var name: String
    var items: [Item]
    var sharedAccounts: [Account]
    
    //Initializer
    
    init(name: String, items: [Item]?, sharedAccounts: [Account]?) {
        self.name = name
        self.items = items ?? []
        self.sharedAccounts = sharedAccounts ?? []
    }
    
    //Methods
    
    func addSharedAccount(_ account: Account) {
        sharedAccounts.append(account)
    }
    
    func removeSharedAccount(_ index: Int) {
        sharedAccounts.remove(at: index)
    }
}
