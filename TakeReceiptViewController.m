//
//  TakeReceiptViewController.m
//  BillApp
//
//  Created by X Code User on 10/27/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//
//  Camera code and tutorial found at:
//     http://www.appcoda.com/ios-programming-camera-iphone-app/
//

#import "TakeReceiptViewController.h"
#import "tesseract.h"
@interface TakeReceiptViewController ()

@end

@implementation TakeReceiptViewController

BOOL hasCamera = YES;
BOOL photoSelected = NO;
UIImage *imageToBeSaved;

- (IBAction)scanButtonDisable:(id)sender {
    UIButton *scanButton = (UIButton*)sender;
    scanButton.enabled = NO;
}




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
    
    //check if device has a camera
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        hasCamera = NO;
        self.scanReceiptLabel.enabled = false;
    }
    
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [[segue destinationViewController] setGvItems:self.gvItems];
}


- (IBAction)takePhoto:(UIButton *)sender {
    
    if(hasCamera == YES){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    imageToBeSaved = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    photoSelected = YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    photoSelected = NO;
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



- (IBAction)scanReceipt:(UIButton *)sender {
    
    if(photoSelected == YES){
        
        //Activity Viewe wheel animation
        UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.center=self.view.center;
        [activityView startAnimating];
        [self.view addSubview:activityView];
        
        
        //SAVE PHOTO TO PHONE
        UIImageWriteToSavedPhotosAlbum(imageToBeSaved, nil, nil, nil);
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            
            //Call your function or whatever work that needs to be done
            //Code in this part is run on a background thread
            _myWords = [[self tesseractOCR] componentsSeparatedByString:@"\n"];
            [self removeJunkMyWords];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                //Stop your activity indicator or anything else with the GUI
                //Code here is run on the main thread
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                [self performSegueWithIdentifier:@"TOtable" sender:self];
            });
            
        });
         }
    self.scanReceiptLabel.enabled = true;
    //reset the variable incase user re-enters this screen
    photoSelected = NO;
}
- (NSString *)tesseractOCR
{
    Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    [tesseract setImage:self.imageView.image];
    [tesseract recognize];
    
    NSLog(@"%@", [tesseract recognizedText]);
    return [tesseract recognizedText];
}

@end
