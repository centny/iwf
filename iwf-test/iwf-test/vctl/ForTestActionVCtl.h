//
//  ForTestActionVCtl.h
//  iwf-test
//
//  Created by Centny on 9/15/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForTestActionVCtl : UIViewController
@property(nonatomic,assign) IBOutlet UILabel* lb1;
@property(nonatomic,assign) IBOutlet UIButton* btn1;
@property(nonatomic,assign) IBOutlet UITextField* txt1;

-(IBAction)clkBtn1:(id)sender;
@end
