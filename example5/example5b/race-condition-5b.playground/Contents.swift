import UIKit
import MD5Hash

var result = [String]()

let start = CFAbsoluteTimeGetCurrent()

let concurrentQueue = DispatchQueue(label: "ru.sergeipanov.concurrent-queue", attributes: .concurrent)

func addNewItem() {
    let hash = generateMD5Hash(strings: result)
    
    var newResult = result
    newResult.append(hash)
    result = newResult
}

for _ in 1...100 {
    concurrentQueue.async(flags: .barrier, execute: addNewItem)
}

concurrentQueue.sync {
    print("Result: \(result.last ?? "")")
    let diff = CFAbsoluteTimeGetCurrent() - start
    print("Time spent: \(diff) seconds")
}

RunLoop().run()
