//
//  ViewController.h
//  Orienteering GPX Logger
//
//  Created by Siddhartha on 4/16/16.
//  Copyright © 2016 Lightbeard. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MessageUI;
@import CoreLocation;
#import "GPX.h"

@interface ViewController : UIViewController<CLLocationManagerDelegate, UIWebViewDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

