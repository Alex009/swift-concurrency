import UIKit

var result: Int = 0

let counterConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.counter-concurrent-queue", attributes: .concurrent)

let incrementConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.increment-concurrent-queue", attributes: .concurrent)
let decrementConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.decrement-concurrent-queue", attributes: .concurrent)

let group = DispatchGroup()

func increment() {
    for _ in 1...100 {
        counterConcurrentQueue.async(flags: .barrier) {
            result = result + 1
        }
    }
}

func decrement() {
    for _ in 1...100 {
        counterConcurrentQueue.async(flags: .barrier) {
            result = result - 1
        }
    }
}

incrementConcurrentQueue.async(group: group) {
    increment()
}
decrementConcurrentQueue.async(group: group) {
    decrement()
}

group.notify(queue: DispatchQueue.main) {
    print(result)
}

RunLoop().run()

// review:
// здесь по сути вся работа уходит на третью очередь, у которой барьер. так как в этой очереди все задачи добавляются с барьером - мы по сути получаем не конкуррентную а последовательную очередь, где просто все задачи друг за другом выполнятся. полностью убирается параллелизм.
// в целом сама задача и не позволяет решить себя так, чтобы всё не превратилось в последовательное выполнение. Здесь главное было понять как барьером пользоваться.
// Стоит сделать еще 1 задание, вытекающее - придумать кейс где барьер будет не для всех задач в конкурентной очереди, а только определенные задачи будут барьером. чтобы у нас оставался параллелизм. В какой задаче такое может быть выполнено?
