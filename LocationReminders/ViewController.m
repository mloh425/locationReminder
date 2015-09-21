//
//  ViewController.m
//  LocationReminders
//
//  Created by Sau Chung Loh on 8/31/15.
//  Copyright (c) 2015 Sau Chung Loh. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h> //????
#import "Constants.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Reminder.h"
#import "AddReminderDetailViewController.h"

//Add Slider

//NSString *const kMyCountry = @"USA";

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) MKPointAnnotation *currentAnnotation;
@end

@implementation ViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reminderNotificationHandler:) name:kReminderNotification object:nil]; //Object is nil b/c you do not know what the object is that is sending it. just get the notification if it is from this name 'ReminderNotification'
  
  self.mapView.delegate = self;
  self.mapView.showsUserLocation = true;
  
  self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureHandler:)];
  [self.mapView addGestureRecognizer:self.longPressGestureRecognizer];
  
  
  NSLog(@"%d",[CLLocationManager authorizationStatus]);
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  [self.locationManager requestAlwaysAuthorization];
  [self.locationManager startUpdatingLocation]; //The first time you launch the app you do not have authorization yet.
  Reminder *reminderObj = [Reminder object];
  reminderObj.user = [PFUser currentUser];
  [reminderObj saveInBackground];
  [self loadAnnotations];
  
  // Do any additional setup after loading the view, typically from a nib.
}

//Loads all of the current logged in user's annotations.
- (void)loadAnnotations{
  PFQuery *reminderQuery = [Reminder query];
  [reminderQuery findObjectsInBackgroundWithBlock:^(NSArray *reminders, NSError *error) {
    //Loop through reminders and create annotations.
    for(int i = 0; i < reminders.count; i++) {
      MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
      Reminder *reminderObject = reminders[i];
      CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(reminderObject.coordinates.latitude, reminderObject.coordinates.longitude);
      annotation.coordinate = coordinate;
      annotation.title = reminderObject.name;
     // [self setUpRegionMonitoring:reminderObject];
      [self.mapView addAnnotation:annotation];
    }
  }];
}

- (void)longPressGestureHandler:(UILongPressGestureRecognizer*)gesture {
  if ( gesture.state == UIGestureRecognizerStateEnded ) {
    CGPoint touchPoint = [gesture locationInView: self.mapView];
    CLLocationCoordinate2D coordinates = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    self.currentAnnotation = [[MKPointAnnotation alloc] init];
    self.coordinate = CLLocationCoordinate2DMake(coordinates.latitude, coordinates.longitude);
    self.currentAnnotation.coordinate = self.coordinate;
    self.currentAnnotation.title = @"My Location";
    [self.mapView addAnnotation:self.currentAnnotation];
    //NSLog(@"Long Press");
  }
}

-(void)reminderNotificationHandler: (NSNotification *) notification {
  NSLog(@"Notification recieved");
  //Add region
  Reminder *reminderObject = notification.userInfo[@"ReminderObject"];
  [self setUpRegionMonitoring:reminderObject];

  //NSArray *regions = [[self.locationManager monitoredRegions] allObjects];
}

-(void)setUpRegionMonitoring: (Reminder *) reminderObject {
  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(reminderObject.coordinates.latitude, reminderObject.coordinates.longitude);//reminderObject.coordinates;
  if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
//    NSString *objectID = [reminderObject objectId];
        NSLog(@"id %@",[reminderObject valueForKey:@"objectId"]);
//    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter: coordinate radius:reminderObject.regionRadius identifier:objectID];
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter: coordinate radius:reminderObject.regionRadius identifier:reminderObject.name];
    [self.locationManager startMonitoringForRegion:region];
    MKCircle *circle =  [MKCircle circleWithCenterCoordinate:coordinate radius:reminderObject.regionRadius];
    [self.mapView addOverlay:circle];
    self.currentAnnotation.title = reminderObject.name;
    NSLog(@"monitored regions: %@", [self.locationManager monitoredRegions]);
  }
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
  MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithCircle:(MKCircle *)overlay];
  circleRenderer.fillColor = [UIColor blueColor];
  circleRenderer.alpha = 0.15;
  return circleRenderer;
}

//Do not call this yourself. Remove self as observer.
-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (![PFUser currentUser]) { // No user logged in
    // Create the log in view controller
    
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Create the sign up view controller
    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
  }
  
  //CLLocationCoordinate2DMake(47.6235, -122.3363)
  //[self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.coordinate, 100, 100) animated: true];
  MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
  annotation.coordinate = CLLocationCoordinate2DMake(47.6235, -122.3363);
  annotation.title = @"Code Fellows";
  [self.mapView addAnnotation:annotation];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if([segue.identifier isEqual: @"ShowDetailView"]) {
    AddReminderDetailViewController *reminderDetailViewController = segue.destinationViewController;
    reminderDetailViewController.pointPressed = self.coordinate;
  }
}

#pragma mark - Parse LoginVC - Code from Parse.
// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
  // Check if both fields are completed
  if (username && password && username.length != 0 && password.length != 0) {
    return YES; // Begin login process
  }
  
  [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                              message:@"Make sure you fill out all of the information!"
                             delegate:nil
                    cancelButtonTitle:@"ok"
                    otherButtonTitles:nil] show];
  return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
  [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
  NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
  [self.navigationController popViewControllerAnimated:YES];
}

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
  BOOL informationComplete = YES;
  
  // loop through all of the submitted data
  for (id key in info) {
    NSString *field = [info objectForKey:key];
    if (!field || field.length == 0) { // check completion
      informationComplete = NO;
      break;
    }
  }
  
  // Display an alert if a field wasn't completed
  if (!informationComplete) {
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
  }
  return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
  [self dismissViewControllerAnimated:YES completion:nil];// Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
  NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
  NSLog(@"User dismissed the signUpViewController");
}

#pragma mark - mapViewDelegate method for segue
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
  [self performSegueWithIdentifier:@"ShowDetailView" sender:self];
  //  [self.navigationController pushViewController:detailCalloutAccessory animated:true];
}

#pragma mark - Button Actions that take you to Locations
- (IBAction)codeFellowsLocationButtonPressed:(UIButton *)sender {
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.6235, -122.3363), 100, 100) animated: true];
}
- (IBAction)lasVegasSpeedwayLocationButtonPressed:(UIButton *)sender {
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(36.2713, -115.0111), 1000, 1000) animated: true];
}

- (IBAction)hongKongLocationButtonPressed:(UIButton *)sender {
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(22.2783, 114.1747), 1000, 1000) animated: true];
}

#pragma mark - CLLocationManagerDelegate
//Tells when auth status has changed
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  switch (status) {
    case kCLAuthorizationStatusAuthorizedWhenInUse:
      [self.locationManager startUpdatingLocation];
      break;
    default:
      break;
  }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  CLLocation *location = locations.lastObject;
  //NSLog(@"lat: %f, long: %f, speed: %f",location.coordinate.latitude, location.coordinate.longitude, location.speed);
}

//Region monitoring
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
  

  NSDate *now = [NSDate date];
  NSDate *fireDate = [NSDate dateWithTimeInterval:15.0 sinceDate:now];
  UILocalNotification *notification = [[UILocalNotification alloc] init];
  
//  PFQuery *reminderQuery = [Reminder query];
//  [reminderQuery whereKey:@"objectId" equalTo:region.identifier];
//  [reminderQuery findObjectsInBackgroundWithBlock:^(NSArray *reminders, NSError *error) {
//    //Loop through reminders and create annotations.
//    Reminder *reminderObj = [reminders firstObject];
//    notification.userInfo = [NSDictionary dictionaryWithObject:reminderObj forKey:@"reminderFromNotification"];
//    NSLog(@"Entered %@",reminderObj.name);
//  }];

  notification.alertTitle = @"You have entered a the region: ";
  notification.alertBody = region.identifier;
  notification.fireDate = fireDate;
  NSLog(@"Entered %@", region.identifier);
  //Where key contains PFQuery

  [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

#pragma mark - MKMapKitDelegate - Annotations
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  if ([annotation isKindOfClass:[MKUserLocation class]]) {
    return nil;
  }
  
  MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
  pinView.annotation = annotation;
  
  if(!pinView) {
    pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
  }
  
  pinView.animatesDrop = true;
  pinView.canShowCallout = true;
  pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  pinView.pinColor = MKPinAnnotationColorGreen;
  return pinView;
}

@end
