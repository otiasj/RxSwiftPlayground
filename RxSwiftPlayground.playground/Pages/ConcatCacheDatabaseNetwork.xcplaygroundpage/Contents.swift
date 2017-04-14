//: Playground - noun: a place where people can play

import UIKit
import RxSwift


print ("This demonstrate how to concat 3 observables to emulate loading from cache, database then network.")
print ("first try obs1, if it emits then just returns")
print ("else try obs2, if it emits then just returns")
print ("else try obs3")

var workScheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .default)

let obs1 = Observable<Int>.create { observer in
    let disposable1 = workScheduler.schedule(()) {
        print("Running obs 1")
        //observer.onNext(1)
        return workScheduler.schedule(()) {
            print("complete obs 1")
            observer.onCompleted()
            return Disposables.create()
        }
    }
    return Disposables.create {
        print("Disposed 1")
        disposable1.dispose()
    }
}

let obs2 = obs1.concat(Observable<Int>.create { observer in
    let disposable2 = workScheduler.schedule(()) {
        print("Running obs 2")
         observer.onNext(2)
        return workScheduler.schedule(()) {
            print("complete obs 2")
            observer.onCompleted()
            return Disposables.create()
        }
    }
    return Disposables.create {
        print("Disposed 2")
        disposable2.dispose()
    }
})

let obs3 = obs2.concat(Observable<Int>.create { observer in
    
    let disposable3 = workScheduler.schedule(()) {
        print("Running obs 3")
        observer.onNext(3)
        return workScheduler.schedule(()) {
            print("complete obs 3")
            observer.onCompleted()
            return Disposables.create()
        }
    }
    return Disposables.create {
        print("Disposed 3")
        disposable3.dispose()
    }
}).take(1)

obs3.mySubscribe()

//===== Same logic with slightly different syntax with independant observable

workScheduler = ConcurrentDispatchQueueScheduler(qos: .default)

let obs4 = Observable<Int>.create { observer in
    let disposable4 = workScheduler.schedule(()) {
        print("Running obs 4")
        //observer.onNext(4)
        return workScheduler.schedule(()) {
            print("complete obs 4")
            observer.onCompleted()
            return Disposables.create()
        }
    }
    return Disposables.create {
        print("Disposed 4")
        disposable4.dispose()
    }
}

let obs5 = Observable<Int>.create { observer in
    let disposable5 = workScheduler.schedule(()) {
        print("Running obs 5")
        //observer.onNext(5)
        return workScheduler.schedule(()) {
            print("complete obs 5")
            observer.onCompleted()
            return Disposables.create()
        }
    }
    return Disposables.create {
        print("Disposed 5")
        disposable5.dispose()
    }
}

let obs6 = Observable<Int>.create { observer in
    
    let disposable6 = workScheduler.schedule(()) {
        print("Running obs 6")
        observer.onNext(6)
        return workScheduler.schedule(()) {
            print("complete obs 6")
            observer.onCompleted()
            return Disposables.create()
        }
    }
    return Disposables.create {
        print("Disposed 6")
        disposable6.dispose()
    }
}

Observable<Int>.concat([obs4, obs5, obs6]).take(1).mySubscribe()
 

//COPY This at the bottom
playgroundTimeLimit(seconds: 10)

extension Observable {
    
    func mySubscribe() {
        self.subscribeOn(workScheduler)
        self.subscribe(
            onNext: { s in
                print(s)
        },
            onError: {
                e in
                print("on Error \(e)")
        },
            onCompleted: {
                print("onCompleted")
        },
            onDisposed: {
                print("onDisposed")
        })
    }
}

