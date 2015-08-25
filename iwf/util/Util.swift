//
//  Util.swift
//  iwf
//
//  Created by Centny on 8/24/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

import UIKit

public class Util: NSObject {
    //read file as home directory.
    class func readf(path:String)->String?{
        return readf_(NSHomeDirectory()+path)
    }
    class func readf_(path:String)->String?{
        var data=NSData(contentsOfFile:path)
        if data==nil {
            return nil
        }else{
            return NSString(data: data!, encoding: NSUTF8StringEncoding) as? String
        }
    }
    //write data to path as home directory.
    class func writef(path:String,str:String)->Bool{
        return writef_(NSHomeDirectory()+path, data: str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
    }
    class func writef(path:String,data:NSData)->Bool{
        return writef_(NSHomeDirectory()+path, data: data)
    }
    class func writef_(path:String,data:NSData)->Bool{
        var idx = path.rangeOfString("/", options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil)
        if (idx != nil){
            var fp = path.substringToIndex(idx!.startIndex)
            NSFileManager.defaultManager().createDirectoryAtPath(fp, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
        return data.writeToFile(path, atomically: true)
    }
    class func fpath(path:String)->(path:String,name:String) {
        var idx = path.rangeOfString("/", options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil)
        if idx == nil{
            return (".",path)
        }else{
            let tidx = idx!.startIndex
            return (path.substringToIndex(tidx),path.substringFromIndex(tidx.successor()))
        }
    }
}
