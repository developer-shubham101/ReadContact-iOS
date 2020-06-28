//
//  ContactViewModel.swift
//  Reward
//
//  Created by Shubham Sharma on 22/11/19.
//  Copyright © 2019 Shubham Sharma. All rights reserved.
//

import Foundation
import UIKit
import Contacts

enum UserValidationState {
    case valid
    case invalid(String)
}


struct MyContact {
    var firstName = ""
    var middleName = ""
    var lastName = ""
    var mobile = ""
    
    var is_selected = false
   
}
class ContactViewModel {
    
    // Saving the newly created contact
    fileprivate let contactStore = CNContactStore()
    
    fileprivate var allContactList:[MyContact] = []
    var selectedList:[MyContact] = []
    var contactList:[MyContact] = []
    
    
    func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
            break
        case .denied:
            completionHandler(false)
            break
        case .restricted, .notDetermined:
            contactStore.requestAccess(for: .contacts) { granted, error in
                if granted {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
            break
        }
    }
    
    func fetchContact(completion: @escaping (_ isSuccess: Bool) -> Void) {
        
        var myContacts = [MyContact]()
        
        
        //Set key which we want to fetch
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactEmailAddressesKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactImageDataAvailableKey as CNKeyDescriptor,
            CNContactThumbnailImageDataKey as CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        
        do {
            try self.contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                for phoneNumber in contact.phoneNumbers {
                    var filteredMobileNo = phoneNumber.value.stringValue
                    //						.replacingOccurrences(of: "+91", with: "")
                    //						.replacingOccurrences(of: "-", with: "")
                    //						.replacingOccurrences(of: "(", with: "")
                    //						.replacingOccurrences(of: ")", with: "")
                    //						.replacingOccurrences(of: " ", with: "")
                    //
                    //					if (filteredMobileNo.count > 10 && filteredMobileNo.hasPrefix("0") ){
                    //						filteredMobileNo = String(filteredMobileNo.dropFirst())
                    //					}
                    
                    
                    
                    myContacts.append(MyContact(firstName: contact.givenName,
                                                middleName: contact.middleName,
                                                lastName: contact.familyName,
                                                mobile: filteredMobileNo
                        )
                    )
                }
                
            }
            contactList = myContacts
            allContactList = myContacts
            
            completion(true)
        }
        catch {
            completion(false)
        }
    }
}
 
// MARK: Public Methods
extension ContactViewModel {
    
    func updateSearch(keyWord:String) {
        
        if keyWord == "" {
            self.allContactList.sort { (element, element2) -> Bool in
                return element.firstName.lowercased() < element2.firstName.lowercased()
            }
            self.contactList = self.allContactList
        } else if keyWord.count > 1 {
            let lowerCaseKeyword = (keyWord).lowercased()
            
            let tmp: [MyContact] = allContactList.filter { (element) -> Bool in
                if (element.firstName + " " + element.lastName).lowercased().range(of: lowerCaseKeyword) != nil ||
                    (element.firstName).range(of: lowerCaseKeyword) != nil ||
                    (element.lastName).range(of: lowerCaseKeyword) != nil ||
                    (element.firstName).lowercased().range(of: lowerCaseKeyword) != nil ||
                    (element.lastName).lowercased().range(of: lowerCaseKeyword) != nil ||
                    (element.mobile).lowercased().range(of: lowerCaseKeyword) != nil {
                    return true
                }
                return false
            }
            self.contactList = tmp
        }
    }
    
    func select( indexPath: IndexPath) {
        contactList[indexPath.row].is_selected = !contactList[indexPath.row].is_selected
        
        if (contactList[indexPath.row].is_selected){
            selectedList.append(contactList[indexPath.row])
        } else {
            let filterList = selectedList.filter { (element) -> Bool in
                return element.mobile != contactList[indexPath.row].mobile
            }
            selectedList = filterList
        }
        
    }
}
