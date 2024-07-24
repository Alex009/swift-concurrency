import Foundation
import MD5Hash

var result = [String]()

let start = CFAbsoluteTimeGetCurrent()

let concurrentQueue = DispatchQueue(label: "ru.sergeipanov.concurrent-queue", attributes: .concurrent)

let group = DispatchGroup()

func addNewItem() {
    for _ in 1...100 {
        concurrentQueue.async(group: group) {
            let hash = generateMD5Hash(strings: result)
            
            var newResult = result
            newResult.append(hash)
            result = newResult
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

// review:
// верно. хотя строки 24-26 странные
