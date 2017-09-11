//
//  ViewController.m
//  TwoTables
//
//  Created by Blaze Automation on 16/08/17.
//  Copyright © 2017 Blaze Automation. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
//    NSArray *monthsArray;
    NSArray *detailArray;
    
    NSMutableArray *dataArray;
    NSMutableDictionary *dataDic;
    NSIndexPath *selectedMonthIndex;
    NSInteger selectedRow;
    BOOL touched;
}

@end
#define kMonthKey  @"month"
#define kDateKey   @"date"
#define kDescKey   @"desc"
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMM YYYY" ];
    NSDate *nowN =[NSDate date];
    NSString *currentMonthAndYear = [formatter stringFromDate:nowN];
    NSLog(@"currentMonthAndYear : %@",currentMonthAndYear);


//    NSArray *monthsArray = [[NSArray alloc] initWithObjects:@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December", nil];
    NSArray *monthsArray = [[NSArray alloc] initWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
    NSArray *yearsArray = [[NSArray alloc] initWithObjects:@"2014",@"2015",@"2016",@"2017", nil];

    dataArray = [[NSMutableArray alloc] init];
    dataDic = [[NSMutableDictionary alloc] init];
    
    for (NSString *yearString in yearsArray) {
        for (NSString *monthString in monthsArray) {
            NSString *monthYear = [NSString stringWithFormat:@"%@ %@", monthString, yearString];
            NSMutableArray *daysListInMonthArray = [[NSMutableArray alloc] init];
            for (int i = 1; i < 6; i++) {
                NSLog(@"i val: %d", i);
                NSDictionary *dayDic = @{
                                         kMonthKey : monthYear,
                                         kDateKey : [NSString stringWithFormat:@"%d %@ %@", i, monthString, yearString],
                                         kDescKey : @"desc more"
                                         };
                [daysListInMonthArray addObject:dayDic];
            }
//            NSDictionary *dic = @{
//                                  monthYear : daysListInMonthArray
//                                  };
            [dataArray addObject:monthYear];
            [dataDic setObject:daysListInMonthArray forKey:monthYear];
        }
    }
    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDic
//                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
//                                                         error:&error];
//    
//    if (! jsonData) {
//        NSLog(@"Got an error: %@", error);
//    } else {
//        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSLog(@"dataDic: %@", jsonString);
//    }
//    NSLog(@"dataArray: %@", dataArray);
//    dataArray = [[NSMutableArray alloc] initWithArray:[dataDic allKeys]];
    if ([dataArray containsObject:currentMonthAndYear]) {
        NSLog(@"indexOfObject : %lu", (unsigned long)[dataArray indexOfObject:currentMonthAndYear]);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSInteger Section = 0;//Change as required
            NSInteger Row = [dataArray indexOfObject:currentMonthAndYear];//Change as required
            selectedMonthIndex = [NSIndexPath indexPathForRow:Row inSection:Section];
            selectedRow = Row;
            [_monthsTableView scrollToRowAtIndexPath:selectedMonthIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [_monthsTableView reloadData];
            
            [_detailTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:Section inSection:Row] atScrollPosition:UITableViewScrollPositionTop animated:YES];

        });

    }
    
}

#pragma mark - TableViewDelegateMethods
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 1) {
        return [dataDic allKeys].count;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        return [[dataDic objectForKey:[dataArray objectAtIndex:section]] count];
    }
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        return 60;
    }
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"idNew";
    if (tableView.tag == 0) {
        monthsTableViewCellObject = (monthsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (monthsTableViewCellObject == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"monthsTableViewCell" owner:self options:nil];
            monthsTableViewCellObject = [nib objectAtIndex:0];
        }
//        monthsTableViewCellObject.monthLabel.text = @"Jan 2016";
        monthsTableViewCellObject.monthLabel.text = [dataArray objectAtIndex:indexPath.row];
        monthsTableViewCellObject.topView.hidden = YES;
        monthsTableViewCellObject.bottomView.hidden = YES;
        if (indexPath == selectedMonthIndex) {
            monthsTableViewCellObject.topView.hidden = NO;
            monthsTableViewCellObject.bottomView.hidden = NO;
            monthsTableViewCellObject.monthLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
            monthsTableViewCellObject.monthLabel.textColor = [UIColor blackColor];
        }
//        monthsTableViewCellObject.selectionStyle = UITableViewStylePlain;
        return monthsTableViewCellObject;
    }
    else {
        detailTableViewCellObject = (detailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (detailTableViewCellObject == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"detailTableViewCell" owner:self options:nil];
            detailTableViewCellObject = [nib objectAtIndex:0];
        }
        detailTableViewCellObject.dateLabel.text = [[[dataDic objectForKey:[dataArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:kDateKey];
        detailTableViewCellObject.detailDescLabel.text = [[[dataDic objectForKey:[dataArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:kDescKey];
//        detailTableViewCellObject.selectionStyle = UITableViewStylePlain;
        
        
        if (indexPath.section != selectedRow) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSInteger Section = 0;//Change as required
                NSUInteger sectionNumber = [[tableView indexPathForCell:[[tableView visibleCells] objectAtIndex:0]] section];
                NSInteger Row = sectionNumber;//Change as required
                
                NSIndexPath *customIndexPath = [NSIndexPath indexPathForRow:Row inSection:Section];
                selectedMonthIndex = customIndexPath;
                [_monthsTableView reloadData];
                [_monthsTableView scrollToRowAtIndexPath:customIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            });
        }

        return detailTableViewCellObject;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        monthsTableViewCellObject = (monthsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        monthsTableViewCellObject.topView.hidden = NO;
        monthsTableViewCellObject.bottomView.hidden = NO;
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        selectedMonthIndex = indexPath;
        selectedRow = indexPath.row;
        [_monthsTableView scrollToRowAtIndexPath:selectedMonthIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [_monthsTableView reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSInteger Section = indexPath.row;//Change as required
            NSInteger Row = 0;//Change as required
            NSIndexPath *customIndexPath = [NSIndexPath indexPathForRow:Row inSection:Section];
            [_detailTableView scrollToRowAtIndexPath:customIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        });
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 200, 28)];
        label.text = [dataArray objectAtIndex:section];
        label.font = [UIFont fontWithName:@"Helvetica Neue" size:21];
        label.textColor = [UIColor blackColor];
        [view addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(2, 43, tableView.frame.size.width, 2)];
        lineView.backgroundColor = [UIColor redColor];
        [view addSubview:lineView];

        return view;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        return 44;
    }
    return 0.00000001;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
