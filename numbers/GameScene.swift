import SpriteKit
import AVFoundation


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
    
    
    
    init(size: CGSize, countOfFallingNumbers: Int, fallingSpeed: Double, interval: Int, countOfRow: Int, level: String, timerForHelp: Int) {
        super.init(size: size)
        self.isPaused = false
        self.sizeForEachVerticalRow = self.frame.width / CGFloat(countOfRow)
        self.helpIsActive = false
        
        self.countOfRow = countOfRow
        self.countOfFallingNumbers = countOfFallingNumbers
        self.fallingSpeed = fallingSpeed
        self.interval = interval
        self.level = level
        self.timerForHelp = timerForHelp
        
        colorArray.removeAll()
        GameScene.arrayOfStartNumbers.removeAll()
        GameScene.nextNumber.removeAll()
    
        colorArray.append(#colorLiteral(red: 0.3960784314, green: 0.7137254902, blue: 0.8470588235, alpha: 1))
        colorArray.append(#colorLiteral(red: 0.8588235294, green: 0.7215686275, blue: 0.5098039216, alpha: 1))
        colorArray.append(#colorLiteral(red: 0.8156862745, green: 0.5333333333, blue: 0.5803921569, alpha: 1))
        colorArray.append(#colorLiteral(red: 0.3607843137, green: 0.6, blue: 0.568627451, alpha: 1))
        colorArray.append(#colorLiteral(red: 0.7607843137, green: 0.368627451, blue: 0.368627451, alpha: 1))
        
        generateDefaultNumbers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var intervalCounter = 0
    var startTime: TimeInterval = 0
    
    let menu = SKSpriteNode()
    let nextNumber = SKLabelNode()
    let finallyGameStatus = SKLabelNode()
    let sndButtonClick = SKAction.playSoundFileNamed("menu_click.wav", waitForCompletion: false)
    let intro = SKAction.playSoundFileNamed("intro+repeat.wav", waitForCompletion: true)

  //  let audio =  SKTAudio.sharedInstance()
    
    
    let arrayOfValues = ["Main menu", "Resume", "Restart"]
    
    override func didMove(to view: SKView) {
        
        let backgroundNode = SKSpriteNode(imageNamed: "background")
        backgroundNode.size = self.frame.size
        backgroundNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        backgroundNode.zPosition = 0
        
        let pause = SKSpriteNode()
        pause.size  = CGSize(width: 30, height: 30)
        pause.position =  CGPoint(x: pause.frame.width / 2 + 5, y: self.frame.height - pause.frame.height / 2 - 5)
        pause.name = "pause"
        pause.texture = SKTexture(imageNamed: "pause")
        pause.zPosition = 10
    
        let nextNumberShape = SKSpriteNode()
        nextNumberShape.size = CGSize(width: 100, height: 100)
        nextNumberShape.position = CGPoint(x: self.frame.width, y: self.frame.height)
        nextNumberShape.texture = SKTexture(imageNamed: "next_number")
        nextNumberShape.zPosition = 10
        
        self.nextNumber.text = "3"
        self.nextNumber.fontColor = #colorLiteral(red: 0.5233821869, green: 0.6451161504, blue: 0.6273553371, alpha: 1)
        self.nextNumber.zPosition = 11
        self.nextNumber.fontSize = 20
        
        // TODO:: доделать позиционирование
        self.nextNumber.position = CGPoint(x: -nextNumber.frame.width - self.nextNumber.frame.width / 2, y:  -nextNumber.frame.height - self.nextNumber.frame.height / 2)
        
        nextNumberShape.addChild(self.nextNumber)
        
        menu.zPosition = 500
        menu.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2981057363)
        menu.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        menu.size = CGSize(width: self.frame.width, height: self.frame.height)
        
        createRow()
        setNextFallingNumbers()
        
        GameScene.nextNumber[0].start(self)
        GameScene.nextNumber[0].start = true
        
        
        
        self.addChild(nextNumberShape)
        self.addChild(pause)
        self.addChild(backgroundNode)
        
      
        playSound()
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
            row.position = CGPoint(x: 0 + CGFloat(i) * sizeForEachVerticalRow + sizeForEachVerticalRow / 2, y: self.frame.height / 2 + self.sizeForEachVerticalRow + 25)
            row.texture = SKTexture(imageNamed: "row_\(i+1)")
            row.zPosition = 4
            GameScene.arrayOfStartNumbers[i].firtsLabelShape.size = CGSize(width: sizeForEachVerticalRow - 5, height: sizeForEachHorizontalRow + 20)
            GameScene.arrayOfStartNumbers[i].firtsLabelShape.texture = SKTexture(imageNamed: "row_down_\(i + 1)")
            GameScene.arrayOfStartNumbers[i].secondLabelShape.fillColor = colorArray[i]
            GameScene.arrayOfStartNumbers[i].secondLabelShape.strokeColor = UIColor.clear()
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
  
    override func update(_ currentTime: TimeInterval) {
        
        if !_start {
            startTime = currentTime
            _start = true
        }
        
        self.intervalCounter += 1
        if self.intervalCounter >= self.interval {
            if GameScene.nextNumber.count == self.countOfFallingNumbers * 2 {
                if startNextNumber(scene: self) {
                    self.intervalCounter = 0
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

    func getMenu() {
        self.addChild(menu)
        createMenuInScene(arrayOfValues, zPosition: 501)
    }
    
    func gameOver () {
        player.pause()
        self.addChild(menu)
        createMenuInScene(["Restart", "Main menu"], zPosition: 501)
        finallyGameStatus.text = "GAME OVER"
        self.isPaused = true
    }
    
    func hideMenu () {
        self.deleteMenuFromScene(arrayOfValues)
        player.play()
        self.menu.removeFromParent()
    }
    
    /**************** here touches function ****************/
    var node: GameNumber! = nil
    var positionInArray: Int = 0
    var oldRow:Int = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if node == nil {
            let touch = touches.first!
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            
            if touchedNode.name == "pause" {
                player.pause()
                self.getMenu()
                self.isPaused = true
            } else if touchedNode.name == "Main menu_button" || touchedNode.name == "Main menu_label" {
                self.isPaused = false
                let btn = self.childNode(withName: "Main menu_button")
                btn!.run(sndButtonClick, completion: {
                    let scene = MenuScene(size: self.size)
                    let skView = self.view! as SKView
                    scene.size = skView.bounds.size
                    scene.scaleMode = .aspectFill
                    skView.presentScene(scene)
                })
            } else if touchedNode.name == "Resume_button" || touchedNode.name == "Resume_label" {
                self.isPaused = false
                let btn = self.childNode(withName: "Resume_button")
                btn!.run(sndButtonClick, completion: {
                    self.hideMenu()
                    self.isPaused = false
                })
            } else if touchedNode.name == "Restart_button" || touchedNode.name == "Restart_label" {
                self.isPaused = false
                let btn = self.childNode(withName: "Restart_button")
                btn!.run(sndButtonClick, completion: {
                    let scene = GameScene(size: self.size, countOfFallingNumbers: self.countOfFallingNumbers, fallingSpeed: self.fallingSpeed, interval: self.interval, countOfRow:self.countOfRow,  level: self.level, timerForHelp: self.timerForHelp)
                    let skView = self.view! as SKView
                    scene.size = skView.bounds.size
                    scene.scaleMode = .aspectFill
                    skView.presentScene(scene)
                })
           
            } else {
                let row = getRowByPosition(location.x, sizeForEachVerticalRow: self.sizeForEachVerticalRow)
                if let check = getNumberOnRow(row: row) {
                    node = check
                    node.catching = true
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
    
    /*   override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if node != nil {
            let touch = touches.first!
            let location = touch.location(in: self)
            let newPosition = getNearestRowLocation(location.x, sizeForEachVerticalRow: self.sizeForEachVerticalRow, countOfRow: self.countOfRow)
            let action = SKAction.moveTo(x: newPosition, duration: 0.1)
            node.node.run(action)
            //node = nil
        }
    }*/
    
    func findCatchingNumber () -> Int {
        for i in 0..<GameScene.nextNumber.count {
            if GameScene.nextNumber[i].catching {
                return i
            }
        }
        return -1
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if node != nil {
            let touch = touches.first!
            let location = touch.location(in: self)
            let newPosition = getNearestRowLocation(location.x, sizeForEachVerticalRow: self.sizeForEachVerticalRow, countOfRow: self.countOfRow)
            let newRow = getRowByPosition(newPosition, sizeForEachVerticalRow: self.sizeForEachVerticalRow)
            let action = SKAction.moveTo(x: newPosition, duration: 0.1)
            
            node.node.run(action, completion: {
                self.position.x = newPosition
                let number = self.findCatchingNumber()
                GameScene.nextNumber[number].row = (newRow, newPosition)
                GameScene.nextNumber[number].catching = false
                self.node = nil
            })
        }
    }
    
 /*  func getCurrentNumber(row: Int) -> (SKNode?, Int, Int) {
        var maxPosition = self.frame.height * 2
        var positionInArray = 0
        var node: SKNode? = nil
        var oldRow: Int = 0
        for i in 0 ..< GameScene.nextNumber.count {
            if GameScene.nextNumber[i].start && GameScene.nextNumber[i].row.0 == row && GameScene.nextNumber[i].node.position.y < maxPosition {
                maxPosition = GameScene.nextNumber[i].node.position.y
                node = GameScene.nextNumber[i].node
                positionInArray = i
                oldRow = GameScene.nextNumber[i].row.0
            }
        }
        return (node, positionInArray, oldRow)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { // TODO:: reset
        if node != nil {
            let touch = touches.first!
            let location = touch.location(in: self)
            if node != nil   {
                
                let label = node.children[0] as! SKLabelNode
                node.removeAllActions()
                
                
                //let changeRowAnimation  = SKAction.move(to: CGPoint(x: location.x, y: node.position.y), duration: 50)
                //node.run(changeRowAnimation)
                node.position.x = location.x
                
                let remainingDistance = node.position.y - GameScene.arrayOfStartNumbers[0].secondLabelShape.position.y
                let time = Double(remainingDistance) / self.fallingSpeed
                
                
                let fallAction = SKAction.move(to: CGPoint(x: node.position.x, y: GameScene.arrayOfStartNumbers[0].secondLabelShape.position.y), duration: time)
                
                node.run(fallAction, completion: {
                    let newPosition = getNearestRow(location.x, sizeForEachVerticalRow: self.sizeForEachVerticalRow, countOfRow: self.countOfRow)
                    let newRow = getRowByPosition(self.node.position.x, sizeForEachVerticalRow: self.sizeForEachVerticalRow)
                    self.node.position.x = newPosition
                    GameScene.nextNumber[self.positionInArray].row = (newRow, newPosition)
                    GameScene.arrayOfStartNumbers[newRow].refreshValue(self.node.getValue(label.text!), scene: self)
                    self.node.destroy()
                    self.node = nil
                });
            }
        }
    }
    
    func cancelAnimation()  {
        print ("!")
    }
    
    // TODO:: bug fix
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (node != nil) {
            
            let touch = touches.first!
            let location = touch.location(in: self)
         
            node.removeAllActions()
            var newPosition = getNearestRow(location.x, sizeForEachVerticalRow: self.sizeForEachVerticalRow, countOfRow: self.countOfRow)
            var row = getRowByPosition(newPosition, sizeForEachVerticalRow: self.sizeForEachVerticalRow)
    
            let nodeOnCurrentRow = getCurrentNumber(row: row)
            if (nodeOnCurrentRow.0 != nil){
                if (nodeOnCurrentRow.0!.position.y - node.position.y >= -30 && nodeOnCurrentRow.0!.position.y - node.position.y <= 30){
                    let newRow = oldRow - row
                    if newRow > 0 && row != self.countOfRow - 1{
                        row += 1
                    } else if newRow < 0 && row != 0{
                        row -= 1
                    } else {
                        if row == 0{
                            row += 1
                        } else {
                            row -= 1
                        }
                    }
                    newPosition = getPositionByRow(row, sizeForEachVerticalRow: self.sizeForEachVerticalRow)
                }
            }
            node.position.x = newPosition
            GameScene.nextNumber[self.positionInArray].row = (row, newPosition)
            let label = self.node.children[0] as! SKLabelNode
            let value = self.node.getValue(label.text!)
            //  print ("Position: \(newPosition), Row: \(row), Value: \(value))")
            let remainingDistance = self.node.position.y - GameScene.arrayOfStartNumbers[0].secondLabelShape.position.y
            let time = Double(remainingDistance) / self.fallingSpeed
            self.node.refreshFallingAnimation(row: (row, self.node.position.x), value: value, yPosition: self.node.position.y, time: time, scene: self)
            self.node = nil
        
        }
    } */
    
    
    
    
    // **** sound ****
    
    func playSound (){
        let url = Bundle.main.urlForResource("intro+repeat.wav", withExtension: nil)
        var error: NSError? = nil
        do {
            player = try AVAudioPlayer(contentsOf: url!)
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
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        if flag {
            let url = Bundle.main.urlForResource("repeat.wav", withExtension: nil)
            var error: NSError? = nil
            do {
                self.player = try AVAudioPlayer(contentsOf: url!)
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
