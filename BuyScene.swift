
import SpriteKit
import StoreKit


class BuyScene: SKScene, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var skView: SKView! = nil
    //let arrayOfValues = ["Full package", "Buy background", "Buy only game", "Back"]
    let arrayOfValues = ["Buy only game", "Back"]
    let sndButtonClick = SKAction.playSoundFileNamed("menu_click1.wav", waitForCompletion: false)
    
    
    var productArray = [SKProduct]()
    var product = SKProduct()
    
    override func didMove(to view: SKView) {
        self.skView = self.view! as SKView
        let backgroundNode = SKSpriteNode(imageNamed: "main_menu")
        backgroundNode.size = self.frame.size
        backgroundNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        backgroundNode.zPosition = 0
        self.createMenuInScene(arrayOfValues: arrayOfValues, zPosition: 3)
        self.addChild(backgroundNode)
        createSoundButton()
        
        if(SKPaymentQueue.canMakePayments()){// && Reachability.isConnectedToNetwork()) {
            print("IAP is enabled, loading")
            let productID:NSSet = NSSet(objects: "removeAdsFromTetma")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            
            request.delegate = self
            request.start()
            
        } else if (!SKPaymentQueue.canMakePayments()){
            let alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: { alertAction in
                //  alert.dismiss(animated: true, completion: nil)
                alert.dismiss(animated: true, completion: nil)
                
                let url: NSURL? = NSURL(string: UIApplicationOpenSettingsURLString)
                if url != nil
                {
                    UIApplication.shared.openURL(url! as NSURL as URL)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        }// else if !Reachability.isConnectedToNetwork() {
        //  let alert = UIAlertController(title: "Cellular Data is Turned Off", message: "Turn on cellular data or use Wi-Fi to access data", preferredStyle: UIAlertControllerStyle.alert)
        //  alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        // self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        //}
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if self.atPoint(location).name == "Back_button" || self.atPoint(location).name == "Back_label"  {
                let btn = self.childNode(withName: "Back_button")
                let scene = MenuScene(size: self.size)
                presentNewScene(scene: scene, skView: skView, button: btn!)
            } else if self.atPoint(location).name == "Sound_button" {
                let soundButton = self.childNode(withName: "Sound_button") as! SKSpriteNode
                if GameViewController.sound {
                    GameViewController.sound = false
                    soundButton.texture = SKTexture(imageNamed: "sound_off")
                } else {
                    GameViewController.sound = true
                    soundButton.texture = SKTexture(imageNamed: "sound_on")
                }
            } else if self.atPoint(location).name == "Buy only game_button" || self.atPoint(location).name == "Buy only game_label" {
                
                for product in productArray {
                    let prodID = product.productIdentifier
                    if prodID == "removeAdsFromTetma" {
                        let alert = UIAlertController(title: "Confirm Your Purchase", message: "Do you want to buy Tetma witout ads?", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "Buy", style: UIAlertActionStyle.default, handler: { alertAction in
                            alert.dismiss( animated: true, completion: nil)
                            let pay = SKPayment(product: product)
                            SKPaymentQueue.default().add(self)
                            SKPaymentQueue.default().add(pay as SKPayment)
                        }))
                        
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { alertAction in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                }
            }
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {    }
    
    
    
    
    func RestorePurchases() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // 4
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
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
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
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
    
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add paymnet")
        
        for transaction:AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            print(trans.error)
            
            switch trans.transactionState {
                
            case .purchased:
                
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
            case .failed:
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
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("remove")
    }
    
    
    
}
