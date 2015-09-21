//
//  AddReminderDetailViewController.m
//  LocationReminders
//
//  Created by Sau Chung Loh on 9/2/15.
//  Copyright (c) 2015 Sau Chung Loh. All rights reserved.
//

#import "AddReminderDetailViewController.h"
#import "Constants.h"
#import <MapKit/MapKit.h> 
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "Reminder.h"

@interface AddReminderDetailViewController () <CLLocationManagerDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *locationDescriptionUserInput;
@property (weak, nonatomic) IBOutlet UISlider *regionRadiusSlider;
@property (weak, nonatomic) IBOutlet UILabel *regionRadiusSliderLabel;
@property (weak, nonatomic) IBOutlet UITextField *locationNameUserInput;
@property float regionRadius;
@property int maxRadius;
//@property (weak, nonatomic) NSString *locationName;
//@property (weak, nonatomic) NSString *locationDescription;

@end

@implementation AddReminderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.maxRadius = 300;
  self.regionRadius = self.regionRadiusSlider.value * self.maxRadius;
  self.regionRadiusSliderLabel.text = [NSString stringWithFormat:@"%f meters", self.regionRadiusSlider.value * self.maxRadius];
  self.locationNameUserInput.delegate = self;
  self.locationDescriptionUserInput.delegate = self;
  NSLog(@"%f",self.pointPressed.latitude);
    // Do any additional setup after loading the view.
}

- (IBAction)regionRadiusSliderChanged:(id)sender {
  self.regionRadiusSliderLabel.text = [NSString stringWithFormat:@"%f meters", self.regionRadiusSlider.value * self.maxRadius];
  self.regionRadius = self.regionRadiusSlider.value * self.maxRadius;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  
  return true;
}

//Method taken from StackOverflow to dismiss TextView.
- (BOOL) textView: (UITextView*) textView shouldChangeTextInRange: (NSRange) range replacementText: (NSString*) text {
  if ([text isEqualToString:@"\n"]) {
    [textView resignFirstResponder];
    return NO;
  }
  return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonPressed:(UIButton *)sender {
  
 // [[NSNotificationCenter defaultCenter] postNotificationName:kReminderNotification object:self];
  Reminder *newReminder = [Reminder object];
  newReminder.name = self.locationNameUserInput.text;
  newReminder.description = self.locationDescriptionUserInput.text;// self.locationDescription;
  newReminder.coordinates = [PFGeoPoint geoPointWithLatitude:self.pointPressed.latitude longitude: self.pointPressed.longitude];
  newReminder.regionRadius = self.regionRadius;
  [newReminder saveInBackground];
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject: newReminder forKey:@"ReminderObject"];
  [[NSNotificationCenter defaultCenter] postNotificationName:kReminderNotification object:self userInfo:userInfo];

  [self.navigationController popViewControllerAnimated:true];
  //NSLog(@"Notification Fired!");
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
