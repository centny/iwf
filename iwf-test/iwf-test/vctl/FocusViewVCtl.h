//
//  FocusViewVCtl.h
//  iwf-test
//
//  Created by Centny on 9/1/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iwf/iwf.h>

@interface FocusViewVCtl : UIViewController<UIFocusViewDelegate>
@property(nonatomic,assign) IBOutlet UIFocusView* fiv;
@end
