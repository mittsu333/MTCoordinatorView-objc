# MTCoordinatorView-objc

![Code](https://img.shields.io/badge/code-obj--c-blue.svg)
[![Version](https://img.shields.io/cocoapods/v/MTCoordinatorView-objc.svg?style=flat)](http://cocoapods.org/pods/MTCoordinatorView-objc)
[![License](https://img.shields.io/cocoapods/l/MTCoordinatorView-objc.svg?style=flat)](http://cocoapods.org/pods/MTCoordinatorView-objc)
[![Platform](https://img.shields.io/cocoapods/p/MTCoordinatorView-objc.svg?style=flat)](http://cocoapods.org/pods/MTCoordinatorView-objc)

![img_gif](https://github.com/mittsuu/MTCoordinatorView-objc/blob/master/mtcoordinate.gif)


## Introduction

The view coordinate arranged to the scrolling is adjusted.

## Usage

```obj-c
// ViewController

#import <CoordinateManager.h>
#import <CoordinateContainer.h>

@interface ViewController ()

@property CoordinateManager *coordinateManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    ・・・ 'TableView' and 'Custom Header' are made beforehand. ・・・

    // Manager initialize
    _coordinateManager = [[CoordinateManager alloc]initManager:self scroll:tableView header:headerView];

    // create contents view
    UIImageView *childView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sample-image"]];
    // set start form
    childView.frame = CGRectMake(100, 100, 0, 0);
    // created view is put in the 'CoordinateContainer'
    CoordinateContainer *containerView = [[CoordinateContainer alloc]initView:childView endForm:CGRectMake(100, 100, 50, 50) mode:kSmoothModeFixity completion:^(void){
        // tap event callback.
    }];

    // set views
    [_coordinateManager setContainer:tableView views:containerView, nil];

    // set table view
    [self.view addSubview:table];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // catch scroll event to coordinate object
    [_coordinateManager scrolledDetection:scrollView];
}

```


## Installation

MTCoordinatorView-objc is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MTCoordinatorView-objc'
```

## Requirements

 * iOS   8.0+
 * Xcode 7.3+ 


## See Also

* MTCoordinatorView for Swift  
https://github.com/mittsuu/MTCoordinatorView


## License

MTCoordinatorView-objc is available under the MIT license. See the [LICENSE](https://github.com/mittsuu/MTCoordinatorView-objc/blob/master/LICENSE) file for more info.
