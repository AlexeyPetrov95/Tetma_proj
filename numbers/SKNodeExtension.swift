import SpriteKit

extension SKNode {
    
    func fallingAnimation (row:(Int, CGFloat), value: Int, time: Double, scene: GameScene){
        let fallAction = SKAction.moveTo(y: GameScene.arrayOfStartNumbers[0].secondLabelShape.position.y, duration: time)
        self.run(fallAction, completion: {
            let newPosition = getNearestRowLocation(self.position.x, sizeForEachVerticalRow: scene.sizeForEachVerticalRow, countOfRow: scene.countOfRow)
            let newRow = getRowByPosition(newPosition, sizeForEachVerticalRow: scene.sizeForEachVerticalRow)
            GameScene.arrayOfStartNumbers[newRow].refreshValue(value, scene: scene)
            scene.node = nil
            self.destroy()
        });
    }
    
    func getValue (_ text: String) -> Int {
        let value = Int(text)
        return value!
    }
    
    func destroy () {
        self.removeAllActions()
        self.removeFromParent()
        GameScene.nextNumber.removeFirst()
    }
}
