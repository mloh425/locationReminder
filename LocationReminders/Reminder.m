//
//  Reminder.m
//  LocationReminders
//
//  Created by Sau Chung Loh on 9/2/15.
//  Copyright (c) 2015 Sau Chung Loh. All rights reserved.
//

#import "Reminder.h"

@interface Reminder()

@end

@implementation Reminder
  @dynamic user;
  @dynamic name;
  @dynamic description;
  @dynamic coordinates;
  @dynamic regionRadius;
  @dynamic reminderID;

  + (NSString *__nonnull)parseClassName {
    return @"Reminder";
  }
@end
