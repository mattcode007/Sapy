//
//  BotHomeVCCollectionViewController.swift
//  StudIO
//
//  Created by Matteo Cesari on 31/01/17.
//  Copyright © 2017 Matteo Cesari. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController
import Photos
import CoreLocation


private let reuseIdentifier = "Cell"

class BotHomeVC: JSQMessagesViewController,CLLocationManagerDelegate,UINavigationBarDelegate,UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate
{
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        
    }

   
   /* let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 39, height: 39))
    imageView.contentMode = .scaleAspectFit
    let image = UIImage(named: "newlogo.jpg")
    imageView.image = image
    navigationItem.titleView = imageView foto in navigation */
    var messages = [JSQMessage]()
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    var messageRef: FIRDatabaseReference!
    var newMessageRefHandle: FIRDatabaseHandle?
    var channelRef: FIRDatabaseReference!
    var channelRefHandle: FIRDatabaseHandle?
    let uid:String = (FIRAuth.auth()?.currentUser?.uid)!
    let name:String =  (FIRAuth.auth()?.currentUser?.displayName)!
    @IBOutlet weak var selectedCellLabel: UILabel!
    var locationManager = CLLocationManager()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       /* let height: CGFloat = 20 //whatever height you want
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
 */
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        var searchBar = UISearchBar(frame: CGRect.zero)
        searchBar.tintColor = UIColor.white // color of bar button items
        searchBar.barTintColor = UIColor.blue // color of text field background
        searchBar.backgroundColor = UIColor.clear // color of box surrounding text field
        searchBar.searchBarStyle = UISearchBarStyle.default
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Cerca Studenti"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        let long = locationManager.location?.coordinate.latitude
        let lat = locationManager.location?.coordinate.longitude
        transport()
        
       
        
        channelRef = FIRDatabase.database().reference()
        messageRef = channelRef.child("channels/"+(uid))

        //avatar
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        observeMessages()
        self.senderId = FIRAuth.auth()?.currentUser?.uid
        self.senderDisplayName = FIRAuth.auth()?.currentUser?.displayName
        self.addMessageBot(text:"Ciao \(name)")
        self.addMessageBot(text:"StudIO ti può aiutare a:\nTrovare aule libere\nOrari mezzi più vicini\nSpottare")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        func viewDidAppear(animated: Bool){
            
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        print("funzione non disponibile")
    }
    //posizione utente
   
    func get(long:String,lat:String){
        print(long+lat)
    }
    
    func makesami(){
        
        performSegue(withIdentifier: "esami", sender:nil)
    }
    func compiti(){
        
        performSegue(withIdentifier: "compiti", sender:nil)
    }
    func contatti(){
        
        performSegue(withIdentifier: "contatti", sender:nil)
    }
    func transport(){
          }
    
    //invio
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let timestamp:Int64 = Int64(Date().timeIntervalSince1970*1000)
        messageRef.child("\(timestamp)").setValue(["text": text!, "sender":"user"])
        print("\(timestamp)")
        
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
        
        self.showTypingIndicator = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(30), execute: {() in
            FIRDatabase.database().reference().child("answers/"+(text)).observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.showTypingIndicator = false
                
                let timestamp:Int64 = Int64(Date().timeIntervalSince1970*1000)
                print("\(timestamp)")
                
                if let risposta = ((snapshot.value) as? String) {
                    
                    self.messageRef.child("\(timestamp)").setValue(["text": risposta.uppercased(), "sender":"bot"] as [String:String?])
                    
                    
                    
                }else{
                    self.messageRef.child("\(timestamp)").setValue(["text": "non so questa risposta ancora", "sender":"bot"] as [String:String?])
                }
                
            })
        })
    }
    
    private func observeMessages() {
        //messageRef = channelRef.child("messages")
        let messageQuery = messageRef.queryOrderedByKey().queryLimited(toLast:25)
        
        // 2. We can use the observe method to listen for new
        // messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if let text = messageData["text"], let sender = messageData["sender"], text.characters.count > 0 {
                
                self.addMessage(senderId:sender == "user" ? self.uid : "0", displayName:sender == "user" ? self.name : "Bot :)",text: text)
                
                self.finishReceivingMessage()
                
            } else {
                print("Error! Could not decode message data")
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        //cell.textView.font = UIFont.boldSystemFont(ofSize: 15)
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    func addMessage(senderId:String,displayName:String,text: String) {
        if let message = JSQMessage(senderId: senderId, displayName: displayName, text: text) {
            messages.append(message)
        }
    }
    
    func addMessageBot(text: String) {
        if let message = JSQMessage(senderId:"0",displayName:"Bot",text: text) {
            messages.append(message)
        }
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with:UIColor.init(colorLiteralRed: 59/255, green: 165/255, blue: 243/255, alpha: 1) )
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}

