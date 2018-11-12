//
//  OnlineLayerController.m
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/12/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import "OnlineLayerController.h"
#import "Reachability.h"

@interface OnlineLayerController ()

@end

@implementation OnlineLayerController{
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
    
    if ([self checkInternet])
    {
        [self download:@"https://api.neshan.org/points.geojson"];
    }

}

-(void)initViews{
}

// Initializing map
-(void) initMap{
    
    // Creating a VectorElementLayer(called markerLayer) to add all markers to it and adding it to map's layers
    markerLayer = [NTNeshanServices createVectorElementLayer];

    // add Standard_day map to layer BASE_MAP_INDEX
    [[self.map getOptions] setZoomRange:[[NTRange alloc] initWithMin:4.5 max:18]];
    [[self.map getLayers] insert:BASE_MAP_INDEX layer:[NTNeshanServices createBaseMap:NT_STANDARD_DAY]];
    
    // Setting map focal position to a fixed position and setting camera zoom
    [self.map setFocalPointPosition: [[NTLngLat alloc] initWithX:51.330743 y:35.767234] durationSeconds:0];
    [self.map setZoom:14 durationSeconds:0];
}

// Check for Internet connectivity.
-(BOOL) checkInternet{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

// This method gets a LngLat as input and adds a marker on that position
-(void) addMarker:(NTLngLat *)loc {
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


-(void) onJsonDownloaded:(NSData *)jsonData
{
    NSError *err;
    NSDictionary *points = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&err];
    if (err)
        return;
    
    NSArray *features = [points valueForKey:@"features"];
    
    if (features)
    {
        [[self.map getLayers] add:markerLayer];
        // variable for creating bound
        // min = south-west
        // max = north-east
        double minLat = DBL_MAX;
        double minLng = DBL_MAX;
        double maxLat = DBL_MIN;
        double maxLng = DBL_MIN;
        for (int i = 0; i < [features count]; i++) {
            NSDictionary *geometry = [features[i] valueForKey:@"geometry"];
            NSArray *coordinates = [geometry valueForKey:@"coordinates"];
            NTLngLat *lngLat = [[NTLngLat alloc] initWithX:[coordinates[0] doubleValue] y:[coordinates[1] doubleValue]];

            // validating min and max
            minLat = MIN([lngLat getY], minLat);
            minLng = MIN([lngLat getX], minLng);
            maxLat = MAX([lngLat getY], maxLat);
            maxLng = MAX([lngLat getX], maxLng);

            [self addMarker:lngLat];
        }

        CGFloat scale = [UIScreen mainScreen].scale;
        
        NTViewportBounds *viewportBounds = [[NTViewportBounds alloc] initWithMin:[[NTViewportPosition alloc] initWithX:0 y:0] max:[[NTViewportPosition alloc] initWithX:self.map.frame.size.width * scale y:self.map.frame.size.height * scale]];

        NTBounds *bounds=[[NTBounds alloc] initWithMin:[[NTLngLat alloc] initWithX:minLng y:minLat] max:[[NTLngLat alloc] initWithX:maxLng y:maxLat]];
         
        [self.map moveToCameraBounds:bounds viewportBounds:viewportBounds integerZoom:YES durationSeconds:0.25];

    }
}

- (IBAction)toggleOnlineLayer:(id)sender {
    UISwitch *toggleButton = (UISwitch *) sender;
    if ([toggleButton isOn])
    {
        if ([self checkInternet])
        {
            [self download:@"https://api.neshan.org/points.geojson"];
        }
    }
    else
        [[self.map getLayers] remove:markerLayer];
}

-(void) download:(NSString *)urlToDownload {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSURL  *url = [NSURL URLWithString:urlToDownload];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if ( urlData )
        {
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self onJsonDownloaded:urlData];
            });
        }
        
    });
}
@end
