import UIKit

var result: Int = 0

func increment() {
    result = result + 1
}

func decrement() {
    result = result - 1
}

let firstConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.first-concurrent-queue", attributes: .concurrent)
let secondConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.second-concurrent-queue", attributes: .concurrent)

for _ in 1...100 {
    firstConcurrentQueue.async(execute: increment)
    secondConcurrentQueue.async(execute: decrement)
}

print(result)

RunLoop().run()
