//
//  ChangeStyleController.m
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/10/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import "ChangeStyleController.h"
#import "NeshanHelper.h"

@interface ChangeStyleController ()

@end

@implementation ChangeStyleController{
    // layer number in which map is added
    #define BASE_MAP_INDEX 0
    
    // save current map style
    NTNeshanMapStyle mapStyle;

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
    // Initializing theme preview
    [self validateThemePreview];
}

-(void) validateThemePreview {
    switch (mapStyle) {
        case NT_STANDARD_DAY:
            [self.themePreview setImage:[UIImage imageNamed:@"map_style_standard_night"] forState:UIControlStateNormal];
            break;
        case NT_STANDARD_NIGHT:
            [self.themePreview setImage:[UIImage imageNamed:@"map_style_neshan"] forState:UIControlStateNormal];
            break;
        case NT_NESHAN:
            [self.themePreview setImage:[UIImage imageNamed:@"map_style_standard_day"] forState:UIControlStateNormal];
            break;
    }
    
    [NeshanHelper toast:self message:mapStyle ==  NT_STANDARD_DAY ? @"روز استاندارد":mapStyle ==  NT_STANDARD_NIGHT ? @"شب استاندارد" : @"نشان"];
}

-(void)initViews{
}

// Initializing map
-(void) initMap{
    
    // add Standard_day map to layer BASE_MAP_INDEX
    [[self.map getOptions] setZoomRange:[[NTRange alloc] initWithMin:4.5 max:18]];
    mapStyle = NT_STANDARD_DAY;
    [[self.map getLayers] insert:BASE_MAP_INDEX layer:[NTNeshanServices createBaseMap:mapStyle]];
    
    // Setting map focal position to a fixed position and setting camera zoom
    [self.map setFocalPointPosition: [[NTLngLat alloc] initWithX:51.330743 y:35.767234] durationSeconds:0];
    [self.map setZoom:14 durationSeconds:0];
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
}

@end
