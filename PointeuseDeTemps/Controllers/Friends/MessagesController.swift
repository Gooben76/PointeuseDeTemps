//
//  MessagesController.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 08/12/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

class MessagesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var sendButton: ButtonSmallTS!
    @IBOutlet weak var smsButton: ButtonSmallTS!
    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var messageTextView: TextViewChat!
    
    @IBOutlet weak var messageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextViewHeightConstraint: NSLayoutConstraint!
    
    let cellId = "MessageCell"
    
    var friend: Users!
    var userConnected: Users!
    
    var messages = [Messages]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = RSC_MESSAGES
        keyboardManagement()
        
        messageTextView.delegate = self
        collectView.delegate = self
        collectView.dataSource = self
        
        let nib = UINib(nibName: cellId, bundle: nil)
        collectView.register(nib, forCellWithReuseIdentifier: cellId)
        
        collectView.keyboardDismissMode = .interactive
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataNewMessageForTheFriend), name: .newMessageForAFriendMessage, object: nil)
    }

    @objc func dataNewMessageForTheFriend(notification: NSNotification) {
        loadMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        if !friend.allowMessages {
            sendButton.isEnabled = false
            smsButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
            smsButton.isEnabled = true
        }
        loadMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func loadMessages() {
        if friend != nil && userConnected != nil {
            if let allData = MessagesDataHelpers.getFunc.getAllMessageForAUser(friend: friend, userConnected: userConnected) {
                messages = allData
            }
        }
        sortMessages()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MessageCell {
            cell.initCell(message: messages[indexPath.row], userConnected: userConnected)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    @IBAction func sendButton_Click(_ sender: Any) {
        if let message = messageTextView.text, message != "" {
            if !MessagesDataHelpers.getFunc.setNewMessage(userFromId: userConnected, userToId: friend, message: message, sms: false, userConnected: userConnected) {
                print("Erreur sauvegarde message")
            }
        }
        view.endEditing(true)
        messageTextView.text = ""
        loadMessages()
    }
    
    @IBAction func smsButton_Click(_ sender: Any) {
        if let message = messageTextView.text, message != "" {
            if !MessagesDataHelpers.getFunc.setNewMessage(userFromId: userConnected, userToId: friend, message: message, sms: true, userConnected: userConnected) {
                print("Erreur sauvegarde message")
            }
        }
        view.endEditing(true)
        messageTextView.text = ""
        loadMessages()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let width = collectView.frame.width
        
        let message = messages[indexPath.row]
        if let text = message.message {
            height += text.hauteur(largeur: width, font: UIFont.systemFont(ofSize: 17))
        }
        
        return CGSize(width: width, height: height)
    }
    
    func sortMessages() {
        messages = messages.sorted(by: {$0.modifiedDate! < $1.modifiedDate!})
        DispatchQueue.main.async {
            self.collectView.reloadData()
            let indexPath = IndexPath(item: self.messages.count-1, section: 0)
            self.collectView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
}
