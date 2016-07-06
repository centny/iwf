//
//  ImVCtl.h
//  iwf-test
//
//  Created by vty on 11/24/15.
//  Copyright © 2015 Snows. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iwf/iwf.h>

@interface ImVCtl : UIViewController
@property(nonatomic) IBOutlet UITextField* to;
@property(nonatomic) IBOutlet UITextView* msg;
@property(nonatomic) IBOutlet UILabel* rec;
-(IBAction)clkSend:(id)sender;
@end
