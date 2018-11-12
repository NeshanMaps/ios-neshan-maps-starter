//
//  UserLocationController.m
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/11/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import "UserLocationController.h"
#import "NeshanHelper.h"

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

-(void)initViews{
}

// Initializing map
-(void) initMap{
    
    // Creating a VectorElementLayer(called userMarkerLayer) to add user marker to it and adding it to map's layers
    userMarkerLayer = [NTNeshanServices createVectorElementLayer];
    [[self.map getLayers] add:userMarkerLayer];
    
    // add Standard_da_mapap to layer BASE_MAP_INDEX
    [[self.map getOptions] setZoomRange:[[NTRange alloc] initWithMin:4.5 max:18]];
    [[self.map getLayers] insert:BASE_MAP_INDEX layer:[NTNeshanServices createBaseMap:NT_STANDARD_DAY]];
    
    // Setting map focal position to a fixed position and setting camera zoom
    [self.map setFocalPointPosition: [[NTLngLat alloc] initWithX:51.330743 y:35.767234] durationSeconds:0];
    [self.map setZoom:14 durationSeconds:0];
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
    [NeshanHelper toast:self message:@"عدم موفقیت در گرفتن مکان"];
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
        [self.map setFocalPointPosition:
         [[NTLngLat alloc] initWithX:userLocation.coordinate.longitude y:userLocation.coordinate.latitude] durationSeconds:0.25f];
         [self.map setZoom:15 durationSeconds:.25];
    }
}
@end
