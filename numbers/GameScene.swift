import SpriteKit
import AVFoundation
import GoogleMobileAds


class GameScene: SKScene, AVAudioPlayerDelegate {
    
    static var arrayOfStartNumbers = [InitailNumbers]()
    static var nextNumber = [GameNumber]()

    
    var colorArray = [UIColor]()
    var _start:Bool = false
    var countOfRow = 0
    var fallingSpeed:Double = 0
    var level = ""
    var interval = 0
    var countOfFallingNumbers = 0
    var sizeForEachVerticalRow: CGFloat = 0
    var timerForHelp: Int = 0
    let sizeForEachHorizontalRow: CGFloat = 48
    var helpIsActive: Bool = false
    var player = AVAudioPlayer()
    var over = false
    

    init(size: CGSize, countOfFallingNumbers: Int, fallingSpeed: Double, interval: Int, countOfRow: Int, level: String, timerForHelp: Int) {
        super.init(size: size)
       // self.isPaused = false
        self.paused = false
        self.sizeForEachVerticalRow = self.frame.width / CGFloat(countOfRow)
        self.helpIsActive = false
        
        self.countOfRow = countOfRow
        self.countOfFallingNumbers = countOfFallingNumbers
        self.fallingSpeed = fallingSpeed
        self.interval = interval
        self.level = level
        self.timerForHelp = timerForHelp
        
        self.over = false
        
        colorArray.removeAll()
        GameScene.arrayOfStartNumbers.removeAll()
        GameScene.nextNumber.removeAll()
    
        
        colorArray.append(UIColor(red: 0.2039215686, green: 0.2117647059, blue: 0.3019607843, alpha: 0.3))
        colorArray.append(UIColor(red: 0.2039215686, green: 0.2117647059, blue: 0.3019607843, alpha: 0.3))
        colorArray.append(UIColor(red: 0.2039215686, green: 0.2117647059, blue: 0.3019607843, alpha: 0.3))
        colorArray.append(UIColor(red: 0.2039215686, green: 0.2117647059, blue: 0.3019607843, alpha: 0.3))
        colorArray.append(UIColor(red: 0.2039215686, green: 0.2117647059, blue: 0.3019607843, alpha: 0.3))
        
        generateDefaultNumbers()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var intervalCounter = 0
    var startTime: NSTimeInterval = 0
    
    let menu = SKSpriteNode()
    let nextNumber = SKLabelNode()
    let finallyGameStatus = SKLabelNode()
    let sndButtonClick = SKAction.playSoundFileNamed("menu_click.wav", waitForCompletion: false)
    let intro = SKAction.playSoundFileNamed("intro+repeat.wav", waitForCompletion: true)
    let arrayOfValues = ["Main menu", "Resume", "Restart"]
    
  
    
    override func didMoveToView(view: SKView) {
        
        let backgroundNode = SKSpriteNode(imageNamed: "background")
        backgroundNode.size = self.frame.size
        backgroundNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        backgroundNode.zPosition = 0
        
        let pause = SKSpriteNode()
        let nextNumberShape = SKSpriteNode()
        
        nextNumberShape.size = CGSize(width: 100, height: 100)
        pause.size  = CGSize(width: 30, height: 30)
        
       
        if GameViewController.adBool.boolForKey("adBool") {
             pause.position =  CGPoint(x: pause.frame.width / 2 + 5, y: self.frame.height - pause.frame.height / 2 - 55)
             nextNumberShape.position = CGPoint(x: self.frame.width, y: self.frame.height - 50)
        } else {
             pause.position =  CGPoint(x: pause.frame.width / 2 + 5, y: self.frame.height - pause.frame.height / 2 - 5)
             nextNumberShape.position = CGPoint(x: self.frame.width, y: self.frame.height)
        }
       
        pause.name = "pause"
        pause.texture = SKTexture(imageNamed: "pause")
        pause.zPosition = 10
    
        
        nextNumberShape.texture = SKTexture(imageNamed: "next_number")
        nextNumberShape.zPosition = 10
        
        self.nextNumber.text = "3"
        self.nextNumber.fontColor = UIColor(red: 0.1652417779, green: 0.2237078249, blue: 0.3332712948, alpha: 1)
        self.nextNumber.zPosition = 11
        self.nextNumber.fontSize = 20
        
        // TODO:: доделать позиционирование
        self.nextNumber.position = CGPoint(x: -nextNumber.frame.width - self.nextNumber.frame.width / 2, y:  -nextNumber.frame.height - self.nextNumber.frame.height / 2)
        
        nextNumberShape.addChild(self.nextNumber)
        
        menu.zPosition = 500
        menu.color = UIColor(red: 0.6483612657, green: 0.64423877, blue: 0.6523267031, alpha: 0.3806988442)
        menu.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        menu.size = CGSize(width: self.frame.width, height: self.frame.height)
        
        createRow()
        setNextFallingNumbers()
        
        GameScene.nextNumber[0].start(self)
        GameScene.nextNumber[0].start = true
        
        self.addChild(nextNumberShape)
        self.addChild(pause)
        self.addChild(backgroundNode)
        
        if GameViewController.sound {
            playSound()
        }
        
        //createAndLoadInterstitial()
    }
    
    private func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-9894820443925606/3042654572")
        let request = GADRequest()
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made.
        request.testDevices = [ kGADSimulatorID, "ac772c88a5cdd8324566c05e63727702" ]
        interstitial.loadRequest(request)
    }
    
    func generateDefaultNumbers () {
        for i in 0 ..< self.countOfRow {
            let object = InitailNumbers(x: 0 + CGFloat(i) * sizeForEachVerticalRow +  sizeForEachVerticalRow / 2, scene: self)
            GameScene.arrayOfStartNumbers.append(object)
        }
    }
    
    func createRow () {
        for i in 0 ..< self.countOfRow {
            let row = SKSpriteNode()
            row.size = CGSize(width: sizeForEachVerticalRow - 5, height: self.frame.height)
            row.position = CGPoint(x: 0 + CGFloat(i) * sizeForEachVerticalRow + sizeForEachVerticalRow / 2, y: self.frame.height / 2 + self.sizeForEachVerticalRow)
            row.texture = SKTexture(imageNamed: "row_\(i+1)")
            row.zPosition = 4
            GameScene.arrayOfStartNumbers[i].firtsLabelShape.size = CGSize(width: sizeForEachVerticalRow - 5, height: sizeForEachVerticalRow / 2)
            
         //   GameScene.arrayOfStartNumbers[i].firtsLabelShape.fillColor = colorArray[i]

            GameScene.arrayOfStartNumbers[i].firtsLabelShape.color = colorArray[i]
            GameScene.arrayOfStartNumbers[i].secondLabelShape.fillColor = colorArray[i]
            GameScene.arrayOfStartNumbers[i].secondLabelShape.strokeColor = UIColor.clearColor()
            self.addChild(row)
        }
    }
    
    func setNextFallingNumbers(){
        for _ in  0 ..< self.countOfFallingNumbers * 2 {
            GameScene.nextNumber.append(FallingNumber(scene: self))
        }
    }
    
    var help: Bool = false
    var helpTime: CFTimeInterval = 0
    var prevHeplNumber: (Int, Int) = (-1, 0)
    var intervalTime: CFTimeInterval = 0
  
    override func update(currentTime: NSTimeInterval) {
        
        if !over {
            if !_start {
                startTime = currentTime
                intervalTime = currentTime
                _start = true
            }
            
            if currentTime - intervalTime >= Double(self.interval) {
                if GameScene.nextNumber.count  == self.countOfFallingNumbers * 2 {
                    if startNextNumber(self) {
                        self.intervalTime = currentTime
                    }
                    let nextNumber = getNextNumberForStart()
                    self.nextNumber.text = "\(GameScene.nextNumber[nextNumber].value)"
                }
            }
            
            
            if Int(currentTime - startTime) != 0 && Int(currentTime - startTime) % timerForHelp == 0 && !helpIsActive {
                helpIsActive = true
                helpTime = currentTime
            }
            
            if GameScene.nextNumber.count < self.countOfFallingNumbers * 2 {
                if ((self.level == "kid"  || self.level == "easy") && helpIsActive ) {
                    if (self.level == "easy" && currentTime - helpTime >= 40) || (self.level == "hard" && currentTime - helpTime >= 15) {
                        helpIsActive = false
                        helpTime = 0
                        startTime = currentTime
                    }
                    let helper = Helper(scene: self, prevNumber: prevHeplNumber)
                    GameScene.nextNumber.append(helper)
                    prevHeplNumber = (helper.rightRow.0, helper.value)
                    //prevHeplNumber
                } else {
                    GameScene.nextNumber.append(FallingNumber(scene: self))
                }
            }
        }
        
    }

    func getMenu() {
        self.addChild(menu)
        createMenuInScene(arrayOfValues, zPosition: 501)
    }
    
    func gameOver (text: String) {
        createMenuInScene(["Restart", "Main menu"], zPosition: 501)
        if GameViewController.sound {
          player.pause()   
        }
        self.addChild(menu)
        
        let restartButton = self.childNodeWithName("Restart_button")
        
        finallyGameStatus.text = text
        finallyGameStatus.fontName = "Helvetica-Bold"
        finallyGameStatus.zPosition = 600
        finallyGameStatus.position = CGPoint(x: self.frame.midX , y: restartButton!.position.y + restartButton!.frame.size.height / 2 + 10)
        self.addChild(finallyGameStatus)
        
        self.paused = true
        if interstitial.isReady &&  GameViewController.adBool.boolForKey("adBool") {
          //  interstitial.present(fromRootViewController: (self.view?.window?.rootViewController)!)
            interstitial.presentFromRootViewController((self.view?.window?.rootViewController!)!)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    func hideMenu () {
        self.deleteMenuFromScene(arrayOfValues)
        if GameViewController.sound {
           player.play()   
        }
        self.menu.removeFromParent()
    }
    
    /**************** here touches function ****************/
    var node: GameNumber! = nil
    var positionInArray: Int = 0
    var oldRow:Int = 0
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if node == nil {
            let touch = touches.first!
        
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            
            if touchedNode.name == "pause" {
                if GameViewController.sound {
                   player.pause()
                }
                self.getMenu()
                self.paused = true
                if interstitial.isReady && GameViewController.adBool.boolForKey("adBool") {
                    interstitial.presentFromRootViewController((self.view?.window?.rootViewController!)!)
                } else {
                    print("Ad wasn't ready")
                }
            } else if touchedNode.name == "Main menu_button" || touchedNode.name == "Main menu_label" {
                let btn = self.childNodeWithName("Main menu_button")
                self.paused = false
                let scene = MenuScene(size: self.size)
                let skView = self.view! as SKView
                presentNewScene(scene, skView: skView, button: btn!)
            } else if touchedNode.name == "Resume_button" || touchedNode.name == "Resume_label" {
                let btn = self.childNodeWithName("Resume_button")
                if GameViewController.sound {
                    btn!.runAction(sndButtonClick, completion: {
                        self.hideMenu()
                    })
                } else {
                    self.hideMenu()
                }
                self.paused = false
            } else if touchedNode.name == "Restart_button" || touchedNode.name == "Restart_label" {
                let btn = self.childNodeWithName("Restart_button")
                self.paused = false
                let scene = GameScene(size: self.size, countOfFallingNumbers: self.countOfFallingNumbers, fallingSpeed: self.fallingSpeed, interval: self.interval, countOfRow:self.countOfRow,  level: self.level, timerForHelp: self.timerForHelp)
                let skView = self.view! as SKView
                presentNewScene(scene, skView: skView, button: btn!)
            } else {
                let row = getRowByPosition(location.x, sizeForEachVerticalRow: self.sizeForEachVerticalRow)
                if let check = getNumberOnRow(row) {
                    node = check
                    node.catching = true
                    node.node.fillColor = UIColor(red: 0.9708690643, green: 0.4256429672, blue: 0.3027836084, alpha: 0.7542540668)
                  //  let sequence = SKAction.sequence([SKAction.scale(to: 1, duration: 5), SKAction.scale(to: 1, duration: 1)])
                  //  node.label.run(SKAction.repeatForever(sequence))
                }
            }
        }
    }
    
     func getNumberOnRow(row: Int) -> GameNumber? {
        var node: GameNumber? = nil
        var maxPosition = CGFloat(Int.max)
        for i in 0..<GameScene.nextNumber.count {
            if GameScene.nextNumber[i].start && GameScene.nextNumber[i].row.0 == row && GameScene.nextNumber[i].node.position.y < maxPosition {
                maxPosition = GameScene.nextNumber[i].node.position.y
                node = GameScene.nextNumber[i]
            }
        }
        return node
    }

    func findCatchingNumber () -> Int {
        for i in 0..<GameScene.nextNumber.count {
            if GameScene.nextNumber[i].catching {
                return i
            }
        }
        return -1
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent wiwithEventvent: UIEvent?) { // заперт второго тача, подумать!
        if !self.paused {
            let touch = touches.first!
            let location = touch.locationInNode(self)
            if node != nil {
                node.node.position.x = location.x
            } else {
                let newNumber = findCatchingNumber()
                if newNumber != -1 {
                    node = GameScene.nextNumber[newNumber]
                    node.node.position.x = location.x
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let newNumber = findCatchingNumber()
        if node != nil {
            let touch = touches.first!
            let location = touch.locationInNode(self)
            let newPosition = getNearestRowLocation(location.x, sizeForEachVerticalRow: self.sizeForEachVerticalRow, countOfRow: self.countOfRow)
            let newRow = getRowByPosition(newPosition, sizeForEachVerticalRow: self.sizeForEachVerticalRow)
         //   let action = SKAction.moveTo(newPosition, duration: 0.1)
            let action = SKAction.moveToX(newPosition, duration: 0.1)
            let oldRow = node.row.0
            node.node.fillColor = SKColor.clearColor()

            node.node.runAction(action, completion: {
                let number = self.findCatchingNumber()
                if number != -1 {
                    if GameViewController.sound {
                        let sound = SKAction.playSoundFileNamed("swipe\(oldRow).wav", waitForCompletion: false)
                        self.runAction(sound)
                    }
                    self.position.x = newPosition
                    GameScene.nextNumber[number].row = (newRow, newPosition)
                    GameScene.nextNumber[number].catching = false
                }
            })
            self.node = nil
        } else if node == nil && newNumber != -1 {
            let touch = touches.first!
            let location = touch.locationInNode(self)
            node = GameScene.nextNumber[newNumber]
            let newPosition = getNearestRowLocation(location.x, sizeForEachVerticalRow: self.sizeForEachVerticalRow, countOfRow: self.countOfRow)
            let newRow = getRowByPosition(newPosition, sizeForEachVerticalRow: self.sizeForEachVerticalRow)
            //let action = SKAction.moveTo(newPosition, duration: 0.1)
            let action = SKAction.moveToX(newPosition, duration: 0.1)

            let oldRow = node.row.0
            node.node.fillColor = SKColor.clearColor()
            node.node.runAction(action, completion: {
                let number = self.findCatchingNumber()
                if number != -1 {
                    if GameViewController.sound {
                        let sound = SKAction.playSoundFileNamed("swipe\(oldRow).wav", waitForCompletion: false)
                        self.runAction(sound)
                    }
                    self.position.x = newPosition
                    GameScene.nextNumber[number].row = (newRow, newPosition)
                    GameScene.nextNumber[number].catching = false
                }
            })
            self.node = nil
        }
    }
    
    // **** sound ****
    func playSound (){
      //  let url = Bundle.main.url(forResource: "intro+repeat.wav", withExtension: nil)
     //   NSBundle.mainBundle().URLForResource(<#T##name: String?##String?#>, withExtension: <#T##String?#>)
        let url =  NSBundle.mainBundle().URLForResource("intro+repeat.wav", withExtension: nil)
        var error: NSError? = nil
        do {
            player = try AVAudioPlayer(contentsOfURL: url!)
        } catch let error1 as NSError {
            error = error1
        }
        if (error == nil) {
            player.delegate = self
            player.numberOfLoops = 0
            player.prepareToPlay()
            player.play()
        } else {
            print("Could not create audio player: \(error!)")
        }
        
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool){
        if flag {
           // let url = Bundle.main.url(forResource: "repeat.wav", withExtension: nil)
             let url =  NSBundle.mainBundle().URLForResource("repeat.wav", withExtension: nil)
            
            var error: NSError? = nil
            do {
                self.player = try AVAudioPlayer(contentsOfURL: url!)
            } catch let error1 as NSError {
                error = error1
            }
            if (error == nil) {
                self.player.delegate = self
                self.player.numberOfLoops = -1
                self.player.prepareToPlay()
                self.player.play()
            } else {
                print("Could not create audio player: \(error!)")
            }
        }
    }
}
