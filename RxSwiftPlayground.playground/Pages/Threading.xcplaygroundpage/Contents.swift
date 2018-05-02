import Foundation
import RxSwift

var workScheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)

func verifyThread() -> String{
    if Thread.isMainThread {
        return "This is the main thread"
    } else {
        return "This is a background thread"
    }
}

func case1() {
    //UI Thread by default
    print("case 1- UI Thread by default \(verifyThread())")

    let obs = Observable<Int>.create { (observer) -> Disposable in
        print("case 1- observable is running and emitting on the same thread that it was created: \(verifyThread())")
        observer.onNext(1)
        observer.onCompleted()
        return Disposables.create()
    }.map { result -> String in
        print("case \(result)- following map operations are running :\(verifyThread())")
        return "Result Integer \(result) mapped as a string"
    }
    obs.mySubscribe()
}

func case2() {
    //Background thread
    print("case 2- Background thread")
    let obs2 = Observable<Int>.create { observer in
        let disposable = workScheduler.schedule(()) {
            print("case 2- observable is running in the background, emission is also on the background: \(verifyThread())")
            observer.onNext(2)
            observer.onCompleted()
            return Disposables.create()
        }
        return Disposables.create {
            //clean up if any
            disposable.dispose()
        }
        }.map { result -> String in
            print("case \(result)- following map operations are running :\(verifyThread())")
            return "Result Integer \(result) mapped as a string"
        }
    obs2.mySubscribe()
}

func case3() {
    //Specify background and foreground
    print("case 3- subscribe on Background thread and emit on main Thread")
    let obs3 = Observable<Int>.create { (observer) -> Disposable in
        print("case 3- : \(verifyThread())")
        observer.onNext(3)
        observer.onCompleted()
        return Disposables.create()
    }.map { result -> String in
        print("case \(result)- following map operations are running :\(verifyThread())")
        return "Result Integer \(result) mapped as a string"
    }
    obs3.subscribeOn(workScheduler) //HERE
        .observeOn(MainScheduler.instance) //and HERE
        .mySubscribe()
}

func case4() {
    //Specify background and foreground
    print("case 4- subscribe on Background thread and complete on main Thread")
    let obs4 = Observable<Int>.create { observer in
        let disposable = workScheduler.schedule(()) { //HERE
            print("case 4- observable is running in the background: \(verifyThread())")
            observer.onNext(4)
            observer.onCompleted()
            return Disposables.create()
        }
        return Disposables.create {
            //clean up if any
            disposable.dispose()
        }
    }.map { result -> String in
            print("case \(result)- following map operations are running :\(verifyThread())")
            return "Result Integer \(result) mapped as a string"
    }
    obs4.observeOn(MainScheduler.instance) //HERE
        .mySubscribe()
}

func case5() {
    //Observable 5_1 runs and emit on whatever thread it was started on
    let obs5_1 = Observable<Int>.create { (observer) -> Disposable in
        print("case 5_1- : \(verifyThread())")
        observer.onNext(51)
        observer.onCompleted()
        return Disposables.create()
        }.map { result -> String in
            print("case \(result)- following map operations are running :\(verifyThread())")
            return "Result Integer \(result) mapped as a string"
    }
    
    //Observable 5_2 always runs on the background emittion is not specified
    let obs5_2 = Observable<Int>.create { observer in
        let disposable = workScheduler.schedule(()) { //HERE
            print("case 5_2- observable is running in the background: \(verifyThread())")
            observer.onNext(5_2)
            observer.onCompleted()
            return Disposables.create()
        }
        return Disposables.create {
            //clean up if any
            disposable.dispose()
        }
        }.map { result -> String in
            print("case \(result)- following map operations are running :\(verifyThread())")
            return "Result Integer \(result) mapped as a string"
    }
    
    Observable.concat(obs5_1, obs5_2, obs5_1)
        .subscribeOn(workScheduler) //Override all operation to be on background (try commenting this out and see the difference)
        .observeOn(MainScheduler.instance) //Override all emittion to be on the foreground (try commenting this out and see the difference)
        .mySubscribe()
}

//Run one or multiple cases:
//case1()
//case2()
//case3()
//case4()
case5()

//at bottom
playgroundTimeLimit(seconds: 10)

extension Observable {
    
    func mySubscribe() {
        self.subscribe(
            onNext: { s in
                print("onNext:(\(s)) \(verifyThread())")
        },
            onError: {
                e in
                print("on Error:(\(e)) \(verifyThread())")
        },
            onCompleted: {
                print("onCompleted \(verifyThread())")
        },
            onDisposed: {
                print("onDisposed \(verifyThread())")
        })
    }

}
