//
//  TipViewController.m
//  tipCalculator
//
//  Created by Lin Zhang on 6/2/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;



- (IBAction)OnTap:(id)sender;
- (void) updateValues;
- (IBAction)OnValueChanged:(id)sender;

@end

@implementation TipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Tip Calculator";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateValues];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
}

- (void)onSettingsButton {
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnTap:(id)sender {
    
    [self.view endEditing:YES];
    [self updateValues];
    
}

- (void) updateValues {
    
    //NSArray *tipValues = @[@(0.1), @(0.15), @(0.2)];
    
    NSMutableArray *tipValues = [[NSMutableArray alloc] init];
    [tipValues addObject:@"0.1"];
    [tipValues addObject:@"0.15"];
    [tipValues addObject:@"0.2"];

    
    //load settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *firstLabel = [defaults objectForKey:@"FirstLabel"];
    float firstPercent = [defaults floatForKey:@"FirstPercent"];
    
    if ([firstLabel length] > 0) {
        [self.tipControl setTitle:firstLabel forSegmentAtIndex:0];
    }
    if (firstPercent > 0.0) {
        
        tipValues[0] = [NSString stringWithFormat:@"%f", firstPercent];
    }
    
    
    NSString *secondLabel = [defaults objectForKey:@"SecondLabel"];
    float secondPercent = [defaults floatForKey:@"SecondPercent"];
    
    if ([secondLabel length] > 0) {
        [self.tipControl setTitle:secondLabel forSegmentAtIndex:1];
    }
    if (secondPercent > 0.0) {
        
        tipValues[1] = [NSString stringWithFormat:@"%0.2f", secondPercent];
    }
    
    NSString *thirdLabel = [defaults objectForKey:@"ThirdLabel"];
    float thirdPercent = [defaults floatForKey:@"ThirdPercent"];
    
    if ([thirdLabel length] > 0) {
        [self.tipControl setTitle:thirdLabel forSegmentAtIndex:2];
    }
    if (thirdPercent > 0.0) {
        
        tipValues[2] = [NSString stringWithFormat:@"%0.2f", thirdPercent];
    }
    

    
    float billAmount = [self.billTextField.text floatValue];
    
    float tipAmount = billAmount * [tipValues[self.tipControl.selectedSegmentIndex] floatValue];
    
    float totalAmount = tipAmount + billAmount;
    
    self.tipLabel.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];
    
    
    
}

- (IBAction)OnValueChanged:(id)sender {
    [self updateValues];
}
@end
