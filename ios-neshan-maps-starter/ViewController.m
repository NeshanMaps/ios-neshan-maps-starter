//
//  ViewController.m
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/4/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import "ViewController.h"
#import <NeshanMobileSDK/NeshanMobileSDK.h>

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


@end
