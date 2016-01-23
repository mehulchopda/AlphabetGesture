//
//  ViewController.m
//  AlphabetDemo
//
//  Created by Mehul Chopda on 16/06/15.
//  Copyright (c) 2015 Mehul Chopda. All rights reserved.
//

#import "ViewController.h"
#import "AVCamViewController.h"
#import "DollarDefaultGestures.h"

@interface ViewController ()

@end
NSString *sendData;
NSString *sendMode;
NSString *gridValue;
NSString *flashValue;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUpdatedData:)
                                                 name:@"DataUpdated"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingNotification:) name:@"DataSended" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingNotificationflash:) name:@"DataFlash" object:nil];
    
    dollarPGestureRecognizer = [[DollarPGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(gestureRecognized:)];
    [dollarPGestureRecognizer setPointClouds:[DollarDefaultGestures defaultPointClouds]];
    [dollarPGestureRecognizer setDelaysTouchesEnded:NO];
    
    [gestureView addGestureRecognizer:dollarPGestureRecognizer];
    self.navigationController.navigationBar.hidden=YES;
}
- (void) incomingNotification:(NSNotification *)notification{
    gridValue = [notification object];
    NSLog(@"This was returned from ViewControllerB %@",gridValue);
}
- (void) incomingNotificationflash:(NSNotification *)notification{
    flashValue = [notification object];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidLoad];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)handleUpdatedData:(NSNotification *)notification {
    
    
    [dollarPGestureRecognizer recognize];
    [gestureView clearAll];
    recognized = !recognized;
    // [gestureView setUserInteractionEnabled:!recognized];
    
    
    
    
}

- (void)addItemViewController:(NSString *)item
{
    NSLog(@"This was returned from ViewControllerB %@",item);
    
}
- (void)gestureRecognized:(DollarPGestureRecognizer *)sender {
    DollarResult *result = [sender result];
    NSLog(@"Gesture name=%@",[result name]);
    NSLog(@"Gesture name=%@",[dollarPGestureRecognizer points ]);
    //
    //    if ([[result name] isEqualToString:@"Settings"]) {
    //        sendData=@"Settings";
    //
    //
    //    }
    if ([[result name] isEqualToString:@"T"]) {
        sendData=@"Timer";
        
        
    }
//    if ([[result name] isEqualToString:@"P"] || [[result name] isEqualToString:@"F"]) {
//        sendData=@"CallGrids";
//    }
    
    if ([[result name] isEqualToString:@"G"]) {
        if([gridValue isEqualToString:@"Grid"])
        {
            sendData=@"RemoveGrid";
            gridValue=@"";
            
        }
        else{
            sendData=@"Grid";
            
            
        }
    }
    
    if ([[result name] isEqualToString:@"L"]) {
        if([flashValue isEqualToString:@"Flash"])
        {
            sendData=@"RemoveFlash";
            flashValue=@"";
            
        }
        else{
            sendData=@"Flash";
            sendMode=@"Camera";
        }
    }
    
    if ([[result name] isEqualToString:@"C"] || [[result name] isEqualToString:@"Bracket"]) {
        sendMode=@"Camera";
        sendData=@"";
    }
    
    if ([[result name] isEqualToString:@"V"] || [[result name] isEqualToString:@"Triangle"]) {
        sendMode=@"Video";
        sendData=@"";
    }
    if ([[result name] isEqualToString:@"F"]) {
        sendData=@"FrontCamera";
        
    }
    if ([[result name] isEqualToString:@"B"]) {
        sendData=@"BackCamera";
        
    }
    if ([[result name] isEqualToString:@"P"]) {
        sendData=@"Settings";
        
    }
    if ([[result name] isEqualToString:@"S"]) {
        sendData=@"Square";
        sendMode=@"Camera";
        
    }
    NSLog(@"Senddata:%@",sendData);
    NSLog(@"Sendmode:%@",sendMode);
    //    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self performSegueWithIdentifier:@"transform" sender:sender];
}





- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"transform"]) {
        AVCamViewController* userViewController = [segue destinationViewController];
        if (sendData !=NULL) {
            userViewController.dataCam = sendData;
            
        }
        if (sendMode!=NULL) {
            userViewController.modeCam = sendMode;
        }
    }
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
}



- (IBAction)imageGallery:(id)sender {
}
@end
