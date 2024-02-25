import UIKit

var result: Int = 0

func increment() {
    result = result + 1
}

func decrement() {
    result = result - 1
}

let concurrentQueue = DispatchQueue(label: "ru.sergeipanov.first-concurrent-queue", attributes: .concurrent)
//let secondConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.second-concurrent-queue", attributes: .concurrent)

for _ in 1...100 {
    concurrentQueue.async(flags: .barrier, execute: increment)
    concurrentQueue.async(flags: .barrier, execute: decrement)
}

print(result)

RunLoop().run()
