import UIKit

let concurrentQueue = DispatchQueue(label: "ru.sergeipanov.concurrent-queue", attributes: .concurrent)

var result: Int = 0
var startTime: Date?

let group = DispatchGroup()

func startCalculation() {
    startTime = Date.now
    for _ in 1...100 {
        concurrentQueue.async(group: group) {
            calculate()
        }
    }
}

func calculate() {
    for i in 1...1_000 {
        for j in 1...1_000 {
            result += (i + j) / 2
        }
    }
}

startCalculation()

group.notify(queue: DispatchQueue.main) {
    print(result)
    
    if let startTime = startTime {
        let calculationTime = Date.now.timeIntervalSince(startTime)
        print("calculationTime = \(calculationTime) seconds")
    }
}

RunLoop().run()
