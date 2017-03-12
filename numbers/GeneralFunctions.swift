/*
 *  Общие функции, в основном определение строк и положение node
 */



import SpriteKit
import Foundation
import SystemConfiguration


public class Reachability {
  
    /*class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
    
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
    //        SCNetworkReachabilityCreateWithName(nil, UnsafePointer())
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
        /*   var status:Bool = false
        
        let url = NSURL(string: "http://google.com")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "HEAD"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response:URLResponse?
        
       
         _ = try! NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response) as NSData?
       
        
        
       // _ = NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                status = true
            }
        }
        
        return status*/
    
    }*/


}

let sndButtonClick = SKAction.playSoundFileNamed("menu_click1.wav", waitForCompletion: false)

func randomInt(min: Int, max: Int) -> Int {
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
        GameScene.nextNumber[next].start(scene: scene)
        GameScene.nextNumber[next].start = true
        return true
    }
    return false
}

func getRowByPosition (position: CGFloat, sizeForEachVerticalRow: CGFloat) -> Int {
    return Int(position / sizeForEachVerticalRow)
}

func getPositionByRow (row:Int, sizeForEachVerticalRow: CGFloat) -> CGFloat {
    let position = CGFloat(row) * sizeForEachVerticalRow +  sizeForEachVerticalRow / 2
    return position
}


func getNearestRowLocation (position: CGFloat, sizeForEachVerticalRow: CGFloat, countOfRow: Int) -> CGFloat {
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

func presentNewScene (scene: SKScene, skView: SKView, button: SKNode) {
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



