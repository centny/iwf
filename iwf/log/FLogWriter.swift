//
//  LogImpl.swift
//  iwf
//
//  Created by Centny on 8/23/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

import UIKit


class FLogWriter :LogWriter{
    var blen:Int = 1024
    var path:String = ""
    var buf:NSMutableData=NSMutableData()
    var console:Int = 1
    init(path:String,blen:Int=1024){
        self.path=path
        self.blen=1024
    }
    func write(data:String){
        if self.console>0{
            print(data)
        }
        let tdata=data+"\n"
        let tbuf=self.buf
        tbuf.appendData(tdata.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
        if tbuf.length < self.blen{
            return
        }
        self.buf=NSMutableData()
        var err:NSErrorPointer=nil
        var res=tbuf.writeToFile(self.path, options: NSDataWritingOptions.DataWritingFileProtectionComplete, error: err)
        if !res{
            println("write file err:"+err.debugDescription)
        }
    }
    deinit{
        var err:NSErrorPointer=nil
        self.buf.writeToFile(self.path, options: NSDataWritingOptions.DataWritingFileProtectionComplete, error: err)
    }
}

public func InitFLogWriter(path:String,blen:Int=1024){
    if log_writer_==nil{
        log_writer_=FLogWriter(path: path,blen:blen)
    }
}

public func InitDocWriter(){
    let homeDir = NSHomeDirectory() as String
    let logDir=homeDir+"/log"
    let fm=NSFileManager.defaultManager()
    if !fm.fileExistsAtPath(logDir){
        fm.createDirectoryAtPath(logDir, withIntermediateDirectories: true, attributes: nil, error: nil)
    }
    InitFLogWriter(logDir+"/t.log")
}