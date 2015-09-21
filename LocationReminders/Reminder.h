//
//  Reminder.h
//  LocationReminders
//
//  Created by Sau Chung Loh on 9/2/15.
//  Copyright (c) 2015 Sau Chung Loh. All rights reserved.
//

#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>

@interface Reminder : PFObject <PFSubclassing>
  @property PFUser *user;
  @property (strong, nonatomic)NSString *name;
  @property (strong, nonatomic)NSString *description;
  @property float regionRadius;
  @property PFGeoPoint *coordinates;
  @property (strong, nonatomic)NSString *reminderID;
@end
