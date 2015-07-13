//
//  EKEvent+MK.h
//  MKEventKit
//
//  Created by Michal Konturek on 18/06/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import <EventKit/EventKit.h>

@interface EKEvent (MK)

+ (instancetype)mk_createWithTitle:(NSString *)title
                         startDate:(NSDate *)startDate duration:(NSInteger)duration;

+ (instancetype)mk_create;
+ (instancetype)mk_createWithEventStore:(EKEventStore *)store;

+ (instancetype)mk_eventWithID:(NSString *)identifier;

+ (NSArray *)mk_eventsForTodayFromNow;

+ (NSArray *)mk_eventsForToday;
+ (NSArray *)mk_eventsForTomorrow;
+ (NSArray *)mk_eventsForTheDayAfterTomorrow;

+ (NSArray *)mk_eventsForDate:(NSDate *)date;
+ (NSArray *)mk_eventsFrom:(NSDate *)from to:(NSDate *)to;

+ (void)mk_removeEventsForToday;
+ (void)mk_removeEventsForDate:(NSDate *)date;
+ (void)mk_removeEventsFrom:(NSDate *)from to:(NSDate *)to;

- (void)mk_save;
- (void)mk_remove;

- (NSInteger)mk_durationUntilStartInSeconds;
- (NSInteger)mk_durationUntilEndInSeconds;

@end
