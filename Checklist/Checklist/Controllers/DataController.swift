import Foundation
import UIKit

/*
 Resetting the simulator
 Simulator: Hardwarde > Erase all content and settings
*/

/*
 USED AS GUIDANCE: How to save and load UIImages to and from a directory
 SOURCE: https://medium.com/@Dougly/persisting-image-data-locally-swift-3-8bae72673f8a
 SOURCE: https://stackoverflow.com/questions/26931355/how-to-create-directory-using-swift-code-nsfilemanager
 SOURCE: https://forums.developer.apple.com/thread/68533
*/

class DataController {
    
    //Properties
    
    let dataDirectory: URL
    let imagesDirectory: URL
    
    var accounts: [Account]
    
    //Initializer
    
    init() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        dataDirectory = documentsDirectory.appendingPathComponent("data").appendingPathExtension("plist")
        imagesDirectory = documentsDirectory.appendingPathComponent("images")

        print(documentsDirectory.absoluteString)
        
        //Accounts
        
        if let encodedAccounts = try? Data(contentsOf: dataDirectory), let accounts = try? PropertyListDecoder().decode([Account].self, from: encodedAccounts) {
            self.accounts = accounts
        } else {
            //Test data
            let account1 = Account(name: "Eric", email: "eric@mail.com", password: "pw", checklists: nil)
            let account2 = Account(name: "Patsy", email: "patsy@mail.com", password: "pw", checklists: nil)
            
            let item1 = Item(name: "Bread", imageId: nil, note: nil)
            let item2 = Item(name: "Potatoes", imageId: nil, note: nil)
            let item3 = Item(name: "Chocolate", imageId: nil, note: nil)
            let item4 = Item(name: "Food", imageId: nil, note: nil)
            let item5 = Item(name: "Drinks", imageId: nil, note: nil)
            let item6 = Item(name: "Games", imageId: nil, note: nil)
            
            let items1 = [item1, item2, item3]
            let items2 = [item4, item5, item6]
            
            let accounts1 = [account1, account2]
            
            let checklist1 = Checklist(name: "Grocery store", items: items1, sharedAccounts: accounts1)
            let checklist2 = Checklist(name: "Party", items: items2, sharedAccounts: nil)
            let checklist3 = Checklist(name: "Vacation", items: nil, sharedAccounts: nil)
            
            let checklists1 = [checklist1, checklist2, checklist3]
            
            let account3 = Account(name: "Jay", email: "jay@mail.com", password: "pw", checklists: checklists1)
            
            let accounts = [account1, account2, account3]
            
            self.accounts = accounts
        }
        
        //Images
        
        if !fileManager.fileExists(atPath: imagesDirectory.path) {
            do {
                try fileManager.createDirectory(at: imagesDirectory, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print("ERROR: Could not create a directory!")
            }
        }
    }
    
    //Methods (accounts)
    
    func addAccount(_ account: Account) {
        accounts.append(account)
    }
    
    func getAccount(_ email: String) -> Account? {
        for account in accounts {
            if account.email == email {
                return account
            }
        }
        
        return nil
    }
    
    func updateData() {
        let encodedAccounts = try? PropertyListEncoder().encode(accounts)
        
        try? encodedAccounts?.write(to: dataDirectory, options: .noFileProtection)
    }
    
    //Methods (images)
    
    func createImageId() -> Int {
        var id: Int
        
        repeat {
            id = Int.random(in: 1...100)
            print(id)
        } while (doesImageIdAlreadyExist(id))
        
        return id
    }
    
    func doesImageIdAlreadyExist(_ id: Int) -> Bool {
        for account in accounts {
            for checklist in account.checklists {
                for item in checklist.items {
                    if item.imageId == id {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    func writeImage(_ id: Int, _ image: UIImage) {
        do {
            if let file = image.jpegData(compressionQuality: 1) {
                let directory = imagesDirectory.appendingPathComponent(String(id)).appendingPathExtension("jpg")
                
                try file.write(to: directory, options: .noFileProtection)
            }
        } catch {
            print("ERROR: Could not write the images!")
        }
    }
    
    func getImage(_ id: Int) -> UIImage? {
        let directory = imagesDirectory.appendingPathComponent(String(id)).appendingPathExtension("jpg")
        
        return UIImage(contentsOfFile: directory.path)
    }
}
