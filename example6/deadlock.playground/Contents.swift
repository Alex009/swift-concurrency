import UIKit

var redArmyCount: Int = 1000
var blueArmyCount: Int = 1000

let redConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.red-concurrent-queue", attributes: .concurrent)
let blueConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.blue-concurrent-queue", attributes: .concurrent)

let redArmySemaphore = DispatchSemaphore(value: 1)
let blueArmySemaphore = DispatchSemaphore(value: 1)
let group = DispatchGroup()

redConcurrentQueue.async(group: group) {
    blueArmySemaphore.wait()
    
    let redArmyShootCount = redArmyCount / 2
    
    blueArmyCount = blueArmyCount - redArmyShootCount
    
    redArmySemaphore.wait()
    
    let redArmyChildren = redArmyCount / 4
    redArmyCount = redArmyCount + redArmyChildren
    
    redArmySemaphore.signal()
    
    blueArmySemaphore.signal()
}

blueConcurrentQueue.async(group: group) {
    redArmySemaphore.wait()
    
    let blueArmyShootCount = blueArmyCount / 2
    
    redArmyCount = redArmyCount - blueArmyShootCount
    
    blueArmySemaphore.wait()
    
    let blueArmyChildren = blueArmyCount / 4
    blueArmyCount = blueArmyCount + blueArmyChildren
    
    blueArmySemaphore.signal()
    
    redArmySemaphore.signal()
}

group.notify(queue: DispatchQueue.main) {
    print("blue army survived count = \(blueArmyCount)")
    print("red army survived count = \(redArmyCount)")
}

RunLoop().run()
