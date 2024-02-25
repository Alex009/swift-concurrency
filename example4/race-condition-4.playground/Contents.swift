import UIKit
import Atomics

var result = ManagedAtomic<Int>(0)

func increment() {
    result.wrappingIncrement(by: 1, ordering: .relaxed)
}

func decrement() {
    result.wrappingDecrement(by: 1, ordering: .relaxed)
}

let firstConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.first-concurrent-queue", attributes: .concurrent)
let secondConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.second-concurrent-queue", attributes: .concurrent)

let group = DispatchGroup()

for _ in 1...100 {
    firstConcurrentQueue.async(group: group, execute: increment)
    secondConcurrentQueue.async(group: group, execute: decrement)
}

group.notify(queue: DispatchQueue.main) {
    print(result.load(ordering: .relaxed))
}

RunLoop().run()
