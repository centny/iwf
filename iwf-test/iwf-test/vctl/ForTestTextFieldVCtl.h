//
//  ForTestTextFieldVCtl.h
//  iwf-test
//
//  Created by vty on 9/28/15.
//  Copyright © 2015 Snows. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForTestTextFieldVCtl : UIViewController
@property(nonatomic,assign)IBOutlet UITextField *tf;
@property(nonatomic,assign)IBOutlet UIButton *btn;
-(IBAction)clkBtn:(id)sender;
//
//for test field
@property(nonatomic,assign)BOOL viewLoaded;
@end
