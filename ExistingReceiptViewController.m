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
        [[segue destinationViewController] setDetailItem:self.myWords];
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
    //reset the variable incase user re-enters this screen
    receiptSelected = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        //Call your function or whatever work that needs to be done
        //Code in this part is run on a background thread
        
        //TODO PARSE STRING
        _myWords = [[self tesseractOCR] componentsSeparatedByString:@"\n"];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            
            //Stop your activity indicator or anything else with the GUI
            //Code here is run on the main thread
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [self performSegueWithIdentifier:@"TOtable" sender:self];
        });
        
    });
    
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
    
    NSLog(@"%@", [tesseract recognizedText]);
    return [tesseract recognizedText];
}
@end
