//
//  UserLocationController.m
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/11/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import "UserLocationController.h"
#import <NeshanMobileSDK/NeshanMobileSDK.h>

@interface UserLocationController ()

@end

@implementation UserLocationController{
    // layer number in which map is added
    #define BASE_MAP_INDEX 0
    
    // location updates interval - 1 sec
    #define UPDATE_INTERVAL_IN_MILLISECONDS 1000
    // fastest updates interval - 1 sec
    // location updates will be received if another app is requesting the locations
    // than your app can handle
    #define FASTEST_UPDATE_INTERVAL_IN_MILLISECONDS 1000
    
    // map UI element
    NTMapView *map;
    
    // You can add some elements to a VectorElementLayer
    NTVectorElementLayer *userMarkerLayer;
    
    // User's current location
    CLLocation *userLocation;
    CLLocationManager *locationManager;

    NSString *lastUpdateTime;
    // boolean flag to toggle the ui
    BOOL mRequestingLocationUpdates;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // everything related to ui is initialized here
    [self initLayoutReferences];
    // Initializing user location
    [self initLocation];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self startLocationUpdates];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self stopLocationUpdates];
}

// Initializing layout references (views, map and map events)
-(void)initLayoutReferences {
    // Initializing views
    [self initViews];
    // Initializing mapView element
    [self initMap];
}

-(void) toast:(NSString *)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
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
    
    // Creating a VectorElementLayer(called userMarkerLayer) to add user marker to it and adding it to map's layers
    userMarkerLayer = [NTNeshanServices createVectorElementLayer];
    [[map getLayers] add:userMarkerLayer];
    
    // add Standard_day map to layer BASE_MAP_INDEX
    [[map getOptions] setZoomRange:[[NTRange alloc] initWithMin:4.5 max:18]];
    [[map getLayers] insert:BASE_MAP_INDEX layer:[NTNeshanServices createBaseMap:NT_STANDARD_DAY]];
    
    // Setting map focal position to a fixed position and setting camera zoom
    [map setFocalPointPosition: [[NTLngLat alloc] initWithX:51.330743 y:35.767234] durationSeconds:0];
    [map setZoom:14 durationSeconds:0];
}

-(void) initLocation{
    // Create a location manager
    locationManager = [[CLLocationManager alloc] init];
    // Set a delegate to receive location callbacks
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self toast:@"عدم موفقیت در گرفتن مکان"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)location fromLocation:(CLLocation *)oldLocation
{
    if (location != nil)
    {
        userLocation = location;
        [self onLocationChange];
    }
}


/**
 * Starting location updates
 * Check whether location settings are satisfied and then
 * location updates will be requested
 */
-(void) startLocationUpdates {
    // Start the location manager
    [locationManager startUpdatingLocation];
}

-(void) stopLocationUpdates {
    // Stop the location manager
    [locationManager  stopUpdatingLocation];
}

-(void) onLocationChange {
    if(userLocation != nil) {
        [self addUserMarker:[[NTLngLat alloc] initWithX:userLocation.coordinate.longitude y:userLocation.coordinate.latitude]];
    }
}


// This method gets a LngLat as input and adds a marker on that position
-(void) addUserMarker:(NTLngLat *)loc{
    // Creating marker style. We should use an object of type MarkerStyleCreator, set all features on it
    // and then call buildStyle method on it. This method returns an object of type MarkerStyle
    NTMarkerStyleCreator *markStCr = [NTMarkerStyleCreator new];
    [markStCr setSize:20];

    [markStCr setBitmap:[NTBitmapUtils createBitmapFromUIImage:[UIImage imageNamed:@"ic_marker"]]];
    NTMarkerStyle *markSt = [markStCr buildStyle];
    
    // Creating user marker
    NTMarker *marker = [[NTMarker alloc] initWithPos:loc style:markSt];
    
    // Clearing userMarkerLayer
    [userMarkerLayer clear];
    
    // Adding user marker to userMarkerLayer, or showing marker on map!
    [userMarkerLayer add:marker];
}

- (IBAction)focusOnUserLocation:(id)sender {
    if(userLocation != nil) {
        [map setFocalPointPosition:
         [[NTLngLat alloc] initWithX:userLocation.coordinate.longitude y:userLocation.coordinate.latitude] durationSeconds:0.25f];
         [map setZoom:15 durationSeconds:.25];
    }
}
@end
