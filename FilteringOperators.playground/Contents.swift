import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "filter") {
    let numbers = (1...10).publisher
    
    numbers
        .filter { $0.isMultiple(of: 3) }
        .sink(receiveValue: { n in
            print("\(n) is a multiple of 3!")
        })
        .store(in: &subscriptions)
}




example(of: "removeDuplicates") {
    let words = "hey hey there! want to listen to mister mister ?"
        .components(separatedBy: " ")
        .publisher
    
        words
        .removeDuplicates()
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}


example(of: "compactMap") {
    let strings = ["a", "1.24", "3", "def", "def", "45", "0.23"].publisher
    
    strings
        .compactMap { Float($0) }
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}



example(of: "ignoreOutput") {
    let numbers = (1...10_000).publisher
    
    numbers
        .ignoreOutput()
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
}


example(of: "first(where:)") {
    let numbers = (1...9).publisher
    numbers
        .print("numbers")
        .first(where: { $0 % 2 == 0 })
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}


example(of: "last(where:)") {
    let numbers = (1...9).publisher
    numbers
        .last(where: { $0 % 2 == 0 })
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "last(where:) with PassthroughSubject") {
    let numbers = PassthroughSubject<Int, Never>()
    
    numbers
        .last(where: { $0 % 2 == 0 })
        .sink(receiveCompletion: { print("Completion with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    numbers.send(1)
    numbers.send(2)
    numbers.send(3)
    numbers.send(4)
    numbers.send(5)
    numbers.send(completion: .finished)
    
    example(of: "dropFirst") {
        let numbers = (1...10).publisher
        numbers
            .dropFirst(8)
            .sink(receiveValue: { print($0) })
            .store(in: &subscriptions)
    }
    
}



example(of: "drop(while:)") {
    let numbers = (1...10).publisher
    
    numbers
        .drop(while: { $0 % 5 != 0 })
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
}


example(of: "drop(untilOutputFrom:)") {
    let isReady = PassthroughSubject<Void, Never>()
    let taps = PassthroughSubject<Int, Never>()
    
    taps
        .drop(untilOutputFrom: isReady)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    (1...5).forEach { n in
        taps.send(n)
        
        if n == 3 {
            isReady.send()
        }
        
    }
    
}




example(of: "prefix") {
    let number = (1...10).publisher
    
    number
        .prefix(2)
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}



example(of: "prefix(while:)") {
    let numbers = (1...10).publisher
        
    numbers
        .prefix(while: { $0 < 3 })
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
    
}


example(of: "prefix(untilOutputFrom:") {
    let isReady = PassthroughSubject<Void, Never>()
    let taps = PassthroughSubject<Int, Never>()
    
    taps
        .prefix(untilOutputFrom: isReady)
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    (1...5).forEach { n in
        taps.send(n)
        
        if n == 2 {
            isReady.send()
        }
    }
    
}


example(of: "Filter all the things version 1") {
    let numbers = (1...100).publisher

    numbers
        .dropFirst(50)
        .prefix(20)
        .filter({ $0 % 2 == 0 })
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)


}

example(of: "Filter all the things version 2") {
    let numbers = (1...100).publisher


        .drop(while: { $0 % 51 != 0 })
        .prefix(while: { $0 - 50 < 21 })
        .filter({ $0 % 2 == 0 })
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)


}



example(of: "Filter all the things version 3") {
    let isReady = PassthroughSubject<Void, Never>()
    let numbers = PassthroughSubject<Int, Never>()
    let noMore = PassthroughSubject<Void, Never>()

    numbers
        .drop(untilOutputFrom: isReady)
        .prefix(untilOutputFrom: noMore)
        .filter({ $0 % 2 == 0 })
        .sink(receiveCompletion: { print("Completed with: \($0)") },
              receiveValue: { print($0) })
        .store(in: &subscriptions)

    (1...100).forEach { n in
        numbers.send(n)

        if n == 50 {
            isReady.send()
        }

        if n == 70 {
            noMore.send()
        }
    }

}


