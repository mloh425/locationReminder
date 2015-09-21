//
//  Queues.m
//  LocationReminders
//
//  Created by Sau Chung Loh on 9/8/15.
//  Copyright (c) 2015 Sau Chung Loh. All rights reserved.
//

#import "Queues.h"

@interface Queues ()

@property (strong, nonatomic) NSMutableArray *queue;

@end

@implementation Queues

- (void) enqueue:(id)object {
  [self.queue addObject:object];
}

- (id) dequeue {
  if (self.queue.count > 0) {
    id object = self.queue[0];
    [self.queue removeObjectsAtIndexes:0];
    return object;
  }
  return nil;
}

- (id) peek {
  id object = self.queue[0];
  return object;
}

-(BOOL) isEmpty {
  if (self.queue.count == 0) {
    return true;
  }
  return false;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
