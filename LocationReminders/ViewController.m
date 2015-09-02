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
#import "Keys.h"

//NSString *const kMyCountry = @"USA";

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager * locationManager;
@end

@implementation ViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  self.mapView.delegate = self;
  self.mapView.showsUserLocation = true;
  
  self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureHandler:)];
  [self.mapView addGestureRecognizer:self.longPressGestureRecognizer];

  
  NSLog(@"%d",[CLLocationManager authorizationStatus]);
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  [self.locationManager requestWhenInUseAuthorization];
  
  [self.locationManager startUpdatingLocation]; //The first time you launch the app you do not have authorization yet.
 // self.mapView.region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.6235, -122.3363), 1, 1);
  // Do any additional setup after loading the view, typically from a nib.
}


- (void)longPressGestureHandler:(UILongPressGestureRecognizer*)gesture {
  if ( gesture.state == UIGestureRecognizerStateEnded ) {
    CGPoint touchPoint = [gesture locationInView: self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    annotation.title = @"My Location";
    [self.mapView addAnnotation:annotation];
    NSLog(@"Long Press");
  }
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.6235, -122.3363), 100, 100) animated: true];
  
  MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
  annotation.coordinate = CLLocationCoordinate2DMake(47.6235, -122.3363);
  annotation.title = @"Code Fellows";
  [self.mapView addAnnotation:annotation];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
  NSLog(@"lat: %f, long: %f, speed: %f",location.coordinate.latitude, location.coordinate.longitude, location.speed);
}

#pragma mark - MKMapViewDelegate - Annotations
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
