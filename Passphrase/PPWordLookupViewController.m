//
//  PPWordLookupViewController.m
//  Passphrase
//
//  Created by Brian Dewey on 4/14/14.
//  Copyright (c) 2014 Brian's Brain. All rights reserved.
//

#import "PPWordLookupViewController.h"
#import "NSString+Diceware.h"
#import "diceware-definitions.h"
#import "diceware_wordlist.h"

static NSString * const kInputCellReuseIdentifier = @"InputCell";
static NSString * const kWordCellReuseIdentifier = @"WordCell";

typedef NS_ENUM(NSInteger, PPWordLookupSections) {
  PPWordLookupSectionInput,
  PPWordLookupSectionWords,
  PPWordLookupSectionNumSections
};

static const CGFloat kPadding = 8.0;

@interface PPWordLookupViewController () <UITextFieldDelegate>

@property (nonatomic, strong, readwrite) UITextField *activeInputField;

@end

@implementation PPWordLookupViewController
{
  NSMutableArray *_generatedDicewareNumbers;
  NSRegularExpression *_inputValidator;
}

- (instancetype)initWithDicewareWordList:(char **)dicewareWordList
{
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self != nil) {
    _dicewareWordList = dicewareWordList;
    _generatedDicewareNumbers = [[NSMutableArray alloc] init];
    _inputValidator = [[NSRegularExpression alloc] initWithPattern:@"^[1-6]*$" options:0 error:NULL];
  }
  return self;
}

- (void)dealloc
{
  self.activeInputField = nil;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (void)setActiveInputField:(UITextField *)activeInputField
{
  if (_activeInputField != activeInputField) {
    _activeInputField.delegate = nil;
    [_activeInputField removeTarget:self action:NULL forControlEvents:UIControlEventEditingChanged];
    _activeInputField = activeInputField;
    _activeInputField.delegate = self;
    [_activeInputField addTarget:self action:@selector(_inputFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
  }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return PPWordLookupSectionNumSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  switch ((PPWordLookupSections)section) {
    case PPWordLookupSectionInput:
      return 1;

    case PPWordLookupSectionWords:
      return _generatedDicewareNumbers.count;
      
    case PPWordLookupSectionNumSections:
      NSAssert(NO, @"Invalid section");
      return 0;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  PPWordLookupSections section = indexPath.section;
  switch (section) {
    case PPWordLookupSectionInput:
      return [self _cellForInputFromTable:tableView];
      
    case PPWordLookupSectionWords: {
      PPDicewareNumber dicewareNumber = [_generatedDicewareNumbers[indexPath.row] unsignedIntegerValue];
      return [self _cellFromTable:tableView forDicewareWordNumber:dicewareNumber];
    }
      
    case PPWordLookupSectionNumSections:
      NSAssert(NO, @"Invalid section");
      return nil;
  }
}

- (UITableViewCell *)_cellForInputFromTable:(UITableView *)tableView
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kInputCellReuseIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kInputCellReuseIdentifier];
  }
  UITextField *inputField = [[UITextField alloc] initWithFrame:CGRectZero];
  inputField.text = @"66666";
  inputField.keyboardType = UIKeyboardTypeNumberPad;
  [inputField sizeToFit];
  inputField.text = @"";
  self.activeInputField = inputField;
  cell.accessoryView = inputField;
  cell.textLabel.text = @"Dice rolls";
  return cell;
}

- (UITableViewCell *)_cellFromTable:(UITableView *)tableView forDicewareWordNumber:(PPDicewareNumber)wordNumber
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWordCellReuseIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kWordCellReuseIdentifier];
  }
  cell.textLabel.text = [NSString pp_wordAtIndex:wordNumber fromDicewareWordlist:_dicewareWordList];
  cell.detailTextLabel.text = [NSString pp_dicewareStringFromNumber:wordNumber];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  PPWordLookupSections section = indexPath.section;
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  switch (section) {
    case PPWordLookupSectionInput:
      [self.activeInputField becomeFirstResponder];
      break;
      
    case PPWordLookupSectionWords:
      [self.activeInputField resignFirstResponder];
      break;
      
    case PPWordLookupSectionNumSections:
      NSAssert(NO, @"Invalid section");
      break;
  }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  return [_inputValidator numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)] == 1;
}

- (void)_inputFieldDidChange:(UITextField *)inputField
{
  NSString *text = inputField.text;
  if (text.length == kDicewareRollCount) {
    PPDicewareNumber number = [text pp_dicewareNumber];
    [_generatedDicewareNumbers insertObject:@(number) atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:PPWordLookupSectionWords];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    inputField.text = @"";
  }
}

@end
