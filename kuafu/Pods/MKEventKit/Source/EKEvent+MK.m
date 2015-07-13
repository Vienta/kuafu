//
//  EKEvent+MK.m
//  MKEventKit
//
//  Created by Michal Konturek on 18/06/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "EKEvent+MK.h"

#import "EKEventStore+MK.h"

#import <MKFoundationKit/NSDate+MK.h>

@implementation EKEvent (MK)

+ (instancetype)mk_createWithTitle:(NSString *)title
                         startDate:(NSDate *)startDate duration:(NSInteger)duration {
    EKEvent *event = [self mk_create];
    event.alarms = @[[EKAlarm alarmWithAbsoluteDate:startDate]];
    event.calendar = [[EKEventStore mk_registeredEventStore] defaultCalendarForNewEvents];
    event.startDate = startDate;
    event.endDate = [startDate mk_dateByAddingMinutes:duration];
    event.title = title;
    return event;
}

+ (instancetype)mk_create {
    return [self mk_createWithEventStore:[EKEventStore mk_registeredEventStore]];
}

+ (instancetype)mk_createWithEventStore:(EKEventStore *)store {
    return [self eventWithEventStore:store];
}

+ (instancetype)mk_eventWithID:(NSString *)identifier {
    return [[EKEventStore mk_registeredEventStore] eventWithIdentifier:identifier];
}

+ (NSArray *)mk_eventsForTodayFromNow {
    id date = [NSDate date];
    id startDate = date;
    id endDate = [[[date mk_dateWithoutTime] mk_dateByAddingHours:23] mk_dateByAddingMinutes:59];
    return [self mk_eventsFrom:startDate to:endDate];
}

+ (NSArray *)mk_eventsForToday {
    return [self mk_eventsForDate:[NSDate date]];
}

+ (NSArray *)mk_eventsForTomorrow {
    return [self mk_eventsForDate:[NSDate mk_dateTomorrow]];
}

+ (NSArray *)mk_eventsForTheDayAfterTomorrow {
    return [self mk_eventsForDate:[[NSDate mk_dateTomorrow] mk_dateByAddingDays:1]];
}

+ (NSArray *)mk_eventsForDate:(NSDate *)date {
    id startDate = [date mk_dateWithoutTime];
    id endDate = [[[date mk_dateWithoutTime] mk_dateByAddingHours:23] mk_dateByAddingMinutes:59];
    return [self mk_eventsFrom:startDate to:endDate];
}

+ (NSArray *)mk_eventsFrom:(NSDate *)from to:(NSDate *)to {
    id store = [EKEventStore mk_registeredEventStore];
    id predicate = [store predicateForEventsWithStartDate:from endDate:to calendars:nil];
    id events = [[EKEventStore mk_registeredEventStore] eventsMatchingPredicate:predicate];
    events = [events sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
    return events;
}

+ (void)mk_removeEventsForToday {
    [self mk_removeEventsForDate:[NSDate date]];
}

+ (void)mk_removeEventsForDate:(NSDate *)date {
    id startDate = [date mk_dateWithoutTime];
    id endDate = [[[date mk_dateWithoutTime] mk_dateByAddingHours:23] mk_dateByAddingMinutes:59];
    [self mk_removeEventsFrom:startDate to:endDate];
}

+ (void)mk_removeEventsFrom:(NSDate *)from to:(NSDate *)to {
    id events = [self mk_eventsFrom:from to:to];
    for (id event in events) {
        [event mk_remove];
    }
}

- (void)mk_save {
    [[EKEventStore mk_registeredEventStore] saveEvent:self span:EKSpanThisEvent error:nil];
}

- (void)mk_remove {
    [[EKEventStore mk_registeredEventStore] removeEvent:self span:EKSpanThisEvent error:nil];
}

- (NSInteger)mk_durationUntilStartInSeconds {
    NSDateComponents *difference = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit
                                                                   fromDate:[NSDate date]
                                                                     toDate:self.startDate
                                                                    options:0];
    return [difference second];
}

- (NSInteger)mk_durationUntilEndInSeconds {
    NSDateComponents *difference = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit
                                                                   fromDate:[NSDate date]
                                                                     toDate:self.endDate
                                                                    options:0];
    return [difference second];
}

@end
