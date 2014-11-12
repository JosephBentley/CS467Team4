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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (IBAction)scanReceipt:(UIButton *)sender {
    
    if(photoSelected == YES){
        UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        activityView.center=self.view.center;
        
        [activityView startAnimating];
        
        [self.view addSubview:activityView];
        
        
        //SAVE PHOTO TO PHONE
        UIImageWriteToSavedPhotosAlbum(imageToBeSaved, nil, nil, nil);
        
        
        /*UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"photoSelected"
                                                              message:@"YES"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
            [myAlertView show];*/
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            //Call your function or whatever work that needs to be done
            //Code in this part is run on a background thread
            _myWords = [[self tesseractOCR] componentsSeparatedByString:@"\n"];
            
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
