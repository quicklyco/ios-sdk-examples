//
//  RootViewController.m
//  Example-ObjC
//
//  Created by Anton Morozov on 12/6/16.
//  Copyright © 2016 Anton Morozov. All rights reserved.
//

#import "RootViewController.h"
#import "ZowdowSDK.h"

@interface RootViewController () <ZowdowSuggestionsLoaderDelegate>
    
@property (nonatomic, strong) ZowdowSuggestionsLoader *suggestionsLoader;
@property (nonatomic, strong) ZowdowSuggestionsContainer *suggestionsContainer;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ZowdowSDK sharedInstance].appKey = @"some key";
    
    self.searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.searchField becomeFirstResponder];
    [self.searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.suggestionsLoader = [[ZowdowSuggestionsLoader alloc] init];
    self.suggestionsLoader.delegate = self;
    
    self.tableView.rowHeight = 100;
}

#pragma mark -

- (void)textFieldDidChange:(UITextField *)field{
    [self.suggestionsLoader loadSuggestionsForFragment: field.text];
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
        cell = [self.suggestionsContainer cellForTableView:tableView atIndexPath:indexPath configuration:config cardsCarouselType:ZowdowLinearBCarouselType];
    }    
    return cell;
}

@end
