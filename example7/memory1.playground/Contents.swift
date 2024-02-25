import UIKit

class Address {
    var street: String

    init(street: String) {
        self.street = street
    }
}

class User {
    var addresses = [Address]() // Поле addresses - массив Address
}

let firstConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.first-concurrent-queue", attributes: .concurrent)
// создается стэк потока firstConcurrentQueue
let secondConcurrentQueue = DispatchQueue(label: "ru.sergeipanov.second-concurrent-queue", attributes: .concurrent)
// создается стэк потока secondConcurrentQueue

// выделяется память в куче, объект юзера хранится в куче
let user = User()

firstConcurrentQueue.async {
    // выделяется память в стэке потока firstConcurrentQueue, массив ссылок на адреса хранится в стэке потока
    // адреса хранятся в куче, тк это ReferenceType
    let newAddresses = [Address(street: "Советская 23"), Address(street: "Армения, улица в Армении")]
    
    // выделяется память в куче под массив адрессов
    // массив хранится в еще и в куче
    user.addresses = newAddresses
} // память в стэке потока firstConcurrentQueue освобождается, объект newAddresses пропадает из памяти стэка, тк на него не осталось ссылок
// массив лежит только в куче

secondConcurrentQueue.async {
    // новая память не выделяется, тк для массивов работает оптимизация copyOnWrite
    var newAddresses = user.addresses
    
    // выделяется новая память в куче для объекта Address
    let newAddress = Address(street: "Ядринцевская 68/1")
    
    // выделяется память под массив в стэке потока firstConcurrentQueue, новый массив лежит в стэке, старый в куче
    newAddresses.append(newAddress)
    
    // старый массив удаляется из кучи, куча выделяет память под новый массив
    user.addresses = newAddresses
} // память в стэке потока secondConcurrentQueue освобождается, объект newAddresses пропадает из памяти, тк на него не осталось ссылок
// новый массив лежит в куче


