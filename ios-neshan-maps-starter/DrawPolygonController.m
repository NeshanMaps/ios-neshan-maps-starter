//
//  DrawPolygonController.m
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/6/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import "DrawPolygonController.h"
#import <NeshanMobileSDK/NeshanMobileSDK.h>

@interface DrawPolygonController ()

@end

@implementation DrawPolygonController {
    // layer number in which map is added
    int BASE_MAP_INDEX;

    // map UI element
    NTMapView *map;

    // You can add some elements to a VectorElementLayer. We add polygons to this layer.
    NTVectorElementLayer *polygonLayer;
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
    // Creating a VectorElementLayer(called markerLayer) to add all markers to it and adding it to map's layers
    polygonLayer = [NTNeshanServices createVectorElementLayer];
    [[map getLayers] add:polygonLayer];
    
    // add Standard_day map to layer BASE_MAP_INDEX
    [[map getOptions] setZoomRange:[[NTRange alloc] initWithMin:4.5 max:18]];
    [[map getLayers] insert:BASE_MAP_INDEX layer:[NTNeshanServices createBaseMap:NT_STANDARD_DAY]];
    
    // Setting map focal position to a fixed position and setting camera zoom
    [map setFocalPointPosition: [[NTLngLat alloc] initWithX:51.330743 y:35.767234] durationSeconds:0];
    [map setZoom:14 durationSeconds:0];
}

// Drawing polygon on map
- (IBAction)drawPolygonGeom:(id)sender{
    // we clear every polygon that is currently on map
    [polygonLayer clear];
    // Adding some LngLat points to a LngLatVector
    NTLngLatVector *lngLatVector = [NTLngLatVector new];
    [lngLatVector add:[[NTLngLat alloc] initWithX:51.325525 y:35.762294]];
    [lngLatVector add:[[NTLngLat alloc] initWithX:51.323768 y:35.756548]];
    [lngLatVector add:[[NTLngLat alloc] initWithX:51.328617 y:35.755394]];
    [lngLatVector add:[[NTLngLat alloc] initWithX:51.330666 y:35.760905]];
    // Creating a polygonGeom from LngLatVector
    NTPolygonGeom *polygonGeom = [[NTPolygonGeom alloc] initWithPoses:lngLatVector];
    // Creating a polygon from PolygonGeom. here we use getPolygonStyle() method to define polygon styles
    NTPolygon *polygon = [[NTPolygon alloc] initWithGeometry:polygonGeom style:[self getPolygonStyle]];
    // adding the created polygon to polygonLayer, showing it on map
    [polygonLayer add:polygon];
    // focusing camera on first point of drawn polygon
    [map setFocalPointPosition: [[NTLngLat alloc] initWithX:51.327650 y:35.769368] durationSeconds:0.25];
    [map setZoom:14 durationSeconds:0];
}

- (IBAction)tiltSlider:(id)sender {
}

// In this method we create a PolygonStyleCreator and set its features.
// One feature is its lineStyle, getLineStyle() method is used to get polygon's line style
// By calling buildStyle() method on polygonStrCr, an object of type PolygonStyle is returned
-(NTPolygonStyle *)getPolygonStyle{
    NTPolygonStyleCreator *polygonStCr = [NTPolygonStyleCreator new];
    [polygonStCr setLineStyle:[self getLineStyle]];
    return [polygonStCr buildStyle];
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
