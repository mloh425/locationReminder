//
//  Challenges.m
//  LocationReminders
//
//  Created by Sau Chung Loh on 9/8/15.
//  Copyright (c) 2015 Sau Chung Loh. All rights reserved.
//

#import "Challenges.h"

@interface Challenges ()

@end

@implementation Challenges

- (void)viewDidLoad {
    [super viewDidLoad];
  BOOL isAnagram = [self anagrams:@"dormitory" andString:@"dirtyroom"];
  NSLog(@"%s",isAnagram ? "true" : "false");
  
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sumOfStringDigits: (NSString *)string {
  
//  NSMutableArray *arrayOfChars = [NSMutableArray array];
//  for (int i = 0; i < [string length]; i++) {
//    [array addObject:[NSString stringWithFormat:@"%C", [string characterAtIndex:i]]];
//  }
//  for (int i = 0; i < string.length; i++) {
//    char c = [string characterAtIndex:i];
//    if (c == nu)
//  }

}

-(BOOL) anagrams:(NSString *)a andString:(NSString *)b {
  if (a.length != b.length) {
    return NO;
  }
  
  NSCountedSet *aCharSet = [[NSCountedSet alloc] init];
  NSCountedSet *bCharSet = [[NSCountedSet alloc] init];
  
  for (int i = 0; i < a.length; i++) {
    [aCharSet addObject:@([a characterAtIndex:i])];
    [bCharSet addObject:@([b characterAtIndex:i])];
  }
  
  return [aCharSet isEqual:bCharSet];
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
