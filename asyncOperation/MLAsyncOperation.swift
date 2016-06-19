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
    private var ml_executing = false{
        willSet {
            willChangeValueForKey("isExecuting")
        }
        didSet {
            didChangeValueForKey("isExecuting")
        }
    }
    private var ml_finished = false{
        willSet {
            willChangeValueForKey("isFinished")
        }
        didSet {
            didChangeValueForKey("isFinished")
        }
    }
    
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
    
    convenience init(operationBlock:MLAsyncOperationBlock) {
        self.init()
        block = operationBlock
    }
    
    override func start() {
        if cancelled {
            ml_finished = true
            return
        }
        ml_executing = true
        block?(operation: self)
    }
    
    func finishOperation(){
        ml_executing = false
        ml_finished = true
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
