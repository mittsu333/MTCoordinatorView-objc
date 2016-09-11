# MTCoordinatorView-objc

[![Version](https://img.shields.io/cocoapods/v/MTCoordinatorView-objc.svg?style=flat)](http://cocoapods.org/pods/MTCoordinatorView-objc)
[![License](https://img.shields.io/cocoapods/l/MTCoordinatorView-objc.svg?style=flat)](http://cocoapods.org/pods/MTCoordinatorView-objc)
[![Platform](https://img.shields.io/cocoapods/p/MTCoordinatorView-objc.svg?style=flat)](http://cocoapods.org/pods/MTCoordinatorView-objc)


![img_gif](https://github.com/mittsuu/MTCoordinatorView-objc/blob/master/~)


## Introduction

The view coordinate arranged to the scrolling is adjusted.

## Usage

```obj-c
// ViewController

#import "CoordinateManager.h"
#import "CoordinateContainer.h"

・・・

- (void)viewDidLoad
{
    [super viewDidLoad];

    ・・・ 'TableView' and 'Custom Header' are made beforehand. ・・・

    // Manager initialize
    CoordinateManager *coordinateManager = [[CoordinateManager alloc]initManager:self scroll:tableView header:headerView];

    // create contents view.
    UIImageView *childView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sample-image"]];
    // set start form
    childView.frame = CGRectMake(100, 100, 0, 0);
    // created view is put in the 'CoordinateContainer'.
    CoordinateContainer *containerView = [[CoordinateContainer alloc]initView:childView endForm:CGRectMake(100, 100, 50, 50) mode:kSmoothModeFixity completion:^(void){
        // tap event callback.
    }];

    // set views
    [coordinateManager setContainer:tableView views:containerView, nil];

    // set table view
    [self.view addSubview:table];
}
```


## Installation

MTCoordinatorView-objc is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MTCoordinatorViewObjc"
```

## Requirements

 * iOS   8.0+
 * Xcode 8.0 


## License

MTCoordinatorView-objc is available under the MIT license. See the [LICENSE](https://github.com/mittsuu/MTCoordinatorView-objc/blob/master/LICENSE) file for more info.
