import UIKit

var result: Int = 0

let incrementConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.increment-concurrent-queue", attributes: .concurrent)
let decrementConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.decrement-concurrent-queue", attributes: .concurrent)

let group = DispatchGroup()

let semaphore = DispatchSemaphore(value: 1)

func increment() {
    for _ in 1...100 {
        incrementConcurrentQueue.async(group: group) {
            semaphore.wait()
            
            result = result + 1
            
            semaphore.signal()
        }
    }
}

func decrement() {
    for _ in 1...100 {
        decrementConcurrentQueue.async(group: group) {
            semaphore.wait()
            
            result = result - 1
            
            semaphore.signal()
        }
    }
}

increment()
decrement()

group.notify(queue: DispatchQueue.main) {
    print(result)
}

RunLoop().run()

// review:
// задача решена корректно.
// для практики - придумай задачу, в которой будет нужно использовать у семафора лимит не 1, а больше?
