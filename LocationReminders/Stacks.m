//
//  Stacks.m
//  
//
//  Created by Sau Chung Loh on 9/1/15.
//
//

#import "Stacks.h"

@interface Stacks()

@property (strong, nonatomic) NSMutableArray *stack;

@end

@implementation Stacks

- (void) push:(id)object {
  [self.stack addObject:object];
}

- (id) pop {
  if (self.stack.count > 0) {
    id object = [self.stack lastObject];
    [self.stack removeLastObject];
    return object;
  }
  return nil;
}

- (id) peek {
  return [self.stack lastObject];
}

-(BOOL) isEmpty {
  if (self.stack.count == 0) {
    return true;
  }
  return false;
}

@end
