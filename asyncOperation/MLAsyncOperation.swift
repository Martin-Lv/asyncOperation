//
//  MLAsyncOperation.swift
//  asyncOperation
//
//  Created by 吕孟霖 on 16/1/13.
//  Copyright © 2016年 lvmenglin. All rights reserved.
//

import Cocoa

typealias MLAsyncOperationBlock = (operation:MLAsyncOperation)->Void

class MLAsyncOperation: NSOperation {
    private var ml_executing = false
    private var ml_finished = false
    
    private var block:MLAsyncOperationBlock?
    
    override var asynchronous:Bool {
        return true
    }
    
    override var concurrent:Bool {
        return true
    }
    
    override var finished:Bool{
        return ml_finished
    }
    
    override var executing:Bool{
        return ml_executing
    }
    
    func ml_setFinished(finished:Bool){
        willChangeValueForKey("isFinished")
        ml_finished = finished
        didChangeValueForKey("isFinished")
    }
    
    func ml_setExecuting(executing:Bool){
        willChangeValueForKey("isExecuting")
        ml_executing = executing
        didChangeValueForKey("isExecuting")
    }
    
    convenience init(operationBlock:MLAsyncOperationBlock) {
        self.init()
        block = operationBlock
    }
    
    override func start() {
        if cancelled {
            ml_setFinished(true)
            return
        }
        ml_setExecuting(true)
        block?(operation: self)
    }
    
    func finishOperation(){
        ml_setExecuting(false)
        ml_setFinished(true)
    }
    
    deinit{
        print("operation deinited")
    }
}

extension NSOperationQueue {
    func addAsyncOperationWithBlock(block:MLAsyncOperationBlock){
        let asyncOperation = MLAsyncOperation(operationBlock: block)
        addOperation(asyncOperation)
    }
}
