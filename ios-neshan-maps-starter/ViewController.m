//
//  ViewController.m
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/4/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import "ViewController.h"
#import <NeshanMobileSDK/NeshanMobileSDK.h>
#import "DrawLineController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.version.text = [NSString stringWithFormat:@"نگارش: %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];

//    NTMapView *mapview = [NTMapView new];
//    NTLayer *neshan = [NTNeshanServices createBaseMap:NT_NESHAN];
//    [[mapview getLayers] add:neshan];
//
//    NTLayer *neshan2 = [NTNeshanServices createTrafficLayer];
//    [[mapview getLayers] add:neshan2];
//
//    NTLayer *neshan3 = [NTNeshanServices createPOILayer:NO];
//    [[mapview getLayers] add:neshan3];
//
//    [mapview setFocalPointPosition: [[NTLngLat alloc] initWithX:59.2 y:36.5] durationSeconds: 0.4];
//    [mapview setZoom:13 durationSeconds:0.4];
//    self.view=mapview;
}


- (IBAction)siteClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://developer.neshan.org/"]];
}

- (IBAction)sourceCodeClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/NeshanMaps/ios-neshan-maps-starter"]];

}

- (IBAction)test:(id)sender {
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DrawLineController"];
    [self presentViewController:vc animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [vc dismissViewControllerAnimated:YES completion:nil];
    });
}
@end
