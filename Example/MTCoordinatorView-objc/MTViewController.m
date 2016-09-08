//
//  MTViewController.m
//  MTCoordinatorView-objc
//
//  Created by mittsu on 09/07/2016.
//  Copyright (c) 2016 mittsu. All rights reserved.
//

#import "MTViewController.h"

#import "../../MTCoordinatorView-objc/Classes/CoordinateManager.h"
#import "../../MTCoordinatorView-objc/Classes/CoordinateContainer.h"

@interface MTViewController ()

@property NSMutableArray *sampleDataArray;
@property CoordinateManager *coordinateManager;

@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // initialize
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    // sample list data
    _sampleDataArray = [NSMutableArray array];
    for(int i = 1; i <= 20; i++){
        [_sampleDataArray addObject:[NSString stringWithFormat:@"sample %02d", i]];
    }
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [table registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    table.dataSource = self;
    table.delegate = self;
    
    // create header sample
    UIImage *headerImg = [UIImage imageNamed:@"sample-header"];
    float imgHeight = (headerImg.size.height / headerImg.size.width) * self.view.frame.size.width;
    UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, imgHeight)];
    headerView.image = headerImg;
    
    // set header view
    _coordinateManager = [[CoordinateManager alloc]initMainContents:self scroll:table header:headerView];
 
    
    // create childview contents
    UIImage *iconImg = [UIImage imageNamed:@"sample-icon"];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:iconImg];
    float centerX = self.view.frame.size.width / 2;
    float iconSize = 110.0;
    float startX = centerX - (iconSize / 2);
    iconView.frame = CGRectMake(startX, 80.0, iconSize, iconSize);
    float iconRadius = 0.5;
    iconView.layer.cornerRadius = iconView.frame.size.width * iconRadius;
    iconView.clipsToBounds = YES;
    
    iconView.layer.masksToBounds = YES;
    iconView.layer.borderWidth = 3.0;
    iconView.layer.borderColor = [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8] CGColor];
    
    CoordinateContainer *childView = [[CoordinateContainer alloc]initView:iconView endForm:CGRectMake(centerX, 120, 0, 0) corner:iconRadius completion:^(void){
        // tap event
        [self tapEvent:@"Tap Event 1"];
    }];
    
    // set views
    [_coordinateManager setContainer:table views:@[childView]];
//    [_coordinateManager setContainer:table views:childView, nil];
    
    [self.view addSubview:table];
}

#pragma mark - table

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // select cell
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sampleDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = _sampleDataArray[indexPath.row];
    return cell;
}

#pragma mark - scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_coordinateManager scrolledDetection:scrollView];
}

#pragma mark - tap event

- (void)tapEvent:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
