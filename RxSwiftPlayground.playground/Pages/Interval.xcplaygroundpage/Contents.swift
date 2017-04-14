//: [Previous](@previous)

import Foundation
import RxSwift

print("interval: create an Observable that emits a sequence of integers spaced by a given time interval")

let emitTime = 0.3

let subscription = Observable<Int>.interval(emitTime, scheduler: MainScheduler.instance)
    .observeOn(MainScheduler.instance)
    .subscribe { event in
        print(event)
}

playgroundTimeLimit(seconds: 10)
