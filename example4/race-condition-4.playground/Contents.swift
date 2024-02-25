import UIKit
import Atomics

var result = ManagedAtomic<Int>(0)

let incrementConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.increment-concurrent-queue", attributes: .concurrent)
let decrementConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.decrement-concurrent-queue", attributes: .concurrent)

let group = DispatchGroup()

func increment() {
    for _ in 1...100 {
        incrementConcurrentQueue.async(group: group) {
            result.wrappingIncrement(by: 1, ordering: .relaxed)
        }
    }
}

func decrement() {
    for _ in 1...100 {
        decrementConcurrentQueue.async(group: group) {
            result.wrappingDecrement(by: 1, ordering: .relaxed)
        }
    }
}

increment()
decrement()


group.notify(queue: DispatchQueue.main) {
    print(result.load(ordering: .relaxed))
}

RunLoop().run()
