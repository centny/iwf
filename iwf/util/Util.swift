////
////  Util.swift
////  iwf
////
////  Created by Centny on 8/24/15.
////  Copyright (c) 2015 Snows. All rights reserved.
////
//
//import UIKit
//
//public class Util: NSObject {
//    //read file as home directory.
//    class public func readf_(path:String)->String?{
//        return readf(NSHomeDirectory()+"/"+path)
//    }
//    class public func readf(path:String)->String?{
//        var data=NSData(contentsOfFile:path)
//        if data==nil {
//            return nil
//        }else{
//            return NSString(data: data!, encoding: NSUTF8StringEncoding) as? String
//        }
//    }
//    //write data to path as home directory.
//    class public func writef_(path:String,str:String)->Bool{
//        return writef(NSHomeDirectory()+"/"+path, data: str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
//    }
//    class public func writef_(path:String,data:NSData)->Bool{
//        return writef(NSHomeDirectory()+"/"+path, data: data)
//    }
//    class public func writef(path:String,str:String)->Bool{
//        return writef(path, data: str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
//    }
//    class public func writef(path:String,data:NSData)->Bool{
//        var floder=path.stringByDeletingLastPathComponent
//        var fm=NSFileManager.defaultManager()
//        if !fm.fileExistsAtPath(floder){
//            fm.createDirectoryAtPath(floder, withIntermediateDirectories: true, attributes: nil, error: nil)
//        }
//        return data.writeToFile(path, atomically: true)
//    }
//    class public func fsize_(path:String)->Int64{
//        return fsize(NSHomeDirectory()+"/"+path)
//    }
//    class public func fsize(path:String)->Int64{
//        var attrs:NSDictionary? = NSFileManager.defaultManager().attributesOfItemAtPath(path, error: nil)
//        var fs:AnyObject? = attrs?.valueForKey("NSFileSize")
//        if fs==nil{
//            return 0
//        }else{
//            return fs!.longLongValue
//        }
//    }
//    class public func homef(path:String)->String {
//        return NSHomeDirectory()+"/"+path
//    }
//    class public func fext(path:String)->String {
//        return path.pathExtension
//    }
//    class public func fpath(path:String)->(path:String,name:String) {
//        return (path.stringByDeletingLastPathComponent,path.lastPathComponent)
//    }
//}
