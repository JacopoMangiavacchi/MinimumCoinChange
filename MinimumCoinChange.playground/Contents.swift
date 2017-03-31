//: Minimum Coin Change Problem Playground
//: Compare Greedy Algorithm and Dynamic Programming Algorithm in Swift
//:
//: Jacopo Mangiavacchi

import Foundation

struct MinimumCoinChange {
    private let sortedCoinSet: [Int]
    private var cache: [Int : [Int]]
    
    init(coinSet: [Int]) {
        self.sortedCoinSet = coinSet.sorted(by: { $0 > $1} )
        self.cache = [:]
    }

    //Greedy Algorithm
    func changeGreedy(_ value: Int) -> [Int] {
        var change:  [Int] = []
        var newValue = value
        
        for coin in sortedCoinSet {
            while newValue - coin >= 0 {
                change.append(coin)
                newValue -= coin
            }

            if newValue  == 0 {
                break
            }
        }
        
        return change
    }

    //Dynamic Programming Algorithm
    mutating func changeDynamic(_ value: Int) -> [Int] {
        if value <= 0 {
            return []
        }
        
        if let cached = cache[value] {
            return cached
        }
        
        var change:  [Int] = []
        
        var potentialChangeArray: [[Int]] = []
        
        for coin in sortedCoinSet {
            if value - coin >= 0 {
                var potentialChange: [Int] = []
                 potentialChange.append(coin)
                let newPotentialValue = value - coin

                if value  > 0 {
                    potentialChange.append(contentsOf: changeDynamic(newPotentialValue))
                }

                //print("value: \(value) coin: \(coin) potentialChange: \(potentialChange)")
                potentialChangeArray.append(potentialChange)
            }
        }
        
        if potentialChangeArray.count > 0 {
            let sortedPotentialChangeArray = potentialChangeArray.sorted(by: { $0.count < $1.count })
            change = sortedPotentialChangeArray[0]
        }
        
        cache[value] = change
        return change
    }
}

var mcc = MinimumCoinChange(coinSet: [1, 3, 4])
mcc.changeGreedy(6)
mcc.changeDynamic(6)


mcc = MinimumCoinChange(coinSet: [1, 2, 5, 10, 20, 25])

for i in 0..<100 {
    let greedy = mcc.changeGreedy(i)
    let dynamic = mcc.changeDynamic(i)

    if greedy.count != dynamic.count {
        print("\(i): greedy = \(greedy) dynamic = \(dynamic)")
    }
}




