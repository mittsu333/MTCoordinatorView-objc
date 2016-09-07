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

- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    // sample list data
    _sampleDataArray = [NSMutableArray array];
    for(int i = 0; i < 20; i++){
        [_sampleDataArray addObject:[NSString stringWithFormat:@"sample %d", i]];
    }
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [table registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    table.dataSource = self;
    table.delegate = self;

    
    UIImage *img = [UIImage imageNamed:@"sample-header"];
    float imgHeight = (img.size.height / img.size.width) * self.view.frame.size.width;
    UIImageView *header = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, imgHeight)];
    header.image = img;


    // setup coordinator
    _coordinateManager = [[CoordinateManager alloc]initMainContents:self scroll:table header:header];
//    _coordinateManager = [[CoordinateManager alloc]initMainContents:self scroll:table header:nil];
    
    UIView *uv = [[UIView alloc] initWithFrame:CGRectMake(300, 220, 50, 50)];
    uv.backgroundColor = [UIColor blueColor];
    
    CoordinateContainer *childView = [[CoordinateContainer alloc]initView:uv endForm:CGRectMake(320, 150, 0, 0) completion:^(void){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tap Event" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    // set views
    [_coordinateManager setContainer:table views:childView, nil];
    
    [self.view addSubview:table];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_coordinateManager scrolledDetection:scrollView];
}

@end
