//
//  ContentView.swift
//  race-condition-5e
//
//  Created by Sergei Panov on 01.03.2024.
//

import SwiftUI
import Atomics

class AtomicArray: AtomicReference {
    let value: [String]
    
    init(value: [String] = []) {
        self.value = value
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
                    // пока мы не сможем корректно добавить новый результат - будем повторять попытки расчетов
                    while (true) {
                        let currentResult = result.load(ordering: .relaxed)
                        let currentArray = currentResult.value
                        
                        let hash = generateMD5Hash(strings: currentArray)
                        
                        let newArray = currentArray + [hash]
                        
                        let exchangeResult = result.compareExchange(
                            expected: currentResult,
                            desired: AtomicArray(value: newArray),
                            ordering: .relaxed
                        )
                        // если мы успешно добавили результат - прекращаем попытки
                        if exchangeResult.exchanged {
                            break
                        }
                    }
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

// review:
// я внес исправления в код. правильное использование atomicReference сводится к попыткам заменить текущее значение атомарно, сверяясь с тем значением, на основании которого мы считали новое. Если не удалось заменить - повторяем расчет уже с новым значением.
// надо с атомиками лучше разобраться однако
