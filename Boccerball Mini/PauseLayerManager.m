//
//  PauseLayerManager.m
//  Boccerball Mini
//
//  Created by Kyle Koser on 3/5/13.
//
//

#import "PauseLayerManager.h"

@implementation PauseLayerManager

+ (id)sharedInstance {
    //GCD happy way of initializing a singleton once
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

@end
