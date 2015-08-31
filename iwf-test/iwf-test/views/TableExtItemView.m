//
//  TableExtItemView.m
//  iwf-test
//
//  Created by Centny on 8/31/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import "TableExtItemView.h"

@implementation TableExtItemView
- (IBAction)clkBtn:(id)sender{
    NSDLog(@"clk Btn:%@", self.text.text);
}
-(IBAction)clkText:(id)sender{
    NSDLog(@"clk Text:%@", self.text.text);
}
@end

@implementation TableExtItemViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        _iview=[TableExtItemView loadFromXib];
        _iview.backgroundColor=[UIColor clearColor];
        [self addSubview:_iview];
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}
@end
