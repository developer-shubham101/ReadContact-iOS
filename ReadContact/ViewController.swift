//
//  ViewController.swift
//  ReadContact
//
//  Created by Shubham Sharma on 28/06/20.
//  Copyright © 2020 Newdevpoint. All rights reserved.
//

import UIKit
 
class ViewController: UIViewController {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var contactTableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionFlow: UICollectionViewFlowLayout!
    
    
    //Create ViewModel
    fileprivate var viewModel = ContactViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchField.addTarget(self, action: #selector(updateSearch(sender:)), for: .editingChanged)
        
        initTable()
        
        /// Ask Request for contact
        viewModel.requestAccess { (response) in
            //If user give access for contact
            if (response){
                //Then fetch contact from your phone bool
                self.viewModel.fetchContact(completion: { (isSuccess) in
                    if isSuccess  {
                        DispatchQueue.main.async {
                            self.contactTableView.reloadData()
                        }
                    }else{
                        print("unable to fetch contacts")
                    }
                })
            }else {
                DispatchQueue.main.async {
                    self.showSettingsAlert()
                }
            }
        }
//        IQKeyboardManager.shared().disabledToolbarClasses.add(ContactViewController.self)
//        NotificationCenter.default.addObserver(self, selector: #selector( keyboardFrameChangeNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector( keyboardFrameChangeNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
 
    }
    
    @IBAction func didTapDone(_ sender: UIButton) {
        print(viewModel.selectedList)
    }
 
    fileprivate func initTable() {
        contactTableView.delegate = self
        contactTableView.dataSource = self
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
         
        collectionFlow.minimumInteritemSpacing = 0
        collectionFlow.minimumLineSpacing = 0
        collectionFlow.scrollDirection = .horizontal
        
        collectionView.register(UINib(nibName: "SelectedContactCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectedContactCollectionViewCell")
        
    }
    
    /*@objc func keyboardFrameChangeNotification(notification: Notification) {
     if let userInfo = notification.userInfo {
     let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
     let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
     let animationCurveRawValue = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int) ?? Int(UIView.AnimationOptions.curveEaseInOut.rawValue)
     let animationCurve = UIView.AnimationOptions(rawValue: UInt(animationCurveRawValue))
     let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
     
     
     searchBoxBottomCons.constant = isKeyboardShowing ? endFrame?.height ?? 0 : 10
     
     UIView.animate(withDuration: animationDuration, delay: TimeInterval(0), options: animationCurve, animations: {
     self.view.layoutIfNeeded()
     }, completion: nil)
     }
     }*/
    private func showSettingsAlert() {
        let alert = UIAlertController(title: nil, message: "This app requires access to Contacts to proceed. Would you like to open settings and grant permission to contacts?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
            
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            
        })
        present(alert, animated: true)
    }
}

//MARK:- Table view delegats
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contactList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "ContactTableViewCell"
        var cell: ContactTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? ContactTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ContactTableViewCell
        }
        cell.selectionStyle = .none
        cell.configData(data: viewModel.contactList[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.select(indexPath: indexPath)
        collectionView.reloadData()
        
        tableView.reloadData()
    }
}


extension ViewController: UITextFieldDelegate {
    @objc func updateSearch(sender: UITextField) {
        viewModel.updateSearch(keyWord: sender.text!)
        self.contactTableView.reloadData()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchField {
            //any task to perform
            textField.resignFirstResponder() //if you want to dismiss your keyboard
        }
        return true
    }
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.selectedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedContactCollectionViewCell", for: indexPath) as! SelectedContactCollectionViewCell
        cell.configData(data: viewModel.selectedList[indexPath.row] )
        return cell
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 122 );
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
