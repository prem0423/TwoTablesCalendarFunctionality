//
//  detailTableViewCell.h
//  TwoTables
//
//  Created by Blaze Automation on 16/08/17.
//  Copyright © 2017 Blaze Automation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailDescLabel;

@end
