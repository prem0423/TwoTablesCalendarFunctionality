//
//  ViewController.h
//  TwoTables
//
//  Created by Blaze Automation on 16/08/17.
//  Copyright © 2017 Blaze Automation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "monthsTableViewCell.h"
#import "detailTableViewCell.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    monthsTableViewCell *monthsTableViewCellObject;
    detailTableViewCell *detailTableViewCellObject;
}

@property (weak, nonatomic) IBOutlet UITableView *monthsTableView;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@end

