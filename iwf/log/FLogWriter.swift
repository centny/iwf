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
    func write(_ data:String){
        if self.console>0{
            print(data)
        }
        let tdata=data+"\n"
        let tbuf=self.buf
        tbuf.append(tdata.data(using: String.Encoding.utf8, allowLossyConversion: true)!)
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
    func writeFile(_ tbuf:NSMutableData){
        do{
            try tbuf.write(toFile: self.path, options: NSData.WritingOptions.completeFileProtection)
        }catch{
            print("write file error")
        }
    }
    deinit{
        self.writeFile(self.buf);
    }
}

public func InitFLogWriter(_ path:String,blen:Int=1024){
    if log_writer_==nil{
        log_writer_=FLogWriter(path: path,blen:blen)
    }
}

public func InitDocWriter(){
    let homeDir = NSHomeDirectory() as String
    let logDir=homeDir+"/log"
    let fm=FileManager.default
    if !fm.fileExists(atPath: logDir){
        do{
            try fm.createDirectory(atPath: logDir, withIntermediateDirectories: true, attributes: nil)
        }catch{
            print("create log directory error-->\n")
            return
        }
    }
    InitFLogWriter(logDir+"/t.log")
}
