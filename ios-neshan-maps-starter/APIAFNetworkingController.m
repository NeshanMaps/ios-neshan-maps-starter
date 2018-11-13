//
//  APIAFNetworkingController.m
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/13/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import "APIAFNetworkingController.h"
#import <AFNetworking.h>
#import "NeshanHelper.h"

@interface APIAFNetworkingController ()

@end

@implementation APIAFNetworkingController{
    // layer number in which map is added
    #define BASE_MAP_INDEX 0
    
    // You can add some elements to a VectorElementLayer
    NTVectorElementLayer *markerLayer;    
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

    // when long clicked on map, a marker is added in clicked location
    // MapEventListener gets all events on map, including single tap, double tap, long press, etc
    // we should check event type by calling getClickType() on mapClickInfo (from ClickData class)
    MapEventListener *mapEventListener = [MapEventListener new];
    mapEventListener.onMapClickedBlock = ^(NTClickData * _Nonnull clickInfo) {
        
        if ([clickInfo getClickType] == NT_CLICK_TYPE_LONG) {
            // by calling getClickPos(), we can get position of clicking (or tapping)
            NTLngLat *clickedLocation = [clickInfo getClickPos];
            // addMarker adds a marker (pretty self explanatory :D) to the clicked location
            [self addMarker:clickedLocation];

            //calling NeshanReverseAPI to get address of a location and showing it on a bottom sheet
            [self neshanReverseAPI:clickedLocation];
        }
    };
    
    [self.map setMapEventListener:mapEventListener];
}

-(void)initViews{
}

// Initializing map
-(void) initMap{
    // Creating a VectorElementLayer(called markerLayer) to add all markers to it and adding it to map's layers
    markerLayer = [NTNeshanServices createVectorElementLayer];
    [[self.map getLayers] add:markerLayer];
    
    // add Standard_day map to layer BASE_MAP_INDEX
    [[self.map getOptions] setZoomRange:[[NTRange alloc] initWithMin:4.5 max:18]];
    [[self.map getLayers] insert:BASE_MAP_INDEX layer:[NTNeshanServices createBaseMap:NT_STANDARD_DAY]];
    
    // Setting map focal position to a fixed position and setting camera zoom
    [self.map setFocalPointPosition: [[NTLngLat alloc] initWithX:51.330743 y:35.767234] durationSeconds:0];
    [self.map setZoom:14 durationSeconds:0];
}

// This method gets a LngLat as input and adds a marker on that position
-(void) addMarker:(NTLngLat *)loc {
    // First, we should clear every marker that is currently located on map
    [markerLayer clear];
    
    // Creating animation for marker. We should use an object of type AnimationStyleBuilder, set
    // all animation features on it and then call buildStyle() method that returns an object of type
    // AnimationStyle
    NTAnimationStyleBuilder *animStBl = [NTAnimationStyleBuilder new];
    [animStBl setFadeAnimationType:NT_ANIMATION_TYPE_SMOOTHSTEP];
    [animStBl setSizeAnimationType:NT_ANIMATION_TYPE_SPRING];
    [animStBl setPhaseInDuration:0.5];
    [animStBl setPhaseOutDuration:0.5];
    NTAnimationStyle *animSt = [animStBl buildStyle];
    
    // Creating marker style. We should use an object of type MarkerStyleCreator, set all features on it
    // and then call buildStyle method on it. This method returns an object of type MarkerStyle
    NTMarkerStyleCreator *markStCr = [NTMarkerStyleCreator new];
    [markStCr setSize:20];
    [markStCr setBitmap:[NTBitmapUtils createBitmapFromUIImage:[UIImage imageNamed:@"ic_marker"]]];
    // AnimationStyle object - that was created before - is used here
    [markStCr setAnimationStyle:animSt];
    NTMarkerStyle *markSt = [markStCr buildStyle];
    
    // Creating marker
    NTMarker *marker = [[NTMarker alloc] initWithPos:loc style:markSt];
    
    // Adding marker to markerLayer, or showing marker on map!
    [markerLayer add:marker];
}

-(void) neshanReverseAPI:(NTLngLat *)loc {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *requestURL = [NSString stringWithFormat:@"https://api.neshan.org/v2/reverse?lat=%f&lng=%f", [loc getY], [loc getX]];
    NSString *latLngAddr = [NSString stringWithFormat:@"%.6f, %.6f", [loc getY], [loc getX]];
    
    NSURL *URL = [NSURL URLWithString:requestURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setValue:API_KEY forHTTPHeaderField:@"Api-Key"];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error || responseObject == nil || ![responseObject isKindOfClass:[NSDictionary class]]) {
            [self.addressTitle setText:@"آدرس نامشخص"];
            [self.addressDetails setText:latLngAddr];
        } else {
            
            if ([responseObject objectForKey:@"neighbourhood"] != [NSNull null])
                [self.addressTitle setText:[responseObject objectForKey:@"neighbourhood"]];
            else
                [self.addressTitle setText:@"آدرس نامشخص"];
            
            if ([responseObject objectForKey:@"formatted_address"] != [NSNull null])
                [self.addressDetails setText:[responseObject objectForKey:@"formatted_address"]];
            else
                [self.addressDetails setText:latLngAddr];
        }
    }];
    [dataTask resume];
}


@end
