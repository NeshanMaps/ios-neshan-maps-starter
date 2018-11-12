//
//  DrawLineController.m
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/6/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import "DrawLineController.h"

@interface DrawLineController ()

@end

@implementation DrawLineController {
    // layer number in which map is added
    int BASE_MAP_INDEX;

    // You can add some elements to a VectorElementLayer. We add lines to this layer.
    NTVectorElementLayer *lineLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BASE_MAP_INDEX = 0;
    
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
    // Creating a VectorElementLayer(called markerLayer) to add all markers to it and adding it to map's layers
    lineLayer = [NTNeshanServices createVectorElementLayer];
    [[self.map getLayers] add:lineLayer];
    
    // add Standard_day map to layer BASE_MAP_INDEX
    [[self.map getOptions] setZoomRange:[[NTRange alloc] initWithMin:4.5 max:18]];
    [[self.map getLayers] insert:BASE_MAP_INDEX layer:[NTNeshanServices createBaseMap:NT_STANDARD_DAY]];
    
    // Setting map focal position to a fixed position and setting camera zoom
    [self.map setFocalPointPosition: [[NTLngLat alloc] initWithX:51.330743 y:35.767234] durationSeconds:0];
    [self.map setZoom:14 durationSeconds:0];
}

// Drawing line on map
- (IBAction)drawLineGeom:(id)sender{
    // we clear every line that is currently on map
    [lineLayer clear];
    // Adding some LngLat points to a LngLatVector
    NTLngLatVector *lngLatVector = [NTLngLatVector new];
    [lngLatVector add:[[NTLngLat alloc] initWithX:51.327650 y:35.769368]];
    [lngLatVector add:[[NTLngLat alloc] initWithX:51.323889 y:35.756670]];
    [lngLatVector add:[[NTLngLat alloc] initWithX:51.383889 y:35.746670]];
    // Creating a lineGeom from LngLatVector
    NTLineGeom *lineGeom = [[NTLineGeom alloc] initWithPoses:lngLatVector];
    // Creating a line from LineGeom. here we use getLineStyle() method to define line styles
    NTLine *line = [[NTLine alloc] initWithGeometry:lineGeom style:[self getLineStyle]];
    // adding the created line to lineLayer, showing it on map
    [lineLayer add:line];
    // focusing camera on first point of drawn line
    [self.map setFocalPointPosition: [[NTLngLat alloc] initWithX:51.327650 y:35.769368] durationSeconds:0.25];
    [self.map setZoom:14 durationSeconds:0];
}

// In this method we create a LineStyleCreator, set its features and call buildStyle() method
// on it and return the LineStyle object (the same routine as crating a marker style)
-(NTLineStyle *)getLineStyle{
    NTLineStyleCreator *lineStCr = [NTLineStyleCreator new];
    [lineStCr setColor: [[NTARGB alloc] initWithR:2 g:119 b:189 a:190]];
    [lineStCr setWidth:12];
    [lineStCr setStretchFactor:0];
    return [lineStCr buildStyle];
}

@end
