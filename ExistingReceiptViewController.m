//
//  ExistingReceiptViewController.m
//  BillApp
//
//  Created by X Code User on 10/25/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import "ExistingReceiptViewController.h"
#import "ReceiptTableViewController.h"
#import "tesseract.h"
@interface ExistingReceiptViewController ()

@end

@implementation ExistingReceiptViewController

BOOL receiptSelected = NO;
//NSMutableArray *entries;

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
    // Do any additional setup after loading the view.
    
    [self selectPhoto:(UIButton *)@"ExistingReceipt"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get destination view
    //[[segue destinationViewController] setProducts:self.product setPrices:self.prices];
    [[segue destinationViewController] setGvItems:self.gvItems];
}


//CODE FROM: http://beageek.biz/saveload-imagevideos-camera-roll-xcode-ios/


- (IBAction)selectPhoto:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

//this method is called when the UIimagepicker successfully picks an image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    receiptSelected = YES;
}

//this method is called when user cancels
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    receiptSelected = NO;
}

//Scan Receipt Button
- (IBAction)scanReceipt:(UIButton *)sender {
    //_entries = [[NSMutableArray alloc] init];
    
    //reset the variable incase user re-enters this screen
    receiptSelected = NO;
    
    //Activity Viewe wheel animation
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center=self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        //Call your function or whatever work that needs to be done
        //Code in this part is run on a background thread
        
        //TODO PARSE STRING
        _myWords = [[self tesseractOCR] componentsSeparatedByString:@"\n"];
        //NSLog(@"%@", _myWords);
        [self removeJunkMyWords];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            
            //Stop your activity indicator or anything else with the GUI
            //Code here is run on the main thread
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [self performSegueWithIdentifier:@"TOtable" sender:self];
        });
        
    });
    
}

//Remove Junk _myWords
- (void)removeJunkMyWords
{
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *specialChars = [NSCharacterSet characterSetWithCharactersInString:@"@%"];
    
    _entries = [[NSMutableArray alloc] init];
    _prices = [[NSMutableArray alloc] init];
    _product = [[NSMutableArray alloc] init];
    self.gvItems = [[NSMutableArray alloc] init];
    
    int fullString = 0;
    int productLocation = 0;
    
    //get rid of unwanted lines and ending tags
    for (int i = 0; i < [_myWords count]; i++) {
        
        //remove lines we don't want
        if([_myWords[i] rangeOfCharacterFromSet: numbers].location != NSNotFound)
            if([_myWords[i] rangeOfString:@"Total"].location == NSNotFound &&
               [_myWords[i] rangeOfString:@"Tax"].location == NSNotFound &&
               [_myWords[i] rangeOfString:@"Cash"].location == NSNotFound &&
               [_myWords[i] rangeOfString:@"T 0 T A L"].location == NSNotFound &&
               [_myWords[i] rangeOfString:@"SUBTOTAL"].location == NSNotFound &&
               [_myWords[i] rangeOfString:@"AMOUNT"].location == NSNotFound &&
               [_myWords[i] rangeOfCharacterFromSet:specialChars].location == NSNotFound){
                
                
                //substring before add, remove everything after price (0.00)
                for (int j = [_myWords[i] length]; j > 0; j--) {
                    NSRange range = [_myWords[i] rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString:@"."]];
                    fullString = range.location + 3;
                    
                }
                if(fullString>0)
                    //NSRangeException
                    [_entries addObject:[_myWords[i] substringToIndex:fullString]];
            }
    }
    
    //parse product and price
    for (int i = 0; i < [_entries count]; i++) {
        productLocation =[[_entries objectAtIndex:i] length];
        
        for (int k = [[_entries objectAtIndex:i] length]; k > 0; k--) {
            //for (int k = 0; k < [[_entries objectAtIndex:i] length]; k++) {
            //NSRange range = [[_entries objectAtIndex:i] rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString:@" "]];
            NSString *temp = [_entries objectAtIndex:i];// substringWithRange:NSMakeRange(k, 1)];
            temp = [temp substringWithRange:NSMakeRange(k-1,1)];
            //NSLog(@"%@", temp);
            if([temp isEqual: @" "]){
                productLocation = k;
                k = -1;
            }
            
        }
        
        GVItems* item = [[GVItems alloc] initWithName:[[_entries objectAtIndex:i]
                                                       substringToIndex:productLocation]
                                                 cost:[[[_entries objectAtIndex:i] substringFromIndex:productLocation] doubleValue]
                                            productID:nil
                                           sharedItem:nil
                                             boughtBy:nil
                                                group:nil];
        [self.gvItems addObject:item];
        //[_product addObject:[[_entries objectAtIndex:i] substringToIndex:productLocation]];
        //[_prices addObject:[[_entries objectAtIndex:i] substringFromIndex:productLocation]];
        
    }
    
    
    NSLog(@"Entries: %@", _entries);
    NSLog(@"Product: %@", _product);
    NSLog(@"Prices: %@", _prices);
}

//send _myWords to database
- (void)sendDatabaseMyWords
{
    
}

//Choose Receipt Button
- (IBAction)chooseReceipt:(UIButton *)sender {
    [self selectPhoto:(UIButton *)@"ExistingReceipt"];
}

- (NSString *)tesseractOCR
{
    Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    [tesseract setImage:self.imageView.image];
    [tesseract recognize];
    
    //NSLog(@"%@", [tesseract recognizedText]);
    return [tesseract recognizedText];
}
@end
