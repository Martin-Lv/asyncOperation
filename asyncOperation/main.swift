//
//  main.swift
//  asyncOperation
//
//  Created by 吕孟霖 on 16/1/13.
//  Copyright © 2016年 lvmenglin. All rights reserved.
//

import Foundation

class TestClass {
    
    let queue = dispatch_queue_create("TestClass_background_queue", DISPATCH_QUEUE_CONCURRENT)

    func method1(){
        print("method 1 begin")
        for _ in 0 ... 100000 {
            continue
        }
        print("method 1 end")
    }
    
    func asyncMethod1(done:()->Void){
        print("async method 1 begin")
        dispatch_async(queue) { () -> Void in
            for _ in 0 ... 100000 {
                continue
            }
            print("async method 1 end")
            done()
        }
        return
    }
    
    func asyncMethod2(done:()->Void){
        print("async method 2 begin")
        dispatch_async(queue) { () -> Void in
            for _ in 0 ... 100000 {
                continue
            }
            print("async method 2 end")
            done()
        }
        return
    }
}

let operationQueue = NSOperationQueue()
operationQueue.maxConcurrentOperationCount = 5

let object = TestClass()

let op1 = NSBlockOperation { 
    object.method1()
}

let asyncOp1 = MLAsyncOperation { (operation) in
    object.asyncMethod1{ () -> Void in
        operation.finishOperation()
    }
}

let asyncOp2 = MLAsyncOperation { (operation) in
    object.asyncMethod2{
        operation.finishOperation()
    }
}

op1.addDependency(asyncOp1)
op1.addDependency(asyncOp2)

operationQueue.addOperation(asyncOp1)
operationQueue.addOperation(asyncOp2)
operationQueue.addOperation(op1)

let runloop = NSRunLoop.currentRunLoop()
while runloop.runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture()){
    continue
}









