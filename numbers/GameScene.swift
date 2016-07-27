import SpriteKit
import ObjectiveC

class GameScene: SKScene {
    
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
   
    let arrayOfValues = ["Main menu", "Resume", "Restart"]
    
    override func didMove(to view: SKView) {
        
        let backgroundNode = SKSpriteNode(imageNamed: "background_default")
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
        createMenuInScene(["Restart", "Main menu"], zPosition: 501)
        finallyGameStatus.text = "GAME OVER"
        self.isPaused = true
    }
    
    func hideMenu () {
        self.deleteMenuFromScene(arrayOfValues)
        self.menu.removeFromParent()
    }
    
    /**************** here touches function ****************/
    var node: SKNode! = nil
    var positionInArray: Int = 0
    var oldRow:Int = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if node == nil {
            let touch = touches.first!
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            
            if touchedNode.name == "pause" {
                self.getMenu()
                self.isPaused = true
            } else if touchedNode.name == "Main menu_button" || touchedNode.name == "Main menu_label" {
                let scene = MenuScene(size: self.size)
                let skView = self.view! as SKView
                scene.size = skView.bounds.size
                scene.scaleMode = .aspectFill
                skView.presentScene(scene)
            } else if touchedNode.name == "Resume_button" || touchedNode.name == "Resume_label" {
                self.hideMenu()
                self.isPaused = false
            } else if touchedNode.name == "Restart_button" || touchedNode.name == "Restart_label" {
                let scene = GameScene(size: self.size, countOfFallingNumbers: self.countOfFallingNumbers, fallingSpeed: self.fallingSpeed, interval: self.interval, countOfRow:self.countOfRow,  level: self.level, timerForHelp: self.timerForHelp)
                let skView = self.view! as SKView
                scene.size = skView.bounds.size
                scene.scaleMode = .aspectFill
                skView.presentScene(scene)
            } else {
                let row = getRowByPosition(location.x, sizeForEachVerticalRow: self.sizeForEachVerticalRow)
                let currentNumber = getCurrentNumber(row: row)
                node = currentNumber.0
                positionInArray = currentNumber.1
                oldRow = currentNumber.2
            }
        }
    }
    
    func getCurrentNumber(row: Int) -> (SKNode?, Int, Int) {
        var maxPosition = self.frame.height
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
                node.position.x = location.x
                let remainingDistance = node.position.y - GameScene.arrayOfStartNumbers[0].secondLabelShape.position.y
                let time = Double(remainingDistance) / self.fallingSpeed
                let fallAction = SKAction.move(to: CGPoint(x: node.position.x, y: GameScene.arrayOfStartNumbers[0].secondLabelShape.position.y), duration: time)
                node.run(fallAction, completion: {
                    let newPosition = getNearestRow(self.node.position.x, sizeForEachVerticalRow: self.sizeForEachVerticalRow, countOfRow: self.countOfRow)
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
    
    // TODO:: bug fix
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (node != nil) {
            node.removeAllActions()
            var newPosition = getNearestRow(node.position.x, sizeForEachVerticalRow: self.sizeForEachVerticalRow, countOfRow: self.countOfRow)
            var row = getRowByPosition(newPosition, sizeForEachVerticalRow: self.sizeForEachVerticalRow)
                  //    print ("Row: \(row)")
            //var newPosition = getPositionByRow(row, sizeForEachVerticalRow: self.sizeForEachVerticalRow)
            let nodeOnCurrentRow = getCurrentNumber(row: row)
            if (nodeOnCurrentRow.0 != nil){
                if (nodeOnCurrentRow.0!.position.y - node.position.y >= -20 && nodeOnCurrentRow.0!.position.y - node.position.y <= 20){
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
            GameScene.nextNumber[positionInArray].row = (row, newPosition)
            let label = node.children[0] as! SKLabelNode
            let value = node.getValue(label.text!)
            print ("Position: \(newPosition), Row: \(row), Value: \(value))")
            let remainingDistance = node.position.y - GameScene.arrayOfStartNumbers[0].secondLabelShape.position.y
            let time = Double(remainingDistance) / self.fallingSpeed
            node.refreshFallingAnimation(row: (row, node.position.x), value: value, yPosition: node.position.y, time: time, scene: self)
            node = nil
        }
    }
}
