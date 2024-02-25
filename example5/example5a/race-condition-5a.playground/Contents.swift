import Foundation
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

func addNewItem() {
    let hash = generateMD5Hash(strings: result)
    
    var newResult = result
    newResult.append(hash)
    result = newResult
}

for _ in 1...100 {
    concurrentQueue1.async(execute: addNewItem)
    concurrentQueue2.async(execute: addNewItem)
    concurrentQueue3.async(execute: addNewItem)
    concurrentQueue4.async(execute: addNewItem)
    concurrentQueue5.async(execute: addNewItem)
    concurrentQueue6.async(execute: addNewItem)
    concurrentQueue7.async(execute: addNewItem)
    concurrentQueue8.async(execute: addNewItem)
    concurrentQueue9.async(execute: addNewItem)
    concurrentQueue10.async(execute: addNewItem)
}

print("Result: \(result.last ?? "")")
let diff = CFAbsoluteTimeGetCurrent() - start
print("Time spent: \(diff) seconds")

RunLoop().run()

