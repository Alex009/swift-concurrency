import UIKit
import MD5Hash

var result = [String]()

let start = CFAbsoluteTimeGetCurrent()

let concurrentQueue1 = DispatchQueue(label: "ru.sergeipanov.concurrent-queue-1", attributes: .concurrent)
let concurrentQueue2 = DispatchQueue(label: "ru.sergeipanov.concurrent-queue-2", attributes: .concurrent)
let concurrentQueue3 = DispatchQueue(label: "ru.sergeipanov.concurrent-queue-3", attributes: .concurrent)
let concurrentQueue4 = DispatchQueue(label: "ru.sergeipanov.concurrent-queue-4", attributes: .concurrent)
let concurrentQueue5 = DispatchQueue(label: "ru.sergeipanov.concurrent-queue-5", attributes: .concurrent)
let concurrentQueue6 = DispatchQueue(label: "ru.sergeipanov.concurrent-queue-6", attributes: .concurrent)
let concurrentQueue7 = DispatchQueue(label: "ru.sergeipanov.concurrent-queue-7", attributes: .concurrent)
let concurrentQueue8 = DispatchQueue(label: "ru.sergeipanov.concurrent-queue-8", attributes: .concurrent)
let concurrentQueue9 = DispatchQueue(label: "ru.sergeipanov.concurrent-queue-9", attributes: .concurrent)
let concurrentQueue10 = DispatchQueue(label: "ru.sergeipanov.concurrent-queue-10", attributes: .concurrent)

let group = DispatchGroup()

let semaphore = DispatchSemaphore(value: 1)

func addNewItem() {
    semaphore.wait()
    
    let hash = generateMD5Hash(strings: result)
    
    var newResult = result
    newResult.append(hash)
    result = newResult
    
    semaphore.signal()
}

for _ in 1...100 {
    concurrentQueue1.async(group: group, execute: addNewItem)
    concurrentQueue2.async(group: group, execute: addNewItem)
    concurrentQueue3.async(group: group, execute: addNewItem)
    concurrentQueue4.async(group: group, execute: addNewItem)
    concurrentQueue5.async(group: group, execute: addNewItem)
    concurrentQueue6.async(group: group, execute: addNewItem)
    concurrentQueue7.async(group: group, execute: addNewItem)
    concurrentQueue8.async(group: group, execute: addNewItem)
    concurrentQueue9.async(group: group, execute: addNewItem)
    concurrentQueue10.async(group: group, execute: addNewItem)
}

group.notify(queue: DispatchQueue.main) {
    print("Result: \(result.last ?? "")")
    let diff = CFAbsoluteTimeGetCurrent() - start
    print("Time spent: \(diff) seconds")
}

RunLoop().run()
