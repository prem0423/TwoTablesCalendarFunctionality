//
//  monthsTableViewCell.h
//  TwoTables
//
//  Created by Blaze Automation on 16/08/17.
//  Copyright © 2017 Blaze Automation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface monthsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
