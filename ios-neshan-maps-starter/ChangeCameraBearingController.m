//
//  ChangeCameraBearingController.m
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/10/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import "ChangeCameraBearingController.h"
#import <NeshanMobileSDK/NeshanMobileSDK.h>
#import "NeshanHelper.h"


@interface ChangeCameraBearingController ()

@end

@implementation ChangeCameraBearingController{
    // layer number in which map is added
    #define BASE_MAP_INDEX 0
    
    // map UI element
    NTMapView *map;
    
    BOOL isCameraRotationEnable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isCameraRotationEnable = true;
    // everything related to ui is initialized here
    [self initLayoutReferences];

//    // sync map with bearing controller
    MapEventListener *mapEventListener = [MapEventListener new];
    // detect user input ( zoom, change bearing, change bearing, etc )
    mapEventListener.onMapMovedBlock = ^(){
        
        // updating own ui element must run on ui thread not in map ui thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.bearingSlider.value !=[self->map getBearing])
                [self.bearingSlider setValue:[self->map getBearing]];
        });
    };
    
    [map setMapEventListener: mapEventListener];
}

// Initializing layout references (views, map and map events)
-(void)initLayoutReferences {
    // Initializing views
    [self initViews];
    // Initializing mapView element
    [self initMap];
}

// We use findViewByID for every element in our layout file here
-(void)initViews{
    map = [NTMapView new];
    map.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view insertSubview:map atIndex:0];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[map]-0-|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(map)]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[map]-0-|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(map)]];
}

// Initializing map
-(void) initMap{
    
    // add Standard_day map to layer BASE_MAP_INDEX
    [[map getOptions] setZoomRange:[[NTRange alloc] initWithMin:4.5 max:18]];
    [[map getLayers] insert:BASE_MAP_INDEX layer:[NTNeshanServices createBaseMap:NT_STANDARD_DAY]];
    
    // Setting map focal position to a fixed position and setting camera zoom
    [map setFocalPointPosition: [[NTLngLat alloc] initWithX:51.330743 y:35.767234] durationSeconds:0];
    [map setZoom:14 durationSeconds:0];
}

- (IBAction)sliderChanged:(id)sender {
    // change camera bearing programmatically

    if ([map getBearing] != self.bearingSlider.value)
        [map setBearing:self.bearingSlider.value durationSeconds:0];
}

- (IBAction)toggleCameraBearing:(id)sender{
    UISwitch *toggleButton = (UISwitch *) sender;
    isCameraRotationEnable = !isCameraRotationEnable;
    if ([toggleButton isOn])
    {
        [self.bearingSlider setEnabled:YES];
        [[map getOptions] setUserInput:YES];
    }
    else
    {
        [self.bearingSlider setEnabled:NO];
        [[map getOptions] setUserInput:NO];
    }
}

@end
