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
        self.writeFile(tbuf)
    }
    func flush(){
        let tbuf=self.buf
        self.buf=NSMutableData()
        self.writeFile(tbuf)
    }
    func writeFile(tbuf:NSMutableData){
        do{
            try tbuf.writeToFile(self.path, options: NSDataWritingOptions.DataWritingFileProtectionComplete)
        }catch{
            print("write file error")
        }
    }
    deinit{
        self.writeFile(self.buf);
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
        do{
            try fm.createDirectoryAtPath(logDir, withIntermediateDirectories: true, attributes: nil)
        }catch{
            print("create log directory error-->\n")
            return
        }
    }
    InitFLogWriter(logDir+"/t.log")
}