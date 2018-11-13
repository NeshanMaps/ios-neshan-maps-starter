//
//  AddLabelController.m
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/5/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import "AddLabelController.h"
#import <NeshanMobileSDK/NeshanMobileSDK.h>
#import "NeshanHelper.h"

@interface AddLabelController ()

@end

@implementation AddLabelController {
    // layer number in which map is added
    #define BASE_MAP_INDEX 0

    // map UI element
    NTMapView *map;
    // You can add some elements to a VectorElementLayer
    NTVectorElementLayer *labelLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    map = [NTMapView new];

    // Creating a VectorElementLayer(called labelLayer) to add all labels to it and adding it to map's layers
    labelLayer = [NTNeshanServices createVectorElementLayer];
    [[map getLayers] add:labelLayer];


    // add Standard_day map to layer BASE_MAP_INDEX
    [[map getOptions] setZoomRange:[[NTRange alloc] initWithMin:4.5 max:18]];
    NTLayer *baseMap = [NTNeshanServices createBaseMap:NT_STANDARD_DAY];
    // layer number in which map is added
    [[map getLayers] insert:BASE_MAP_INDEX layer:baseMap];
    
    // Setting map focal position to a fixed position and setting camera zoom
    [map setFocalPointPosition: [[NTLngLat alloc] initWithX:51.330743 y:35.767234] durationSeconds: 0];
    [map setZoom:14 durationSeconds:0];


    self.view=map;
    
    // when long clicked on map, a label is added in clicked location
    // MapEventListener gets all events on map, including single tap, double tap, long press, etc
    // we should check event type by calling getClickType() on mapClickInfo (from ClickData class)
    MapEventListener *mapEventListener = [MapEventListener new];
    mapEventListener.onMapClickedBlock = ^(NTClickData * _Nonnull clickInfo) {
        
        if ([clickInfo getClickType] == NT_CLICK_TYPE_LONG) {
            // by calling getClickPos(), we can get position of clicking (or tapping)
            NTLngLat *clickedLocation = [clickInfo getClickPos];
            // addMarker adds a label (pretty self explanatory :D) to the clicked location
            [self addLabel:clickedLocation];
        }
    };
    
    [map setMapEventListener:mapEventListener];
}

// This method gets a LngLat as input and adds a label on that position
-(void) addLabel:(NTLngLat *)loc {
    // First, we should clear every label that is currently located on map
    [labelLayer clear];
    
    // Creating label style. We should use an object of type LabelStyleCreator, set all features on it
    // and then call buildStyle method on it. This method returns an object of type LabelStyle
    NTLabelStyleCreator *labelStCr = [NTLabelStyleCreator new];
    [labelStCr setFontSize:15];
    [labelStCr setBackgroundColor:[[NTARGB alloc] initWithR:255 g:255 b:255 a:255]];
    NTLabelStyle *labelSt = [labelStCr buildStyle];
    
    // Creating label
    NTLabel *label = [[NTLabel alloc] initWithPos:loc style:labelSt text:@"مکان انتخاب شده"];
    
    // Adding label to labelLayer, or showing label on map!
    [labelLayer add:label];
}

@end
