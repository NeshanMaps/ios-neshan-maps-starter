//
//  NeshanHelper.m
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/6/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import "NeshanHelper.h"

@implementation NeshanHelper

+(void) toast:(UIViewController *)parent message:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [parent presentViewController:alert animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

@end

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

-(void) onMapMoved
{
    if (self.onMapMovedBlock != nil)
        self.onMapMovedBlock();
}

@end

