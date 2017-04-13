//: [Previous](@previous)

import Foundation
import RxSwift

print("interval start")

let emitTime = 0.3

let subscription = Observable<Int>.interval(emitTime, scheduler: MainScheduler.instance)
    .observeOn(MainScheduler.instance)
    .subscribe { event in
        print(event)
}

print("interval end")

playgroundTimeLimit(seconds: 10)
