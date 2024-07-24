import UIKit

let concurrentQueue = DispatchQueue(label: "ru.sergeipanov.concurrent-queue", attributes: .concurrent)

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
    var result: Int = 0
    for i in 1...1_000 {
        for j in 1...1_000 {
            result += (i + j) / 2
        }
    }
    print(result)
}

startCalculation()

group.notify(queue: DispatchQueue.main) {
    if let startTime = startTime {
        let calculationTime = Date.now.timeIntervalSince(startTime)
        print("calculationTime = \(calculationTime) seconds")
    }
}

RunLoop().run()

// review:
// опять же результат надо писать от каждого треда. иначе не будет видно разницу с примером первым. и тут количество потоков не по количеству ядер цп
