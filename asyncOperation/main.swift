//
//  main.swift
//  asyncOperation
//
//  Created by 吕孟霖 on 16/1/13.
//  Copyright © 2016年 lvmenglin. All rights reserved.
//

import Foundation

class UnsafeClass {
    let queue = dispatch_queue_create("UnsafeClass_background_queue", DISPATCH_QUEUE_CONCURRENT)
    func method1(){
        print("method 1 begin")
        for _ in 0 ... 100000 {
            break
        }
        print("method 1 end")
    }
    
    func method2(){
        print("method 2 begin")
        for _ in 0 ... 100000 {
            break
        }
        print("method 2 end")
    }
    
    func asyncMethod(done:()->Void){
        dispatch_async(queue) { () -> Void in
            for _ in 0 ... 1000000 {
                break
            }
            done()
        }
        print("asyncMethod dispatched")
        return
    }
}

let operationQueue = NSOperationQueue()
operationQueue.name = "operation_queue"
operationQueue.maxConcurrentOperationCount = 1
let backgroundQueue = dispatch_queue_create("background_queue", DISPATCH_QUEUE_CONCURRENT)

autoreleasepool { () -> () in

    let unsafeObject = UnsafeClass()

    operationQueue.addOperationWithBlock({ () -> Void in
        print("async method begin 1")
        unsafeObject.asyncMethod({ () -> Void in
            print("async method end 1")
        })
    })
    operationQueue.addOperationWithBlock { () -> Void in
        dispatch_async(backgroundQueue, { () -> Void in
            unsafeObject.method1()
        })
    }
    operationQueue.addOperationWithBlock({ () -> Void in
        print("async method begin 2")
        unsafeObject.asyncMethod({ () -> Void in
            print("async method end 2")
        })
    })
    operationQueue.addOperationWithBlock { () -> Void in
        dispatch_async(backgroundQueue, { () -> Void in
            unsafeObject.method2()
        })
    }
    

    
    let runloop = NSRunLoop.currentRunLoop()
    while runloop.runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture()){
        break
    }

}







