//
//  ViewController.m
//  Orienteering GPX Logger
//
//  Created by Siddhartha on 4/16/16.
//  Copyright © 2016 Lightbeard. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

/* private member variables */
GPXRoot *root;
GPXTrack *track;
CLLocationManager *locationManager;
CLLocationCoordinate2D coordinate;
CLLocationDistance altitude;
bool recording = false;
NSMutableString *filename;

- (void) viewDidLayoutSubviews {
    // this ensures UIWebView takes up 100% of device screen
    _webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_webView setDelegate:self];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    locationManager = [[CLLocationManager alloc] init];
    
    [locationManager requestAlwaysAuthorization];
    
    locationManager.delegate = self;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    [locationManager startUpdatingLocation];
    
    CLLocation *location = [locationManager location];
    
    coordinate = [location coordinate];
    altitude = [location altitude];
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSLog(@"Loading URL :%@",request.URL.absoluteString);
    
    if ([request.URL.absoluteString rangeOfString:@"js-frame"].location == NSNotFound) {
        return YES;
    } else {
        
        if ([request.URL.absoluteString rangeOfString:@"record"].location != NSNotFound) {
            
            NSUInteger urlstart = [request.URL.absoluteString rangeOfString:@"js-frame://record/"].length;
            
            filename = [[request.URL.absoluteString substringFromIndex:urlstart] mutableCopy];
            
            recording = true;
            
            NSThread *t = [[NSThread alloc] initWithTarget:self selector:@selector(record) object:nil];
            [t start];
        
        } else if ([request.URL.absoluteString rangeOfString:@"stop"].location != NSNotFound) {
            recording = false;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd-hh:mm:ss";
            
            NSString *time = [formatter stringFromDate:[NSDate date]];
            
            [filename appendString:@"_"];
            [filename appendString:time];
            [filename appendString:@".gpx"];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
            [root.gpx writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:NULL];
            
            NSMutableString *js = [@"window.newfile('" mutableCopy];
            [js appendString:filename];
            [js appendString:@"','"];
            [js appendString:path];
            [js appendString:@"');"];
            
            [_webView stringByEvaluatingJavaScriptFromString:js];
        } else if ([request.URL.absoluteString rangeOfString:@"mailfile"].location != NSNotFound) {
            NSUInteger urlstart = [request.URL.absoluteString rangeOfString:@"js-frame://mailfile/"].length;
            
            NSString *filepath = [[request.URL.absoluteString substringFromIndex:urlstart] stringByRemovingPercentEncoding];
            NSData *data = [[NSFileManager defaultManager] contentsAtPath:filepath];
            
            MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
            composeVC.mailComposeDelegate = self;
            
            // Configure the fields of the interface.
            [composeVC setSubject:@"GPX File"];
            [composeVC setMessageBody:@"sent form Orienteering GPX Logger iOS app" isHTML:NO];
            [composeVC addAttachmentData:data mimeType:@"application/xml" fileName:[filepath lastPathComponent]];
            
            // Present the view controller modally.
            [self presentViewController:composeVC animated:YES completion:nil];
        } else if ([request.URL.absoluteString rangeOfString:@"delete"].location != NSNotFound) {
            NSUInteger urlstart = [request.URL.absoluteString rangeOfString:@"js-frame://delete/"].length;
            
            NSString *filepath = [[request.URL.absoluteString substringFromIndex:urlstart] stringByRemovingPercentEncoding];
            
            [[NSFileManager defaultManager] removeItemAtPath:filepath error:NULL];
        }
        
        return NO;
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Check the result or perform other tasks.
    
    // Dismiss the mail compose view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    CLLocation *location = [locationManager location];
    
    coordinate = [location coordinate];
    altitude = [location altitude];
}

- (void) record {
    
    root = [GPXRoot rootWithCreator:@"iOS App"];
    track = [root newTrack];
    track.name = @"iOS Track";
    
    while(recording) {
        
        GPXTrackPoint *point = [track newTrackpointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [point setTime:[NSDate date]];
        [point setElevation:altitude];
        
        
        [NSThread sleepForTimeInterval: 1.0];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
