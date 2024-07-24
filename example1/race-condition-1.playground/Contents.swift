import UIKit

var result: Int = 0

let incrementConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.increment-concurrent-queue", attributes: .concurrent)
let decrementConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.decrement-concurrent-queue", attributes: .concurrent)

let group = DispatchGroup()

func increment() {
    incrementConcurrentQueue.async(group: group) {
        for _ in 1...100 {
            result = result + 1
        }
    }
}

func decrement() {
    decrementConcurrentQueue.async(group: group) {
        for _ in 1...100 {
            result = result - 1
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
// ситуация гонки тут есть, да. но можно было сделать всё проще, без очередей и групп. по сути надо просто два потока которые внутри будут содержать цикл. не как щас - цикл который создает множество задач в две очереди. а именно запуск просто двух потоков. в целом можно даже в текущем варианте цикл внутрь задач перенести и будет таже проблема гонки, без множества тасок
// но в общем да, задача решена.
