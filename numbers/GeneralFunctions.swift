import SpriteKit

let sndButtonClick = SKAction.playSoundFileNamed("menu_click.wav", waitForCompletion: false)

func randomInt(_ min: Int, max: Int) -> Int {
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

func getNextNumberForStart () -> Int {
    for i in 0 ..< GameScene.nextNumber.count {
        if !GameScene.nextNumber[i].start {
            return i
        }
    }
    return 0
}

func getCountOfFallingNumbers () -> Int {
    var counter = 0
    for i in 0 ..< GameScene.nextNumber.count {
        if GameScene.nextNumber[i].start {
            counter += 1
        }
    }
    return counter
}

func startNextNumber(scene: GameScene ) -> Bool{
    let counter = getCountOfFallingNumbers()
    if counter < scene.countOfFallingNumbers {
        let next = getNextNumberForStart()
        GameScene.nextNumber[next].start(scene)
        GameScene.nextNumber[next].start = true
        return true
    }
    return false
}

func getRowByPosition (_ position: CGFloat, sizeForEachVerticalRow: CGFloat) -> Int {
    return Int(position / sizeForEachVerticalRow)
}

func getPositionByRow (_ row:Int, sizeForEachVerticalRow: CGFloat) -> CGFloat {
    let position = CGFloat(row) * sizeForEachVerticalRow +  sizeForEachVerticalRow / 2
    return position
}


func getNearestRowLocation (_ position: CGFloat, sizeForEachVerticalRow: CGFloat, countOfRow: Int) -> CGFloat {
    var rowPosition:CGFloat = 0
    var diff:CGFloat = CGFloat.greatestFiniteMagnitude
    for i in 0..<countOfRow {
        if abs(position - (CGFloat(i) * sizeForEachVerticalRow + sizeForEachVerticalRow / 2)) < diff {  // условие
            diff = abs(position - (CGFloat(i) * sizeForEachVerticalRow +  sizeForEachVerticalRow / 2))
            rowPosition = CGFloat(i) * sizeForEachVerticalRow + sizeForEachVerticalRow / 2
        }
    }
    return rowPosition
}

func presentNewScene (_ scene: SKScene, skView: SKView, button: SKNode) {
    scene.size = skView.bounds.size
    scene.scaleMode = .aspectFill
    if GameViewController.sound  {
        button.run(sndButtonClick, completion: {
            skView.presentScene(scene)
        })
    } else {
        skView.presentScene(scene)
    }
}



