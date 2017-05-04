//
//  ViewController.m
//  statement
//
//  Created by Alexander Kuhar on 4/4/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//
#import "CreateStatementViewController.h"
#import "AppDelegate.h"

@interface CreateStatementViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarBottomConstraint;

@end

@implementation CreateStatementViewController

#pragma mark - UIViewController

@synthesize createdStatement;

AppDelegate *appDelegate;
Statement *selectedStatement;

CGFloat initialBottomConstraint;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _context = [[appDelegate persistentContainer] viewContext];
    _fetchController = [appDelegate initializeFetchedResultsControllerForEntity:@"Statement"
                                                             withSortDescriptor:@"createdDate"];
    
    _fetchController.delegate = self;
    _statementTextField.delegate = self;
    
    initialBottomConstraint = _toolbarBottomConstraint.constant;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [appDelegate saveContext];
}

- (IBAction)touchUpCreateStatement:(id)sender {
    
    [self createStatement];
}


- (void)createStatement {
    
    if (![_statementTextField.text isEqual:@""]) {
        
        NSError *error = nil;
        
        self.createdStatement = [NSEntityDescription insertNewObjectForEntityForName:@"Statement" inManagedObjectContext:_context];
        self.createdStatement.statementText = _statementTextField.text;
        self.createdStatement.completed = NO;
        self.createdStatement.createdDate = [NSDate date];
        
        NSLog(@"%@", self.createdStatement.createdDate);
        
        [appDelegate saveContext];
        
        if(![_fetchController performFetch:&error]) {
            
            NSLog(@"Failed to perform fetch: %@", error);
        }
        
        [_statementTextField resignFirstResponder];
    }
}

- (void)checkTask:(UIButton *)sender {
    
    StatementCustomCell *cell = (StatementCustomCell *) [[sender superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    Statement *statementIndexObject = [_fetchController objectAtIndexPath:indexPath];
    
    if(statementIndexObject.completed == NO) {
        
        statementIndexObject.completed = YES;
        
        [cell.checkboxButton setSelected:YES];
        
        NSMutableAttributedString *strikethroughString = [[NSMutableAttributedString alloc] initWithString:statementIndexObject.statementText];
        [strikethroughString addAttribute:NSStrikethroughStyleAttributeName value:@1 range:NSMakeRange(0, [strikethroughString length])];
        cell.textLabel.attributedText = strikethroughString;
        
    } else if(statementIndexObject.completed == YES) {
        
        statementIndexObject.completed = NO;
        
        [cell.checkboxButton setSelected:NO];
        
        cell.textLabel.text = statementIndexObject.statementText;
    }
}

#pragma mark - Keyboard Notification Selectors

- (void)keyboardWillShow: (NSNotification *)notification {
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSNumber *animationNumber = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    double animationDuration = [animationNumber doubleValue];
    
    NSNumber *curveDuration = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveDuration.intValue;
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:(animationCurve << 16) animations:^ {
        
        self.toolbarBottomConstraint.constant += keyboardSize.height;
        
        CGRect frame = _bottomToolbar.frame;
        frame.origin.y = keyboardSize.height;
        _bottomToolbar.frame = frame;
        
    }completion:nil];
}

- (void)keyboardWillHide: (NSNotification *)notification {

    NSNumber *animationNumber = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    double animationDuration = [animationNumber doubleValue];
    
    NSNumber *curveDuration = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveDuration.intValue;
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:(animationCurve << 16) animations:^ {
        
        self.toolbarBottomConstraint.constant = initialBottomConstraint;
        
        CGRect frame = _bottomToolbar.frame;
        frame.origin.y = self.view.frame.size.height - frame.size.height;
        _bottomToolbar.frame = frame;
        
    }completion:nil];
    
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_fetchController.fetchedObjects.count > 0) {
        return _fetchController.fetchedObjects.count;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[_fetchController managedObjectContext] deleteObject:[_fetchController objectAtIndexPath:indexPath]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedStatement = [_fetchController objectAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"statementDetails" sender:self];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TableView Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StatementCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statementCell"];
    Statement *statementIndexObject = (Statement *)[_fetchController objectAtIndexPath:indexPath];
    
    if(statementIndexObject.completed == NO){
        
        [cell.checkboxButton setSelected:NO];
        cell.textLabel.text = statementIndexObject.statementText;
    } else if(statementIndexObject.completed == YES) {
        
        [cell.checkboxButton setSelected:YES];
        
        NSMutableAttributedString *strikethroughString = [[NSMutableAttributedString alloc] initWithString:statementIndexObject.statementText];
        [strikethroughString addAttribute:NSStrikethroughStyleAttributeName value:@1 range:NSMakeRange(0, [strikethroughString length])];
        cell.textLabel.attributedText = strikethroughString;
    }
    
    [cell.checkboxButton addTarget:self action:@selector(checkTask:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - Fetched Results Controller Delegate

- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    controller = _fetchController;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView]insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self tableView]deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        default:
            break;
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView endUpdates];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (![textField.text  isEqual: @""]) {
        
        [self createStatement];
    }

    [textField resignFirstResponder];
    return TRUE;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.text = nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.text = nil;
}

#pragma mark - Segue Preparation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier  isEqual: @"statementDetails"]) {
        
        StatementDetailsViewController *nextController = segue.destinationViewController;
        
        NSFetchRequest *statementFetch = [[NSFetchRequest alloc] initWithEntityName:@"Statement"];
        statementFetch.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:YES]];
        statementFetch.predicate = [NSPredicate predicateWithFormat:@"statementText == %@" argumentArray:@[selectedStatement.statementText]];
        
        NSFetchedResultsController *nextFetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:statementFetch managedObjectContext:_fetchController.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        nextController.fetchController = nextFetchController;
        nextController.statementFetch = statementFetch;
        nextController.selectedStatement = selectedStatement;
    }
}

@end
