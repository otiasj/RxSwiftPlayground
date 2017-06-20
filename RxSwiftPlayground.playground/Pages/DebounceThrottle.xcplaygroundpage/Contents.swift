import Foundation
import RxSwift

//at the top
var workScheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .default)

let subject = Observable<String>.create { observer in
    observer.onNext("Emit a string1")
    observer.onNext("Emit a string2")
    observer.onNext("Emit a string3")
    observer.onCompleted()
    return Disposables.create()
}

//the template
print("Debounce: Ignores elements from an observable sequence which are followed by another element within a specified relative time duration, using the specified scheduler to run throttling timers.")

subject.debounce(3.0, scheduler: workScheduler).mySubscribe()

//subject.mySubscribe()

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
