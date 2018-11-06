//
//  DrawLineController.m
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/6/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import "DrawLineController.h"
#import <NeshanMobileSDK/NeshanMobileSDK.h>

@interface DrawLineController ()

@end

@implementation DrawLineController {
    // layer number in which map is added
    int BASE_MAP_INDEX;

    // map UI element
    NTMapView *map;

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

// We use findViewByID for every element in our layout file here
-(void)initViews{
    map = [NTMapView new];
    map.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view insertSubview:map atIndex:0];

    NSLayoutConstraint *width =[NSLayoutConstraint
                                constraintWithItem:map
                                attribute:NSLayoutAttributeWidth
                                relatedBy:0
                                toItem:self.view
                                attribute:NSLayoutAttributeWidth
                                multiplier:1.0
                                constant:0];
    NSLayoutConstraint *height =[NSLayoutConstraint
                                 constraintWithItem:map
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:0
                                 toItem:self.view
                                 attribute:NSLayoutAttributeHeight
                                 multiplier:1.0
                                 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:map
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.view
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0f
                               constant:0.f];
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:map
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f];
    [self.view addConstraint:width];
    [self.view addConstraint:height];
    [self.view addConstraint:top];
    [self.view addConstraint:leading];
    
}

// Initializing map
-(void) initMap{
    // Creating a VectorElementLayer(called markerLayer) to add all markers to it and adding it to map's layers
    lineLayer = [NTNeshanServices createVectorElementLayer];
    [[map getLayers] add:lineLayer];
    
    // add Standard_day map to layer BASE_MAP_INDEX
    [[map getOptions] setZoomRange:[[NTRange alloc] initWithMin:4.5 max:18]];
    [[map getLayers] insert:BASE_MAP_INDEX layer:[NTNeshanServices createBaseMap:NT_STANDARD_DAY]];
    
    // Setting map focal position to a fixed position and setting camera zoom
    [map setFocalPointPosition: [[NTLngLat alloc] initWithX:51.330743 y:35.767234] durationSeconds:0];
    [map setZoom:14 durationSeconds:0];
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
    NTVectorElementLayer *lineLayer = [NTNeshanServices createVectorElementLayer];
    [lineLayer add:line];
    // focusing camera on first point of drawn line
    [map setFocalPointPosition: [[NTLngLat alloc] initWithX:51.327650 y:35.769368] durationSeconds:0.25];
    [map setZoom:14 durationSeconds:0];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
