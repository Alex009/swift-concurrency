import UIKit

var result: Int = 0

let counterConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.counter-concurrent-queue", attributes: .concurrent)

let incrementConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.increment-concurrent-queue", attributes: .concurrent)
let decrementConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.decrement-concurrent-queue", attributes: .concurrent)

let group = DispatchGroup()

func increment() {
    for _ in 1...100 {
        counterConcurrentQueue.async(flags: .barrier) {
            result = result + 1
        }
    }
}

func decrement() {
    for _ in 1...100 {
        counterConcurrentQueue.async(flags: .barrier) {
            result = result - 1
        }
    }
}

incrementConcurrentQueue.async(group: group) {
    increment()
}
decrementConcurrentQueue.async(group: group) {
    decrement()
}

group.notify(queue: DispatchQueue.main) {
    print(result)
}

RunLoop().run()

