import UIKit

let operationQueue = OperationQueue()

// ограничение на количество оперций равное количеству ядер
operationQueue.maxConcurrentOperationCount = 10

var result: Int = 0
var startTime: Date?

let group = DispatchGroup()

func startCalculation() {
    startTime = Date.now
    
    for _ in 1...100 {
        let operation = BlockOperation {
            calculate()
        }
        operationQueue.addOperation(operation)
    }
    
    let completionOperation = BlockOperation {
        print(result)
        
        if let startTime = startTime {
            let calculationTime = Date.now.timeIntervalSince(startTime)
            print("calculationTime = \(calculationTime) seconds")
        }
    }
    operationQueue.addOperation(completionOperation)
}

func calculate() {
    for i in 1...1_000 {
        for j in 1...1_000 {
            result += (i + j) / 2
        }
    }
}

startCalculation()

RunLoop().run()
