//
//  TrafficLayerController.m
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/12/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import "TrafficLayerController.h"

@interface TrafficLayerController ()

@end

@implementation TrafficLayerController{
    // layer number in which map is added
    #define BASE_MAP_INDEX 0
    #define TRAFFIC_INDEX 1
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // everything related to ui is initialized here
    [self initLayoutReferences];
}

// Initializing layout references (views, map and map events)
-(void)initLayoutReferences {
    // Initializing views
    [self initViews];
    // Initializing mapView element
    [self initMap];
}

-(void)initViews{
}

// Initializing map
-(void) initMap{
    
    // add Standard_day map to layer BASE_MAP_INDEX
    [[self.map getOptions] setZoomRange:[[NTRange alloc] initWithMin:4.5 max:18]];
    [[self.map getLayers] insert:BASE_MAP_INDEX layer:[NTNeshanServices createBaseMap:NT_STANDARD_DAY]];
    
    // Setting map focal position to a fixed position and setting camera zoom
    [self.map setFocalPointPosition: [[NTLngLat alloc] initWithX:51.330743 y:35.767234] durationSeconds:0];
    [self.map setZoom:14 durationSeconds:0];

    // adding traffic layer to TRAFFIC_INDEX
    [[self.map getLayers] insert:TRAFFIC_INDEX layer: [NTNeshanServices createTrafficLayer]];
}

- (IBAction)toggleTrafficLayer:(id)sender {
    UISwitch *toggleButton = (UISwitch *) sender;
    if ([toggleButton isOn])
        [[self.map getLayers] insert:TRAFFIC_INDEX layer:[NTNeshanServices createTrafficLayer]];
    else
        [[self.map getLayers] remove:[[self.map getLayers] get:TRAFFIC_INDEX]];
}

@end
