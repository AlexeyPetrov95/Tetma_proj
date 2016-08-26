import SpriteKit
import StoreKit


class BuyScene: SKScene, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var skView: SKView! = nil
    //let arrayOfValues = ["Full package", "Buy background", "Buy only game", "Back"]
    let arrayOfValues = ["Buy only game", "Back"]
    let sndButtonClick = SKAction.playSoundFileNamed("menu_click.wav", waitForCompletion: false)
    

    var productArray = [SKProduct]()
    var product = SKProduct()
    
    override func didMoveToView(view: SKView) {
        self.skView = self.view! as SKView
        let backgroundNode = SKSpriteNode(imageNamed: "main_menu")
        backgroundNode.size = self.frame.size
        backgroundNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        backgroundNode.zPosition = 0
        self.createMenuInScene(arrayOfValues, zPosition: 3)
        self.addChild(backgroundNode)
        createSoundButton()
        
        if(SKPaymentQueue.canMakePayments() && Reachability.isConnectedToNetwork()) {
            print("IAP is enabled, loading")
            let productID:NSSet = NSSet(objects: "removeAdsFromTetma")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            
            request.delegate = self
            request.start()
            
        } else if (!SKPaymentQueue.canMakePayments()){
            let alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: { alertAction in
              //  alert.dismiss(animated: true, completion: nil)
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                let url: NSURL? = NSURL(string: UIApplicationOpenSettingsURLString)
                if url != nil
                {
                    UIApplication.sharedApplication().openURL(url! as NSURL)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
           
            self.view?.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            
        } else if !Reachability.isConnectedToNetwork() {
            let alert = UIAlertController(title: "Cellular Data is Turned Off", message: "Turn on cellular data or use Wi-Fi to access data", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            self.view?.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location).name == "Back_button" || self.nodeAtPoint(location).name == "Back_label"  {
                let btn = self.childNodeWithName("Back_button")
                let scene = MenuScene(size: self.size)
                presentNewScene(scene, skView: skView, button: btn!)
            } else if self.nodeAtPoint(location).name == "Sound_button" {
                let soundButton = self.childNodeWithName("Sound_button") as! SKSpriteNode
                if GameViewController.sound {
                    GameViewController.sound = false
                    soundButton.texture = SKTexture(imageNamed: "sound_off")
                } else {
                    GameViewController.sound = true
                    soundButton.texture = SKTexture(imageNamed: "sound_on")
                }
            } else if self.nodeAtPoint(location).name == "Buy only game_button" || self.nodeAtPoint(location).name == "Buy only game_label" {
        
                for product in productArray {
                    let prodID = product.productIdentifier
                    if prodID == "removeAdsFromTetma" {
                        let alert = UIAlertController(title: "Confirm Your Purchase", message: "Do you want to buy Tetma witout ads?", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alert.addAction(UIAlertAction(title: "Buy", style: UIAlertActionStyle.Default, handler: { alertAction in
                            alert.dismissViewControllerAnimated( true, completion: nil)
                            let pay = SKPayment(product: product)
                            SKPaymentQueue.defaultQueue().addTransactionObserver(self)
                            SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
                        }))

                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { alertAction in
                            alert.dismissViewControllerAnimated(true, completion: nil)
                        }))
                        self.view?.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }

        }
    }
    
    override func update(currentTime: NSTimeInterval) {    }
    
    
    
    
    func RestorePurchases() {
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
  
 
    // 4
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        print("transactions restored")
        
     
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction as SKPaymentTransaction
            
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "removeAdsFromTetma":
                print("remove ads")
            default:
                print("IAP not setup")
            }
            
        }
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        var products = response.products
        if (products.count != 0) {
            for i in 0 ..< products.count {
                self.product = products[i]
                self.productArray.append(product)
            }
        } else {
            print("No products found")
        }
    }
    
    
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add paymnet")
        
        for transaction:AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            print(trans.error)
            
            switch trans.transactionState {
                
            case .Purchased:
              
                let prodID = product.productIdentifier as String
                switch prodID {
                case "removeAdsFromTetma":
                    print("remove ads")
                    
                case "bundle id":
                    print("add coins to account")
                    
                default:
                    print("IAP not setup")
                }
                
                queue.finishTransaction(trans)
                break;
            case .Failed:
                print("buy error")
                queue.finishTransaction(trans)
                break;
            default:
                print("default")
                break;
                
            }
        }
    }
    
    // 6
    func finishTransaction(trans:SKPaymentTransaction)
    {
        print("finish trans")
    }
    
    func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("remove")
    }
    
   

}
