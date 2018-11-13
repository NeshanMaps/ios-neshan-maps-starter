//
//  RemoveMarkerController.m
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/5/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import "RemoveMarkerController.h"
#import <NeshanMobileSDK/NeshanMobileSDK.h>
#import "NeshanHelper.h"

@interface RemoveMarkerController ()

@end

@implementation RemoveMarkerController {
    // layer number in which map is added
    int BASE_MAP_INDEX;

    // map UI element
    NTMapView *map;
    // You can add some elements to a VectorElementLayer
    NTVectorElementLayer *markerLayer;
    // Marker that will be added on map
    NTMarker *marker;
    // an id for each marker
    long markerId;
    // marker animation style
    NTAnimationStyle *animSt;

    // save selected Marker for select and deselect function
    NTMarker *selectedMarker;
    // Tip Strings
    NSString *firstTipString;
    NSString *secondTipString;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    BASE_MAP_INDEX = 0;
    markerId = 0;
    selectedMarker = nil;
    firstTipString = @"<b>قدم اول:</b> برای ایجاد پین جدید نگهدارید!";
    secondTipString = @"<b>قدم دوم:</b> برای حذف روی پین لمس کنید!";

    map = [NTMapView new];

    // Creating a VectorElementLayer(called markerLayer) to add all markers to it and adding it to map's layers
    markerLayer = [NTNeshanServices createVectorElementLayer];
    [[map getLayers] add:markerLayer];


    // add Standard_day map to layer BASE_MAP_INDEX
    [[map getOptions] setZoomRange:[[NTRange alloc] initWithMin:4.5 max:18]];
    NTLayer *baseMap = [NTNeshanServices createBaseMap:NT_STANDARD_DAY];
    // layer number in which map is added
    [[map getLayers] insert:BASE_MAP_INDEX layer:baseMap];
    
    // Setting map focal position to a fixed position and setting camera zoom
    [map setFocalPointPosition: [[NTLngLat alloc] initWithX:51.330743 y:35.767234] durationSeconds: 0];
    [map setZoom:14 durationSeconds:0];


    self.view=map;
    
    // when long clicked on map, a marker is added in clicked location
    // MapEventListener gets all events on map, including single tap, double tap, long press, etc
    // we should check event type by calling getClickType() on mapClickInfo (from ClickData class)
    MapEventListener *mapEventListener = [MapEventListener new];
    mapEventListener.onMapClickedBlock = ^(NTClickData * _Nonnull clickInfo) {
        
        if ([clickInfo getClickType] == NT_CLICK_TYPE_LONG) {
            // by calling getClickPos(), we can get position of clicking (or tapping)
            NTLngLat *clickedLocation = [clickInfo getClickPos];
            // removeMarker adds a marker (pretty self explanatory :D) to the clicked location
            [self addMarker:clickedLocation withId:markerId];
            // increment id
            markerId++;
        }
    };
    
    [map setMapEventListener:mapEventListener];
}

// This method gets a LngLat as input and adds a marker on that position
-(void) addMarker:(NTLngLat *)loc withId:(long)_id {
    // If you want to have only one marker on map at a time, uncomment next line to delete all markers before adding a new marker
    //        markerLayer.clear();
    
    // Creating animation for marker. We should use an object of type AnimationStyleBuilder, set
    // all animation features on it and then call buildStyle() method that returns an object of type
    // AnimationStyle
    NTAnimationStyleBuilder *animStBl = [NTAnimationStyleBuilder new];
    [animStBl setFadeAnimationType:NT_ANIMATION_TYPE_SMOOTHSTEP];
    [animStBl setSizeAnimationType:NT_ANIMATION_TYPE_SPRING];
    [animStBl setPhaseInDuration:0.5f];
    [animStBl setPhaseOutDuration:0.5f];
    NTAnimationStyle *animSt = [animStBl buildStyle];
    
    // Creating marker style. We should use an object of type MarkerStyleCreator, set all features on it
    // and then call buildStyle method on it. This method returns an object of type MarkerStyle
    NTMarkerStyleCreator *markStCr = [NTMarkerStyleCreator new];
    [markStCr setSize:30];

    [markStCr setBitmap:[NTBitmapUtils createBitmapFromUIImage:[UIImage imageNamed:@"ic_marker"]]];
    // AnimationStyle object - that was created before - is used here
    [markStCr setAnimationStyle:animSt];
    NTMarkerStyle *markSt = [markStCr buildStyle];
    
    // Creating marker
    NTMarker *marker = [[NTMarker alloc] initWithPos:loc style:markSt];
    // Setting a metadata on marker, here we have an id for each marker
    [marker setMetaDataElement:@"id"  element:[[NTVariant alloc] initWithLongVal:_id]];
    
    // Adding marker to markerLayer, or showing marker on map!
    [markerLayer add:marker];
    
    VectorElementClickedListener *vectorElementClickedListener = [VectorElementClickedListener new];
    vectorElementClickedListener.onVectorElementClickedBlock = ^BOOL(NTElementClickData * _Nonnull clickInfo) {
//         If a double click happens on a marker...
        if ([clickInfo getClickType] == NT_CLICK_TYPE_DOUBLE) {
            long removeId = [[[clickInfo getVectorElement] getMetaDataElement:@"id"] getLong];

            // updating own ui element must run on ui thread not in map ui thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [NeshanHelper toast:self message:[NSString stringWithFormat:@"%@ %ld %@", @"نشانگر شماره", removeId, @"حذف شد!"]];
            });

            //getting marker reference from clickInfo and remove that marker from markerLayer
            [markerLayer remove:[clickInfo getVectorElement]];

            // If a single click happens...
        } else if ([clickInfo getClickType] == NT_CLICK_TYPE_SINGLE) {
            // changing marker to blue
            [self changeMarkerToBlue:(NTMarker *)[clickInfo getVectorElement]];
        }
        return true;
    };

    //handling events on markerLayer
    [markerLayer setVectorElementEventListener: vectorElementClickedListener];
}


-(void) changeMarkerToBlue:(NTMarker *)redMarker
{
    // create new marker style
    NTMarkerStyleCreator *markStCr = [NTMarkerStyleCreator new];
    [markStCr setSize:30];
    // Setting a new bitmap as marker
    [markStCr setBitmap:[NTBitmapUtils createBitmapFromUIImage:[UIImage imageNamed:@"ic_marker_blue"]]];
    // AnimationStyle object - that was created before - is used here
    [markStCr setAnimationStyle:animSt];
    
    NTMarkerStyle *blueMarkSt = [markStCr buildStyle];
    
    // changing marker style using setStyle
    [redMarker setStyle:blueMarkSt];
}

-(void) changeMarkerToRed:(NTMarker *)blueMarker
{
    // create new marker style
    NTMarkerStyleCreator *markStCr = [NTMarkerStyleCreator new];
    [markStCr setSize:30];
    // Setting a new bitmap as marker
    [markStCr setBitmap:[NTBitmapUtils createBitmapFromUIImage:[UIImage imageNamed:@"ic_marker_blue"]]];
    // AnimationStyle object - that was created before - is used here
    [markStCr setAnimationStyle:animSt];
    
    NTMarkerStyle *redMarkSt = [markStCr buildStyle];
    
    // changing marker style using setStyle
    [blueMarker setStyle:redMarkSt];
}

// deselect marker and collapsing bottom sheet
-(void) deselectMarker:(NTMarker *)deselectMarker {
    [self changeMarkerToBlue:deselectMarker];
    selectedMarker = nil;
}
// select marker and expanding bottom sheet
-(void) selectMarker:(NTMarker *)selectMarker {
    [self changeMarkerToRed:selectMarker];
    selectedMarker = selectMarker;
}

@end
