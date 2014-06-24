//
//  FilterViewController.m
//  Yelp
//
//  Created by Lin Zhang on 6/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "ToggleViewCell.h"
#import "PriceSegmentationViewCell.h"
#import "FilterOption.h"

typedef enum {
    
    PriceRange_Section = 0,
    Popular_Section = 1,
    Sort_Section = 2,
    Category_Section = 3
} filtersTableSection;

static NSString * filtersCellIdentifier = @"FiltersCell";

@interface FilterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL isDistanceSectionExpanded;
@property (nonatomic) BOOL isSortedBySectionExpanded;
//@property (strong, nonatomic) FilterOption *filterOption;


@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        self.filterOption = [[FilterOption alloc] init];
        self.isDistanceSectionExpanded = NO;
        self.isSortedBySectionExpanded = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    

    
    [self.tableView registerNib: [UINib nibWithNibName:@"PriceSegmentationViewCell" bundle:nil] forCellReuseIdentifier:@"PriceSegmentationViewCell"];
    [self.tableView registerNib: [UINib nibWithNibName:@"ToggleViewCell" bundle:nil] forCellReuseIdentifier:@"ToggleViewCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:filtersCellIdentifier];
    
    
    UINavigationBar *headerView = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    UINavigationItem *buttonCarrier = [[UINavigationItem alloc]initWithTitle:@"Filters"];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    [buttonCarrier setLeftBarButtonItem:cancelButton];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleDone target:self action:@selector(search)];
    [buttonCarrier setRightBarButtonItem:searchButton];
    
    NSArray *barItemArray = [[NSArray alloc]initWithObjects:buttonCarrier,nil];
    [headerView setItems:barItemArray];
    [self.tableView setTableHeaderView:headerView];
    
    [headerView setBarTintColor:[UIColor redColor]];
    [headerView setTintColor:[UIColor whiteColor]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case PriceRange_Section:
            return @"Price";
        case Popular_Section:
            return @"Most Popular";
        case Sort_Section:
            return @"Sort by";
        case Category_Section:
            return @"Categories";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    // I don't like all UpperCase string
    UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
    tableViewHeaderFooterView.textLabel.text = [tableViewHeaderFooterView.textLabel.text capitalizedString];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rowNumber = 0;
    switch (section) {
        case PriceRange_Section:
            rowNumber = 1;
            break;
        case Popular_Section:
            rowNumber =  2;
            break;
        case Sort_Section:
            if (self.isSortedBySectionExpanded)
            {
                rowNumber =  4;
            } else {
                rowNumber = 1;
            }
            break;
        case Category_Section:
            rowNumber = 5;
            break;
    }
    return rowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *label = nil;
    switch (section) {
        case PriceRange_Section:
        {
            PriceSegmentationViewCell *priceRangeCell = [self.tableView dequeueReusableCellWithIdentifier:@"PriceSegmentationViewCell"];
            //priceRangeCell = _filterOption.radiusFilter;
            return priceRangeCell;
        }
        case Popular_Section:
        {
            
            ToggleViewCell *toggleViewCell = [self.tableView dequeueReusableCellWithIdentifier:@"ToggleViewCell"];
            switch (row) {
                case 0:
                    label  = @"Offering a deal";
                    break;
                case 1:
                    label = @"Hot and New";
                    break;
            }
            toggleViewCell.textLabel.text = label;

            return toggleViewCell;
        }
        case Sort_Section:
        {
            UITableViewCell * cell = [self standardCell];
            UIImageView * accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
            if (!self.isSortedBySectionExpanded) {

            } else {
                switch (row) {
                    case 0:
                        label = @"1";
                        break;
                    case 1:
                        label = @"2";
                        break;
                    case 2:
                        label = @"3";
                        break;
                    case 3:
                        label = @"4";
                        break;
  
                    default:
                        break;
                }
                cell.textLabel.text = label;
                
            }
            cell.accessoryView = accessoryView;
            return cell;
        }
        case Category_Section:
        {
            UITableViewCell * cell = [self standardCell];
            return cell;
        }
    }
    return nil;
}

// helper
- (UITableViewCell *)standardCell {
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:filtersCellIdentifier];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
        case Sort_Section:
            if (!self.isSortedBySectionExpanded) {
                [self expandSortBySection];
            } else {
                [self collapseSortBySectionWithRow:row];
            }
            break;
        case Category_Section:
            /*
            if (!_categoriesExpanded) {
                _categoriesExpanded = YES;
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:Category_Section] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [self toggleCategorySelectionAtRow:row];
            }
             */
            break;
        case Popular_Section:
        case PriceRange_Section:
            break;
    }
}

// sort by section helpers

- (void)expandSortBySection {
    self.isSortedBySectionExpanded = YES;
    [self reloadSortBySection];
}

- (void)collapseSortBySectionWithRow:(NSInteger)row {
    //int oldSelection = _filterOption.sortFilter;
    //_filterOption.sortFilter = (sortMode)row;
    // change radio button selection
    NSArray * reloadPaths = @[[NSIndexPath indexPathForRow:row inSection:0]];
    [_tableView reloadRowsAtIndexPaths:reloadPaths withRowAnimation:UITableViewRowAnimationNone];
    //reloadPaths = @[[NSIndexPath indexPathForRow:oldSelection inSection:0]];
    [_tableView reloadRowsAtIndexPaths:reloadPaths withRowAnimation:UITableViewRowAnimationNone];
    
    self.isSortedBySectionExpanded = NO;
    // introduce delay
    [self performSelector:@selector(reloadSortBySection) withObject:self afterDelay:0.5 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}

// helper
- (void)reloadSortBySection {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:Sort_Section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)toggleCategorySelectionAtRow:(NSInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:Category_Section];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    NSString * category = [NSString stringWithFormat:@"%ld", (long)row];
    if (YES) {//[_filterOption.categories containsObject:category]) {
      //  [_filterOption.categories removeObject:category];
        //cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        //[_filterOption.categories addObject:category];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

#pragma mark - RadiusCellDelegate

- (void)sliderValueChanged:(int)value {
    //_filterOption.radiusFilter = value;
}

#pragma mark - button handlers

- (void)cancelButtonHandler:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)searchButtonHandler:(id)sender {
    [self.delegate searchWithFilterOption:_filterOption];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)dealSwitchValueChanged:(id)sender {
   // _filterOption.dealsFilter = ((UISwitch *)sender).on;
}

@end

