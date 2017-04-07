//
//  Minimum Coin Change Problem Playground
//  Compare Greedy Algorithm and Dynamic Programming Algorithm in Swift
//
//  Created by Jacopo Mangiavacchi on 04/03/17.
//

import Foundation

public enum MinimumCoinChangeError: Error {
    case noRestPossibleForTheGivenValue
}

public struct MinimumCoinChange {
    private let sortedCoinSet: [Int]
    
    public init(coinSet: [Int]) {
        self.sortedCoinSet = coinSet.sorted(by: { $0 > $1} )
    }

    //Greedy Algorithm
    public func changeGreedy(_ value: Int) throws -> [Int] {
        guard value > 0 else { return [] }

        var change:  [Int] = []
        var newValue = value

        for coin in sortedCoinSet {
            while newValue - coin >= 0 {
                change.append(coin)
                newValue -= coin
            }

            if newValue == 0 {
                break
            }
        }
        
        if newValue > 0 { 
            throw MinimumCoinChangeError.noRestPossibleForTheGivenValue 
        } 

        return change
    }

    //Dynamic Programming Algorithm
    public func changeDynamic(_ value: Int) throws -> [Int] {
        guard value > 0 else { return [] }
        
        var cache: [Int : [Int]] = [:]

        func _changeDynamic(_ value: Int) -> [Int] {
            guard value > 0 else { return [] }

            if let cached = cache[value] {
                return cached
            }
            
            var change: [Int] = []
            
            var potentialChangeArray: [[Int]] = []
            
            for coin in sortedCoinSet {
                if value - coin >= 0 {
                    var potentialChange: [Int] = []
                    potentialChange.append(coin)
                    let newPotentialValue = value - coin

                    if value  > 0 {
                        potentialChange.append(contentsOf: _changeDynamic(newPotentialValue))
                    }

                    //print("value: \(value) coin: \(coin) potentialChange: \(potentialChange)")
                    potentialChangeArray.append(potentialChange)
                }
            }
            
            if potentialChangeArray.count > 0 {
                let sortedPotentialChangeArray = potentialChangeArray.sorted(by: { $0.count < $1.count })
                change = sortedPotentialChangeArray[0]
            }
            
            if change.reduce(0, +) == value { 
                cache[value] = change
            } 

            return change
        }

        let change: [Int] = _changeDynamic(value)

        if change.reduce(0, +) != value { 
            throw MinimumCoinChangeError.noRestPossibleForTheGivenValue 
        } 

        return change
    }
}
