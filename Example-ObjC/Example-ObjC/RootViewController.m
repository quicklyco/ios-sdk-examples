//
//  RootViewController.m
//  Example-ObjC
//
//  Created by Anton Morozov on 12/6/16.
//  Copyright © 2016 Anton Morozov. All rights reserved.
//

#import "RootViewController.h"
#import "ZowdowSDK.h"

@interface RootViewController () <ZowdowSuggestionsLoaderDelegate, UISearchBarDelegate>
    
@property (nonatomic, strong) ZowdowSuggestionsLoader *suggestionsLoader;
@property (nonatomic, strong) ZowdowSuggestionsContainer *suggestionsContainer;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self createSearchBar];
    
    self.suggestionsLoader = [[ZowdowSuggestionsLoader alloc] init];
    self.suggestionsLoader.delegate = self;
    
    self.tableView.rowHeight = 100;
}

#pragma mark -

- (void)createSearchBar {
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.showsCancelButton = false;
    self.searchBar.delegate = self;    
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.navigationItem.titleView = self.searchBar;
    [self.searchBar becomeFirstResponder];
}

#pragma mark - ZowdowSuggestionsLoaderDelegate

- (void)zowdowSuggestionsLoader:(ZowdowSuggestionsLoader *)loader didReceiveSuggestions:(ZowdowSuggestionsContainer *)container
{
    self.suggestionsContainer = container;
    [self.tableView reloadData];
}

- (void)zowdowSuggestionsLoader:(ZowdowSuggestionsLoader *)loader didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.suggestionsLoader loadSuggestionsForFragment: searchText];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.suggestionsContainer) {
        return self.suggestionsContainer.suggestionsCount;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CarouselCell"];
    if (self.suggestionsContainer) {
        ZowdowSuggestionCellConfiguration *config = [ZowdowSuggestionCellConfiguration defaultConfiguration];
        cell = [self.suggestionsContainer cellForTableView:tableView atIndexPath:indexPath configuration:config cardsCarouselType:ZowdowLinearFull];
    }    
    return cell;
}

@end
