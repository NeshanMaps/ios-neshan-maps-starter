//
//  NeshanHelper.m
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/6/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import "NeshanHelper.h"

@implementation VectorElementClickedListener

-(BOOL)onVectorElementClicked: (NTElementClickData*)clickInfo
{
    if (self.onVectorElementClickedBlock != nil)
        return self.onVectorElementClickedBlock(clickInfo);
    return NO;
}
@end

@implementation MapEventListener

-(void)onMapClicked: (NTClickData*)clickInfo
{
    if (self.onMapClickedBlock != nil)
        self.onMapClickedBlock(clickInfo);
}
@end
