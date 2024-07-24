import Foundation

var startTime: Date?

let numberOfThreads = 100
var threads: [pthread_t?] = []

func startCalculation() {
    startTime = Date.now
    for i in 0...numberOfThreads {
        var thread: pthread_t?
        var arg = i
        let result = pthread_create(&thread, nil, { arg in
            return threadFunction(arg: arg)
        }, &arg)
        
        if result == 0 {
            threads.append(thread)
        } else {
            print("Error creating thread \(i)")
        }
    }
    
    for thread in threads {
        if let thread = thread {
            pthread_join(thread, nil)
        }
    }
    
    if let startTime = startTime {
        let calcTime = Date.now.timeIntervalSince(startTime)
        print("calculationTime = \(calcTime) seconds")
    }
}

func threadFunction(arg: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    var result: Int = 0
    for i in 1...1_000 {
        for j in 1...1_000 {
            result += (i + j) / 2
        }
    }
    print(result)
    
    return nil
}

startCalculation()

RunLoop().run()

// review:
// выводить нужно результат выполнения каждого потока. иначе не будет наглядного сравнения.
