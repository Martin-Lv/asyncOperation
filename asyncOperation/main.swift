//
//  main.swift
//  asyncOperation
//
//  Created by 吕孟霖 on 16/1/13.
//  Copyright © 2016年 lvmenglin. All rights reserved.
//

import Foundation

class TestClass {
    func method1(){
        print("method 1 begin")
        for _ in 0 ... 100000 {
            continue
        }
        print("method 1 end")
    }
    
    func method2(){
        print("method 2 begin")
        for _ in 0 ... 100000 {
            continue
        }
        print("method 2 end")
    }
    
    let queue = dispatch_queue_create("UnsafeClass_background_queue", DISPATCH_QUEUE_CONCURRENT)

    func asyncMethod(done:()->Void){
        print("async method begin")
        dispatch_async(queue) { () -> Void in
            for _ in 0 ... 100000 {
                continue
            }
            print("async method end")
            done()
        }
        return
    }
}

let operationQueue = NSOperationQueue()
operationQueue.maxConcurrentOperationCount = 1



let object = TestClass()

operationQueue.addOperationWithBlock { () -> Void in
    object.method1()
}
operationQueue.addOperationWithBlock({ () -> Void in
    object.asyncMethod({ () -> Void in
    })
})
operationQueue.addOperationWithBlock { () -> Void in
    object.method2()
}

let runloop = NSRunLoop.currentRunLoop()
while runloop.runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture()){
    continue
}









