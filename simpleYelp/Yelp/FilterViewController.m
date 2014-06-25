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

@property (nonatomic) BOOL isDealAvailable;
@property (strong,nonatomic) NSArray *categoryValues;
@property (strong,nonatomic) NSArray *sortByItems;
@property (nonatomic) int sortByItemIndex;

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
        
        self.sortByItems = @[@"Best Match", @"Distance", @"Rating", @"Most Reviewed"];
        self.categoryValues = @[
                                @{@"name": @"American (Traditional)",
                                  @"value": @"tradamerican"},
                                @{@"name": @"Asian Fusion",
                                  @"value": @"asianfusion"},
                                @{@"name": @"Breakfast & Brunch",
                                  @"value": @"breakfast_brunch"},
                                @{@"name": @"Buffets",
                                  @"value": @"buffets"},
                                @{@"name": @"Cafes",
                                  @"value": @"cafes"}
                                ];
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
            rowNumber = 1;
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

- (void) toggleSwitch {
    //NSLog(@"OK");
    if (self.isDealAvailable == YES) self.isDealAvailable = NO;
    else self.isDealAvailable = YES;
    self.filterOption.isDealAvailable = self.isDealAvailable;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *label = nil;
    switch (section) {
        case PriceRange_Section:
        {
            PriceSegmentationViewCell *priceRangeCell = [self.tableView dequeueReusableCellWithIdentifier:@"PriceSegmentationViewCell"];

            return priceRangeCell;
        }
        case Popular_Section:
        {
            
            ToggleViewCell *toggleViewCell = [self.tableView dequeueReusableCellWithIdentifier:@"ToggleViewCell"];
            //toggleViewCell.delegate = self;
            [toggleViewCell.switchVw addTarget:self action:@selector(toggleSwitch) forControlEvents:UIControlEventValueChanged];
            switch (row) {
                case 0:
                    label  = @"Offering a deal";
                    break;
            }
            toggleViewCell.textLabel.text = label;

            return toggleViewCell;
        }
        case Sort_Section:
        {
            UITableViewCell * cell = [self standardCell];
            UIImageView * accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            if (!self.isSortedBySectionExpanded) {

            } else {
                switch (row) {
                    case 0:
                        label = @"Best Match";
                        break;
                    case 1:
                        label = @"Distance";
                        break;
                    case 2:
                        label = @"Rating";
                        break;
                    case 3:
                        label = @"Most Reviewed";
                        break;
                    default:
                        break;
                }
                
                if (indexPath.row == self.sortByItemIndex) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }

                
                cell.textLabel.text = label;
                
            }
            cell.accessoryView = accessoryView;
            return cell;
        }
        case Category_Section:
        {
            UITableViewCell * cell = [self standardCell];
            cell.textLabel.text = self.categoryValues[indexPath.row][@"name"];

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
    
    //NSLog(@"section: %d, row: %d", indexPath.section, indexPath.row);
    
    switch (section) {
        case Sort_Section:
            if (!self.isSortedBySectionExpanded) {
                [self expandSortBySection];
            } else {
                [self collapseSortBySectionWithRow:row];
            }
            self.sortByItemIndex = row;
            //NSLog(@"sortByItemIndex: %d", row);
            break;
        case Category_Section:
                [self toggleCategorySelectionAtRow:row];
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
    self.filterOption.sortedBy = self.sortByItems[row];
    NSLog(self.filterOption.sortedBy);
    // change radio button selection
    NSArray * reloadPaths = @[[NSIndexPath indexPathForRow:row inSection:Sort_Section]];
    [_tableView reloadRowsAtIndexPaths:reloadPaths withRowAnimation:UITableViewRowAnimationNone];
    //reloadPaths = @[[NSIndexPath indexPathForRow:oldSelection inSection:Sort_Section]];
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
    
    NSString * category = self.categoryValues[indexPath.row][@"value"];
    
    if ([self.filterOption.categories containsObject:category]) {
        [self.filterOption.categories removeObject:category];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        [self.filterOption.categories addObject:category];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}


- (void)search {
    
    //checking
    //NSLog(self.filterOption.sortedBy);
    
    [self.delegate searchWithFilterOption:self.filterOption];
    [self dismissViewControllerAnimated:YES completion:^{}];
    return;
}

- (void)sender:(ToggleViewCell *)sender didToggle:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSLog(@"TEST!!!");
    if (indexPath.section == 1) {
        NSLog(@"%ld, %@", (long)indexPath.row, @(value));
        //self.mostPopularSwitchStates[indexPath.row] = @(value);
    }
    else if (indexPath.section == 4) {
        //self.generalFeaturesSwitchStates[indexPath.row] = @(value);
    }
    else {
        //self.categoriesSwitchStates[indexPath.row] = @(value);
    }
}

@end

