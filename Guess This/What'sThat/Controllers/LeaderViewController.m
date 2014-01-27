//
//  LeaderViewController.m
//  What'sThat
//
//  Created by Vikas kumar on 26/01/14.
//  Copyright (c) 2014 Vibhooti. All rights reserved.
//

#import "LeaderViewController.h"
#import "LeaderViewCell.h"

@interface LeaderViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *sortedScoreList;
}

@property (weak, nonatomic) IBOutlet UITableView *leaderTableView;

- (IBAction)btnBackClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UITableViewCell *tableViewCell;

@end

@implementation LeaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
//    sortedScoreList = [[NSMutableArray alloc] init];

    [self parseScoresList];
}

-(void)parseScoresList
{
    NSArray *actualList = [_scoresList objectForKey:@"data"];
    sortedScoreList = [actualList sortedArrayUsingComparator:^(id obj1, id obj2){
            NSInteger s1 = [[obj1 objectForKey:@"score"] integerValue];
            NSInteger s2 = [[obj2 objectForKey:@"score"] integerValue];
            
            if (s1 > s2) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if (s1 < s2) {
                return (NSComparisonResult)NSOrderedDescending;
        }
        
        // TODO: default is the same?
        return (NSComparisonResult)NSOrderedSame;
    }];

    
//    for ()
//    {
//        <#statements#>
//    }

    
//    for (int i = 0; i<actualList.count; i++)
//    {
//        id temp;
//        id temp2;
//        for (j = 1; j < actualList.count; j++)
//        {
//            <#statements#>
//        }
//    }
}

-(void)sortActualList
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark table View datascorce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sortedScoreList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    LeaderViewCell *cell = (LeaderViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LeaderViewCell" owner:self options:nil];
        cell = (LeaderViewCell *)[nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lblRank.text = [NSString stringWithFormat:@"%d",indexPath.row + 1];
    cell.lblName.text = [[[sortedScoreList objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"name"];
    cell.lblScore.text = [NSString stringWithFormat:@"%@",[[sortedScoreList objectAtIndex:indexPath.row] objectForKey:@"score"]];
    
    return cell;
}

@end
