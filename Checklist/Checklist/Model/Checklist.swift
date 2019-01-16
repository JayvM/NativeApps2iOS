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
    
    func addItem(_ item: Item) {
        items.append(item)
    }
    
    func removeItem(_ index: Int) {
        items.remove(at: index)
    }
    
    func addSharedAccount(_ account: Account) {
        sharedAccounts.append(account)
    }
    
    func removeSharedAccount(_ index: Int) {
        sharedAccounts.remove(at: index)
    }
}
