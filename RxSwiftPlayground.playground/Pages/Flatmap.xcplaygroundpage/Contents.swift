import Foundation
import RxSwift

//at the top
var workScheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .default)

//the template
print("flatmap: transform the items into Observ­ables and merge them into a single one")
print("flatmap:The FlatMap operator transforms an Observable by applying a function that you specify to each item emitted by the source Observable, where that function returns an Observable that itself emits items. FlatMap then merges the emissions of these resulting Observables, emitting these merged results as its own sequence.")

let intObservable = Observable<Int>.from([1, 2, 3, 4, 5, 10, 11, 12, 13])
let stringObservable = Observable<String>.from(["first", "second", "third", "forth", "etc"])

intObservable.flatMap { (IntValue) -> Observable<String> in
    print("================== flatmap \(IntValue)")
    return stringObservable
}
.mySubscribe()


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

