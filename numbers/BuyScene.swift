import SpriteKit
import StoreKit

class BuyScene: SKScene, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var skView: SKView! = nil
    //let arrayOfValues = ["Full package", "Buy background", "Buy only game", "Back"]
    let arrayOfValues = ["Buy only game", "Back"]
    let sndButtonClick = SKAction.playSoundFileNamed("menu_click.wav", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        self.skView = self.view! as SKView
        let backgroundNode = SKSpriteNode(imageNamed: "main_menu")
        backgroundNode.size = self.frame.size
        backgroundNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        backgroundNode.zPosition = 0
        self.createMenuInScene(arrayOfValues, zPosition: 3)
        self.addChild(backgroundNode)
        createSoundButton()
        
        if(SKPaymentQueue.canMakePayments()) {
            print("IAP is enabled, loading")
            let productID:NSSet = NSSet(objects: "tetma.tetmaplayPurchases.com")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("please enable IAPS")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if self.atPoint(location).name == "Back_button" || self.atPoint(location).name == "Back_label"  {
                let btn = self.childNode(withName: "Back_button")
                let scene = MenuScene(size: self.size)
                presentNewScene(scene, skView: skView, button: btn!)
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
               // let payment = SKPayment(product: )
            
                for product in productArray {
                    let prodID = product.productIdentifier
                    if prodID == "tetma.tetmaplayPurchases.com" {
                        let pay = SKPayment(product: product)
                        SKPaymentQueue.default().add(self)
                        SKPaymentQueue.default().add(pay as SKPayment)
                       // SKPaymentQueue.default().add(p)
                        
                    }
                }
                
            }

        }
    }
    
    override func update(_ currentTime: TimeInterval) {    }
    
    var productArray = [SKProduct]()
    var product = SKProduct()
    
    func RestorePurchases() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("product request")
        let myProduct = response.products
        for product in myProduct {
            print(product.productIdentifier)
            productArray.append(product as SKProduct)
        }
    }
    
    // 4
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("transactions restored")
        
     
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction as SKPaymentTransaction
            
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "tetma.tetmaplayPurchases.com":
                print("remove ads")
            default:
                print("IAP not setup")
            }
            
        }
    }
  
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add paymnet")
        
        for transaction:AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            print(trans.error)
            
            switch trans.transactionState {
                
            case .purchased:
                print("buy, ok unlock iap here")
                print(product.productIdentifier)
                
                let prodID = product.productIdentifier as String
                switch prodID {
                case "tetma.tetmaplayPurchases.com":
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
    
    //7
    private func paymentQueue(queue: SKPaymentQueue!, removedTransactions transactions: [AnyObject]!)
    {
        print("remove trans");
    }
}
