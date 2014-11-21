//
//  TesseractViewController.m
//  BillApp
//
//  Created by X Code User on 11/2/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import "TesseractViewController.h"
#import "tesseract.h"
#import "ReceiptTableViewController.h"

@interface TesseractViewController ()

@end

@implementation TesseractViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setDetailItem:(UIImage*)newDetailItem
{
    if (self.receiptImage != newDetailItem) {
        self.receiptImage  = newDetailItem;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //activity wheel default
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    
self.navigationItem.hidesBackButton = YES;
    //Start an activity indicator here
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Call your function or whatever work that needs to be done
        //Code in this part is run on a background thread
        [self tesseractOCR];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            //Stop your activity indicator or anything else with the GUI
            //Code here is run on the main thread
            
            [activityIndicator stopAnimating];
            

        });
        
    });
    
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
    if ([[segue identifier] isEqualToString:@"TOreceipt"])
    {
        
        ReceiptTableViewController *vc = [segue destinationViewController];
        vc.text=[self tesseractOCR];
    }
    
}


- (NSString *)tesseractOCR
{
    //ADDED
    //[NSThread sleepForTimeInterval:5];
    Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    //[tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"];
    //UIImage *img=[UIImage imageNamed:@"target.jpg"];
   // [tesseract setImage:[UIImage imageNamed:@"target.jpg"]];
    [tesseract setImage:self.receiptImage];
    [tesseract recognize];
    
    NSLog(@"%@", [tesseract recognizedText]);
    return [tesseract recognizedText];
}
@end
