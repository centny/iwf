//
//  TableExtItemView.h
//  iwf-test
//
//  Created by Centny on 8/31/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iwf/iwf.h>

@interface TableExtItemView : UIView
@property(nonatomic,assign) IBOutlet UIButton *btn;
@property(nonatomic,assign) IBOutlet UIImageView* img;
@property(nonatomic,assign) IBOutlet UILabel* text;
-(IBAction)clkBtn:(id)sender;
-(IBAction)clkText:(id)sender;
@end

//@interface TableExtItemViewCell:UITableViewCell
//@property(nonatomic,readonly) TableExtItemView* iview;
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
//@end