import UIKit
import MD5Hash

var result = [String]()

let start = CFAbsoluteTimeGetCurrent()

let concurrentQueue = DispatchQueue(label: "ru.sergeipanov.concurrent-queue", attributes: .concurrent)

let group = DispatchGroup()
let semaphore = DispatchSemaphore(value: 1)

func addNewItem() {
    for _ in 1...100 {
        concurrentQueue.async(group: group) {
            semaphore.wait()
            
            let hash = generateMD5Hash(strings: result)
            
            var newResult = result
            newResult.append(hash)
            result = newResult
            
            semaphore.signal()
        }
    }
}

for _ in 1...10 {
    addNewItem()
}

group.notify(queue: DispatchQueue.main) {
    print("Result: \(result.last ?? "")")
    let diff = CFAbsoluteTimeGetCurrent() - start
    print("Time spent: \(diff) seconds")
}

RunLoop().run()
