import UIKit

var result: Int = 0

let incrementConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.increment-concurrent-queue", attributes: .concurrent)
let decrementConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.decrement-concurrent-queue", attributes: .concurrent)

let group = DispatchGroup()

func increment() {
    for _ in 1...100 {
        incrementConcurrentQueue.async(group: group) {
            result = result + 1
        }
    }
}

func decrement() {
    for _ in 1...100 {
        decrementConcurrentQueue.async(group: group) {
            result = result - 1
        }
    }
}

increment()
decrement()

group.notify(queue: DispatchQueue.main) {
    print(result)
}

RunLoop().run()
