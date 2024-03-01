//
//  ContentView.swift
//  race-condition-5e
//
//  Created by Sergei Panov on 01.03.2024.
//

import SwiftUI
import Atomics

class AtomicArray: AtomicReference {
    private(set) var value: [String]
    
    init(value: [String] = []) {
        self.value = value
    }
    
    func append(_ newValue: String) {
        var currentValue = value
        
        currentValue.append(newValue)
        
        value = currentValue
    }
}

struct ContentView: View {
    
    let result: ManagedAtomic<AtomicArray>
    
    init() {
        
        self.result = ManagedAtomic(AtomicArray())
        
        calculateHash()
    }
    
    var body: some View {
        VStack {
            Text("Text")
        }
        .padding()
    }
    
    private func calculateHash() {
        let start = CFAbsoluteTimeGetCurrent()

        let concurrentQueue = DispatchQueue(label: "ru.sergeipanov.concurrent-queue", attributes: .concurrent)

        let group = DispatchGroup()

        func addNewItem() {
            for _ in 1...100 {
                concurrentQueue.async(group: group) {
                    let currentResult = result.load(ordering: .relaxed)
                    let hash = generateMD5Hash(
                        strings: currentResult.value
                    )
                    
                    currentResult.append(hash)
                    result.store(currentResult, ordering: .relaxed)
                }
            }
        }

        for _ in 1...10 {
            addNewItem()
        }

        group.notify(queue: DispatchQueue.main) {
            print("Result: \(result.load(ordering: .relaxed).value.last ?? "")")
            let diff = CFAbsoluteTimeGetCurrent() - start
            print("Time spent: \(diff) seconds")
        }
    }
}

#Preview {
    ContentView()
}
