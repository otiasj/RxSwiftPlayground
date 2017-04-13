//: [Previous](@previous)

import Foundation
import RxSwift

print("interval start")

let subscription = Observable<Int>.interval(0.3, scheduler: MainScheduler.instance)
    .observeOn(MainScheduler.instance)
    .subscribe { event in
        print(event)
}

print("interval end")

playgroundTimeLimit(seconds: 10)