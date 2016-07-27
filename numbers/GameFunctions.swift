import SpriteKit

func generateDefaultNumbers (_ sizeOfEachRow: CGFloat) {
    for i in 0 ..< self.countOfRow {
        let firstRowRandomNumber = randomInt(-10, max: 10)
        var secondRowRandomNumber = randomInt(-15, max: 15)
        if firstRowRandomNumber == secondRowRandomNumber {
            if secondRowRandomNumber == -15 {
                secondRowRandomNumber += 1
            } else if secondRowRandomNumber == 15 {
                secondRowRandomNumber -= 1
            } else {
                secondRowRandomNumber += 1
            }
        }
        let object = InitailNumbers(firstRowNumber: firstRowRandomNumber, secondRowNumber: secondRowRandomNumber, x: 0 + CGFloat(i) * sizeForEachVerticalRow +  sizeForEachVerticalRow / 2, sizeForEachVerticalRow: self.sizeForEachVerticalRow, scene: self)
        GameScene.arrayOfStartNumbers.append(object)
    }
}
