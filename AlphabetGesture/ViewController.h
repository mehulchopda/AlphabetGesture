//
//  ViewController.h
//  AlphabetDemo
//
//  Created by Mehul Chopda on 16/06/15.
//  Copyright (c) 2015 Mehul Chopda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DollarPGestureRecognizer.h"
#import "GestureView.h"
#import "AVCamViewController.h"









@interface ViewController : UIViewController<UINavigationControllerDelegate>
{
    DollarPGestureRecognizer *dollarPGestureRecognizer;
    __weak IBOutlet GestureView *gestureView;
    
    
    BOOL recognized;
}


@end;

