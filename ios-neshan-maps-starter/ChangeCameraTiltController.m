//
//  ChangeCameraTiltController.m
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/10/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import "ChangeCameraTiltController.h"
#import "NeshanHelper.h"


@interface ChangeCameraTiltController ()

@end

@implementation ChangeCameraTiltController{
    // layer number in which map is added
    #define BASE_MAP_INDEX 0
    
    BOOL isCameraTiltEnable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isCameraTiltEnable = true;
    // everything related to ui is initialized here
    [self initLayoutReferences];

//    // sync map with tilt controller
    MapEventListener *mapEventListener = [MapEventListener new];
    // detect user input ( zoom, change tilt, change bearing, etc )
    mapEventListener.onMapMovedBlock = ^(){
        
        // updating own ui element must run on ui thread not in map ui thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.tiltSlider.value !=[self.map getTilt])
                [self.tiltSlider setValue:[self.map getTilt]];
        });
    };
    
    [self.map setMapEventListener: mapEventListener];
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
}

- (IBAction)sliderChanged:(id)sender {
    // change camera tilt programmatically

    if ([self.map getTilt] != self.tiltSlider.value)
        [self.map setTilt:self.tiltSlider.value durationSeconds:0];
}

- (IBAction)toggleCameraTilt:(id)sender{
//    UISwitch *toggleButton = (UISwitch *) sender;
//    isCameraTiltEnable = !isCameraTiltEnable;
//    if ([toggleButton isOn])
//        //set tilt range from 30 to 90 degrees
//        [[map getOptions] setTiltRange:[[NTRange alloc] initWithMin:30 max:90]];
//    else
//        //set tilt range to 1 degree (only current tilt degree)
//        [[map getOptions] setTiltRange:[[NTRange alloc] initWithMin:[map getTilt] max:[map getTilt]]];
}

@end
