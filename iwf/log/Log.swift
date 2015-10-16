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
    func D(format: String, _ args: CVarArgType...)
    func I(format: String, _ args: CVarArgType...)
    func W(format: String, _ args: CVarArgType...)
    func E(format: String, _ args: CVarArgType...)
}

public protocol LogWriter{
    func write(data:String)
    func flush()
}


public class LogImpl:NSObject, Log {
    var file:String
    var line:Int
    var function:String
    
    public init(file:String,line:Int,function:String){
        self.file=file
        self.line=line
        self.function=function
    }
    
    func dlog(level:Int,format: String, args: CVaListPointer){
        let log:String=NSString(format: format, arguments:args) as String
        LogImpl.slog(self.file,line:self.line,function:self.function,level:level, log: log)
    }
    public func D(format: String, _ args: CVarArgType...){
        self.dlog(LOG_D, format: format, args: getVaList(args))
    }
    public func I(format: String, _ args: CVarArgType...){
        self.dlog(LOG_I, format: format, args: getVaList(args))
    }
    public func W(format: String, _ args: CVarArgType...){
        self.dlog(LOG_W, format: format, args: getVaList(args))
    }
    public func E(format: String, _ args: CVarArgType...){
        self.dlog(LOG_E, format: format, args: getVaList(args))
    }
    class public func slog(file:String,line:Int,function:String,level:Int,log:String){
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
            print(data+"\n")
        }else{
            log_writer_?.write(data)
        }
    }
    class public func fpath(path:String)->(path:String,name:String) {
        let url:NSURL=NSURL(fileURLWithPath:path)
        return (url.URLByDeletingLastPathComponent!.path!,url.lastPathComponent!)
    }
    class public func sdate(file:String,line:Int,function:String,level:String,log:String)->String{
        let fmt:NSDateFormatter = NSDateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let fp = fpath(file)
        var fn:String=fp.name
        if LOG_LONGF{
            fn=file
        }
        return NSString(format: "%@ %@:%d %@ - %@", fmt.stringFromDate(NSDate()),fn,line,level,log) as String
    }
    class public func newl(file:String,line:Int,function:String)->LogImpl{
        return LogImpl(file: file, line: line, function: function)
    }
    public static var Level:Int{
        get{
            return LOG_LEVEL
        }
        set(val){
            LOG_LEVEL=val
        }
    }
    public static var Longf:Bool{
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

public func L (file:String=__FILE__,line:Int=__LINE__,function:String=__FUNCTION__)->Log{
    return LogImpl(file: file, line:line, function: function)
}

public func flush_log(){
    log_writer_?.flush()
}