IOS Wide Framework
======

### HTTP Support

* get
* post x-www-form-urlencoded/multipart
* post file

example:`iwfTests/net/http/HTest.m or iwfTests/net/http/URLRequesterTest.m`


```
	//GET
    //
    //request normal text data
    [H doGet:^(URLRequester *req, NSData *data, NSError *err) {
        //call back
    } url:@"http://www.bing.com/xxx?a=%d&b=%@",1,@"text"];
    //
    //request json object, it will convert to NSDictionary
    [H doGetj:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        //call back
    } url:@"http://www.bing.com/xxx?a=%d&b=%@",1,@"text"];
    //
    //request by dictionary arguments.
    NSMutableDictionary* args=[NSMutableDictionary dictionary];
    [args setObject:1 forKey:@"a"];
    [args setObject:@"text" forKey:@"b"];
    [H doGet:@"http://www.bing.com/xxx" args:args completed:^(URLRequester *req, NSData *data, NSError *err) {
        //call back.
    }];


	//POST
    //
    //request by dictionary arguments.
    NSMutableDictionary* args=[NSMutableDictionary dictionary];
    [args setObject:1 forKey:@"a"];
    [args setObject:@"text" forKey:@"b"];
    [H doPost:@"http://www.bing.com/xxx" args:args completed:^(URLRequester *req, NSData *data, NSError *err) {
        //call back.
    }];
    [H doPost:@"http://www.bing.com/xxx" json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
       //call back.
    }];
```
### Logger Support

* level support by Debug/Info/Warn/Error
* language support to swift/objc
* file store support

example:`iwfTests/log/LogTest.swift or iwfTests/log/OcLTest.m`

```
	//objc
    NSDLog(@"debug->%@", @"D");
    NSILog(@"info->%@", @"I");
    NSWLog(@"warn->%@", @"W");
    NSELog(@"error->%@", @"E");

	//swift
    L().D("debug->%@,%@", "D","xx")
    L().I("info->%@,%@", "I","xx")
    L().W("warn->%@,%@", "W","xx")
	L().E("error->%@,%@", "E","xx")
```

### Useful UI Class

* `UIStarView` to star comment.
* `UILineView` to draw multi line on view.
* `UIBoundsImageView` to show bounded image on the same image view by special value (support format by file).
* `UITableExtView` to adding drag refresh and scrol to next page on normal TableView.
* `UIFocusView` to show multi view one by one, like PPT.

example: all usage exampe on `iwf-test/iwf-test/vctl`

### Useful Class Category
* convert between query string and dictionary by `dictionaryByURLQuery`/`stringByURLQuery`


### Useful Class

* `NSGImage` to get/set image RGBA value by x/y position.


