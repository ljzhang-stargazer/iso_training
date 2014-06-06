//
//  SettingsViewController.m
//  tipCalculator
//
//  Created by Lin Zhang on 6/3/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *FirstLabel;

@property (weak, nonatomic) IBOutlet UITextField *FirstPercent;

@property (weak, nonatomic) IBOutlet UITextField *SecondLabel;

@property (weak, nonatomic) IBOutlet UITextField *SecondPercent;

@property (weak, nonatomic) IBOutlet UITextField *ThirdLabel;

@property (weak, nonatomic) IBOutlet UITextField *ThirdPercent;

- (IBAction)SaveSettings:(id)sender;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    //load setting
    //load settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *firstLabel = [defaults objectForKey:@"FirstLabel"];
    float firstPercent = [defaults floatForKey:@"FirstPercent"];
    
    if ([firstLabel length] > 0) {
        self.FirstLabel.text = firstLabel;
    }
    if (firstPercent > 0.0) {
        
        self.FirstPercent.text = [NSString stringWithFormat:@"%0.2f", firstPercent];
    }

    NSString *secondLabel = [defaults objectForKey:@"SecondLabel"];
    float secondPercent = [defaults floatForKey:@"SecondPercent"];
    
    if ([secondLabel length] > 0) {
        self.SecondLabel.text = secondLabel;
    }
    if (secondPercent > 0.0) {
        
        self.SecondPercent.text = [NSString stringWithFormat:@"%0.2f", secondPercent];
    }
    
    NSString *thirdLabel = [defaults objectForKey:@"ThirdLabel"];
    float thirdPercent = [defaults floatForKey:@"ThirdPercent"];
    
    if ([thirdLabel length] > 0) {
        self.ThirdLabel.text = thirdLabel;
    }
    if (thirdPercent > 0.0) {
        
        self.ThirdPercent.text = [NSString stringWithFormat:@"%0.2f", thirdPercent];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SaveSettings:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.FirstLabel.text forKey:@"FirstLabel"];
    [defaults setFloat:[self.FirstPercent.text floatValue] forKey:@"FirstPercent"];
    [defaults setObject:self.SecondLabel.text forKey:@"SecondLabel"];
    [defaults setFloat:[self.SecondPercent.text floatValue] forKey:@"SecondPercent"];
    [defaults setObject:self.ThirdLabel.text forKey:@"ThirdLabel"];
    [defaults setFloat:[self.ThirdPercent.text floatValue] forKey:@"ThirdPercent"];
    
    
    [defaults synchronize];
}
@end
