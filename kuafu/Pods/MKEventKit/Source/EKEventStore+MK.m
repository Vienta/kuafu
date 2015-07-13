//
//  EKEventStore+MK.m
//  MKEventKit
//
//  Created by Michal Konturek on 18/06/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "EKEventStore+MK.h"

static EKEventStore *_registeredEventStore;

@implementation EKEventStore (MK)

+ (void)mk_registerEventStore:(EKEventStore *)store {
    _registeredEventStore = store;
}

+ (void)mk_deregisterEventStore {
    [self mk_registerEventStore:nil];
}

+ (instancetype)mk_registeredEventStore {
    return _registeredEventStore;
}

+ (BOOL)mk_isAccessAuthorized {
    return ([self authorizationStatusForEntityType:EKEntityTypeEvent] == EKAuthorizationStatusAuthorized);
}

+ (BOOL)mk_hasRegisteredEventStore {
    return ([self mk_registeredEventStore] != nil);
}

@end
