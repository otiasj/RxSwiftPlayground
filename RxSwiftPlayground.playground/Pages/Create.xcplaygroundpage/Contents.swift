import Foundation
import RxSwift

//at the top
var workScheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .default)

print("A simple Observable create")

let obs = Observable<String>.create { observer in
    observer.onNext("Emit a string1")
    observer.onNext("Emit a string2")
    observer.onNext("Emit a string3")
    observer.onCompleted()
    return Disposables.create()
}

obs.mySubscribe()

print("A simple Asynchronous cancelable create")
workScheduler = ConcurrentDispatchQueueScheduler(qos: .default)

let obs2 = Observable<Int>.create { observer in
    let disposable2 = workScheduler.schedule(()) {
        print("init obs 2")
        
        return workScheduler.schedule(()) {
            print("Running obs 2")
            observer.onNext(2)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    return Disposables.create {
        print("Disposed 2")
        disposable2.dispose()
    }
}

obs2.mySubscribe()

//at bottom
playgroundTimeLimit(seconds: 10)

extension Observable {
    
    func mySubscribe() {
        self.subscribeOn(workScheduler)
        self.subscribe(
            onNext: { s in
                print("onNext:\(s)")
        },
            onError: {
                e in
                print("on Error:\(e)")
        },
            onCompleted: {
                print("onCompleted")
        },
            onDisposed: {
                print("onDisposed")
        })
    }
}
