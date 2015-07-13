//
//  EKEventStore+MK.h
//  MKEventKit
//
//  Created by Michal Konturek on 18/06/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <EventKit/EventKit.h>

@interface EKEventStore (MK)

+ (void)mk_registerEventStore:(EKEventStore *)store;
+ (void)mk_deregisterEventStore;

+ (instancetype)mk_registeredEventStore;

+ (BOOL)mk_isAccessAuthorized;
+ (BOOL)mk_hasRegisteredEventStore;

@end
