//
//  NeshanHelper.h
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/6/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NeshanMobileSDK/NeshanMobileSDK.h>

NS_ASSUME_NONNULL_BEGIN

#define API_KEY @"service.fYFAjXz8Ua8BNbkReNJr66AB9qFTYYfdWUNfSnoM"

@interface NeshanHelper: NSObject
+(void) toast:(UIViewController *)parent message:(NSString *)message;
@end

@interface VectorElementClickedListener: NTVectorElementEventListener

typedef BOOL (^OnVectorElementClickedBlock)(NTElementClickData* clickInfo);
@property (readwrite, copy) OnVectorElementClickedBlock onVectorElementClickedBlock;

@end

@interface MapEventListener: NTMapEventListener

typedef void (^OnMapClickedBlock)(NTClickData* clickInfo);
@property (readwrite, copy) OnMapClickedBlock onMapClickedBlock;

typedef void (^OnMapMovedBlock)(void);
@property (readwrite, copy) OnMapMovedBlock onMapMovedBlock;


typedef void (^OnMapStableBlock)(void);
@property (readwrite, copy) OnMapStableBlock onMapStableBlock;


typedef void (^OnMapIdleBlock)(void);
@property (readwrite, copy) OnMapIdleBlock onMapIdleBlock;

@end

NS_ASSUME_NONNULL_END
