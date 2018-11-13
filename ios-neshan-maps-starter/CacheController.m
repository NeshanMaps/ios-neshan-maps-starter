//
//  CacheController.m
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/13/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import "CacheController.h"

@interface CacheController ()

@end

@implementation CacheController{
    // layer number in which map is added
    #define BASE_MAP_INDEX 0
    #define POI_INDEX 1
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

    // Cache base map
    // Cache size is 10 MB
    [[self.map getLayers] insert:BASE_MAP_INDEX layer:[NTNeshanServices createBaseMap:NT_STANDARD_DAY ]];
    
    // Setting map focal position to a fixed position and setting camera zoom
    [self.map setFocalPointPosition: [[NTLngLat alloc] initWithX:51.330743 y:35.767234] durationSeconds:0];
    [self.map setZoom:14 durationSeconds:0];
    
    // adding POI layer to POI_INDEX
    [[self.map getLayers] insert:POI_INDEX layer:[NTNeshanServices createPOILayer:mapStyle == NT_STANDARD_NIGHT]];
}

- (IBAction)changeStyle:(id)sender {
    NTNeshanMapStyle previousMapStyle = mapStyle;
    switch (previousMapStyle) {
        case NT_STANDARD_DAY:
            mapStyle = NT_STANDARD_NIGHT;
            break;
        case NT_STANDARD_NIGHT:
            mapStyle = NT_NESHAN;
            break;
        case NT_NESHAN:
            mapStyle = NT_STANDARD_DAY;
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self validateThemePreview];
    });
    [[self.map getLayers] remove:[[self.map getLayers] get:BASE_MAP_INDEX]] ;
    [[self.map getLayers] insert:BASE_MAP_INDEX layer: [NTNeshanServices createBaseMap:mapStyle]];
    if (isPOIEnable)
    {
        [[self.map getLayers] remove:[[self.map getLayers] get:POI_INDEX]] ;
        [[self.map getLayers] insert:POI_INDEX layer: [NTNeshanServices createPOILayer:mapStyle == NT_STANDARD_NIGHT]];
    }
}

- (IBAction)togglePOILayer:(id)sender {
    UISwitch *toggleButton = (UISwitch *) sender;
    isPOIEnable = !isPOIEnable;
    if ([toggleButton isOn])
        [[self.map getLayers] insert:POI_INDEX layer:[NTNeshanServices createPOILayer:mapStyle == NT_STANDARD_NIGHT]];
    else
        [[self.map getLayers] remove:[[self.map getLayers] get:POI_INDEX]];
}

@end
