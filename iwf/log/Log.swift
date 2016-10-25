//
//  Log.swift
//  iwf
//
//  Created by Centny on 8/23/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

import UIKit

public let LOG_D:Int=10
public let LOG_I:Int=20
public let LOG_W:Int=30
public let LOG_E:Int=40

public protocol Log {
    func D(_ format: String, _ args: CVarArg...)
    func I(_ format: String, _ args: CVarArg...)
    func W(_ format: String, _ args: CVarArg...)
    func E(_ format: String, _ args: CVarArg...)
}

public protocol LogWriter{
    func write(_ data:String)
    func flush()
}


open class LogImpl:NSObject, Log {
    var file:String
    var line:Int
    var function:String
    
    public init(file:String,line:Int,function:String){
        self.file=file
        self.line=line
        self.function=function
    }
    
    func dlog(_ level:Int,format: String, args: CVaListPointer){
        let log:String=NSString(format: format, arguments:args) as String
        LogImpl.slog(self.file,line:self.line,function:self.function,level:level, log: log)
    }
    open func D(_ format: String, _ args: CVarArg...){
        self.dlog(LOG_D, format: format, args: getVaList(args))
    }
    open func I(_ format: String, _ args: CVarArg...){
        self.dlog(LOG_I, format: format, args: getVaList(args))
    }
    open func W(_ format: String, _ args: CVarArg...){
        self.dlog(LOG_W, format: format, args: getVaList(args))
    }
    open func E(_ format: String, _ args: CVarArg...){
        self.dlog(LOG_E, format: format, args: getVaList(args))
    }
    class open func slog(_ file:String,line:Int,function:String,level:Int,log:String){
        if level<LOG_LEVEL{
            return
        }
        var data:String=""
        switch level{
        case LOG_I:
            data=LogImpl.sdate(file,line:line,function:function,level:"I",log:log)
            break
        case LOG_W:
            data=LogImpl.sdate(file,line:line,function:function,level:"W",log:log)
            break
        case LOG_E:
            data=LogImpl.sdate(file,line:line,function:function,level:"E",log:log)
            break
        default:
            data=LogImpl.sdate(file,line:line,function:function,level:"D",log:log)
            break
        }
        if log_writer_==nil{
            print(data)
        }else{
            log_writer_?.write(data)
        }
    }
    class open func fpath(_ path:String)->(path:String,name:String) {
        let url:URL=URL(fileURLWithPath:path)
        return (url.deletingLastPathComponent().path,url.lastPathComponent)
    }
    class open func sdate(_ file:String,line:Int,function:String,level:String,log:String)->String{
        let fmt:DateFormatter = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let fp = fpath(file)
        var fn:String=fp.name
        if LOG_LONGF{
            fn=file
        }
        return NSString(format: "%@ %@:%d %@ - %@", fmt.string(from: Date()),fn,line,level,log) as String
    }
    class open func newl(_ file:String,line:Int,function:String)->LogImpl{
        return LogImpl(file: file, line: line, function: function)
    }
    open static var Level:Int{
        get{
            return LOG_LEVEL
        }
        set(val){
            LOG_LEVEL=val
        }
    }
    open static var Longf:Bool{
        get{
            return LOG_LONGF
        }
        set(val){
            LOG_LONGF=val
        }
    }
}

public var LOG_LEVEL:Int=LOG_D
var LOG_LONGF=false
var log_writer_:LogWriter?

public func L (_ file:String=#file,line:Int=#line,function:String=#function)->Log{
    return LogImpl(file: file, line:line, function: function)
}

public func flush_log(){
    log_writer_?.flush()
}
