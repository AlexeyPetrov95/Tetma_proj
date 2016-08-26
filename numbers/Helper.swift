import SpriteKit

class Helper: GameNumber {

    var rightRow:(Int, CGFloat) = (0, 0)
    init (scene: GameScene, prevNumber: (Int, Int)) {
        super.init()
        
        self.rightRow.0 = self.getRowFotNextCorrectNumber(scene.countOfRow)
        self.value = self.getNextCorrectValue(prevNumber)
        self.row = setRandomRow(scene.sizeForEachVerticalRow)
        self.label.fontName = "Helvetica-Bold"
        self.label.text = String(self.value)
        self.node.position = CGPoint(x: self.row.1, y: scene.frame.height)
        self.label.text = String(self.value)
        self.label.position = CGPoint(x: 0 , y: 0 - self.label.frame.height / 2)
        self.time = Double(scene.frame.height - GameScene.arrayOfStartNumbers[0].secondLabelShape.position.y) / scene.fallingSpeed
        node.addChild(self.label)
    }
    
    func randomDevider () -> Int {
        let number = 2 + Int(arc4random_uniform(UInt32(5 - 1 + 2)))
        return number
    }
    
    func getRowFotNextCorrectNumber (countOfRow: Int) -> Int { // тут через рандом
        let randomRow = randomInt(0, max: countOfRow - 1)
        if GameScene.arrayOfStartNumbers[randomRow].firstRowNumber != GameScene.arrayOfStartNumbers[randomRow].secondRowNumber {
            return randomRow
        } else {
            for i in 0..<GameScene.arrayOfStartNumbers.count {
                if GameScene.arrayOfStartNumbers[i].firstRowNumber != GameScene.arrayOfStartNumbers[i].secondRowNumber {
                    return i
                }
            }
        }
        return -1
    }
    
    func getNextCorrectValue (prevNumber: (Int, Int)) -> Int {
        
        
        if self.rightRow.0 == -1 {
            return 0
        }
        
        let firstValue = GameScene.arrayOfStartNumbers[self.rightRow.0].firstRowNumber
        let secondValue = GameScene.arrayOfStartNumbers[self.rightRow.0].secondRowNumber
        
        var difference = 0
        
        if prevNumber.0 != -1 {
            if ((firstValue - secondValue) >= -5 && (firstValue - secondValue) <= 5) && prevNumber.0 != self.rightRow.0 {
                difference = firstValue - secondValue
            } else if ((firstValue - secondValue) >= -5 && (firstValue - secondValue) <= 5) && prevNumber.0 == self.rightRow.0 {
                difference = firstValue - secondValue - prevNumber.1
            } else {
                let devider = randomDevider()
                difference = (firstValue - secondValue) / devider
            }
        } else {
            if ((firstValue - secondValue) >= -5 && (firstValue - secondValue) <= 5) {
                difference = firstValue - secondValue
            } else if ((firstValue - secondValue) >= -5 && (firstValue - secondValue) <= 5) {
                difference = firstValue - secondValue - prevNumber.1
            } else {
                let devider = randomDevider()
                difference = (firstValue - secondValue) / devider
            }
        }
        return difference
    }
}
