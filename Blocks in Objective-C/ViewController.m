//
//  ViewController.m
//  Blocks in Objective-C
//
//  Created by Andrew Jaffee on 2/10/17.
//  Updated: 12/29/17 for iosbrain.com article.
/*
 
 Copyright (c) 2017 Andrew L. Jaffee, microIT Infrastructure, LLC, and
 iosbrain.com.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 NOTE: As this code makes URL references to NASA images, if you make use of
 those URLs, you MUST abide by NASA's image guidelines pursuant to
 https://www.nasa.gov/multimedia/guidelines/index.html
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
*/

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UITextField *counterValueTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (atomic) NSUInteger pressCounter;

@property (strong, nonatomic) NSMutableArray *listOfURLs;

@property (atomic) NSUInteger counter;

@property (atomic, strong) UIImage *image;

@end

@implementation ViewController

#pragma mark - Utility methods

/*!
 Given an array of NSURLs, write all of them to console and
 report the number of URLs written.
 
 @param listOfURLs An array containing a list of NSURLs.
 
 @returns Number of NSURLs written to console.
*/
- (NSUInteger)listURLs:(NSArray *)listOfURLs
{
    for (NSString *stringURL in listOfURLs)
    {
        NSLog(@"URL: %@", stringURL);
    }
    
    return [listOfURLs count];
}

#pragma mark - UIViewController delegate

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.progressView.progress = 0.0;
    
    self.counter = 0;
    
    self.pressCounter = 0;
    
    self.listOfURLs = [[NSMutableArray alloc] init];
    
    // add URLs to NASA images that we'll display
    [self.listOfURLs addObject:@"https://cdn.spacetelescope.org/archives/images/publicationjpg/heic1509a.jpg"];
    [self.listOfURLs addObject:@"https://cdn.spacetelescope.org/archives/images/publicationjpg/heic1501a.jpg"];
    [self.listOfURLs addObject:@"https://cdn.spacetelescope.org/archives/images/publicationjpg/heic1107a.jpg"];
    [self.listOfURLs addObject:@"https://cdn.spacetelescope.org/archives/images/large/heic0715a.jpg"];
    [self.listOfURLs addObject:@"https://cdn.spacetelescope.org/archives/images/publicationjpg/heic1608a.jpg"];
    [self.listOfURLs addObject:@"https://cdn.spacetelescope.org/archives/images/publicationjpg/potw1345a.jpg"];
    [self.listOfURLs addObject:@"https://cdn.spacetelescope.org/archives/images/large/heic1307a.jpg"];
    [self.listOfURLs addObject:@"https://cdn.spacetelescope.org/archives/images/publicationjpg/heic0817a.jpg"];
    [self.listOfURLs addObject:@"https://cdn.spacetelescope.org/archives/images/publicationjpg/opo0328a.jpg"];
    [self.listOfURLs addObject:@"https://cdn.spacetelescope.org/archives/images/publicationjpg/heic0506a.jpg"];
    [self.listOfURLs addObject:@"https://cdn.spacetelescope.org/archives/images/large/heic0503a.jpg"];

    [self listURLs:self.listOfURLs];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Define blocks

/*! 
 Define a completion block TYPE for updating a UIImageView once an image downloads.
*/
typedef void (^ImageDownloadCompletionBlock) (BOOL success, NSString* message);

#pragma mark - Concurrent, asynchronous image downloads

/*!
 Specify the completion handler/callback to be executed when finished downloading
 each image in a set of very large images. We do the downloading
 in the background (concurrently and asynchronously).
*/
- (void)prepareForAsyncImageDownloads
{
    // Define a completion block INSTANCE for updating a UIImageView once an image downloads.
    ImageDownloadCompletionBlock completionBlock = ^(BOOL success, NSString* message)
    {
        if (success)
        {
            self.imageView.image = self.image;
            self.progressView.progress = (float)self.counter / (float)self.listOfURLs.count;
            
            NSLog(@"%@", message);
        }
        else
        {
            self.imageView.image = nil;
            NSLog(@"%@", message);
        }
    };
    
    // start download process; each download task will call back/communicate
    // that it's finished by executing the completionBlock paramter
    [self performAsyncImageDownloadsWithCompletionBlock:completionBlock];
}

/*!
 Download a set of images specified by a list of URLs to those images. Spin each
 image download task off asynchronously on a concurrent queue (i.e., in the 
 background). When each image finishes downloading, call a block which updates
 the user interface to display the latest image.
 
 @param completionBlock A block to execute on the MAIN THREAD to update the UI with the latest image
*/
- (void)performAsyncImageDownloadsWithCompletionBlock:(ImageDownloadCompletionBlock)completionBlock
{
    
    // go through the list of URLs specifiying addresses to images
    // we want to download
    for (NSString *stringURL in self.listOfURLs)
    {
        
        // start the download for the current URL asynchronously and
        // in the background
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        { // Begin outer block

            NSURL *url = [NSURL URLWithString:stringURL];
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            self.image = [UIImage imageWithData:imageData];
            self.counter++;

            // jump back on the MAIN THREAD to update the UI
            dispatch_async(dispatch_get_main_queue(), ^
            { // Begin inner block
                
                // if an image was successfully downloaded...
                if (self.image)
                {
                    // this BLOCK updates the UI
                    NSString *successString = [NSString stringWithFormat:@"SUCCESS: Image downloaded successfully - %@.", [url absoluteString]];
                    completionBlock(YES, successString);
                }
                else // image download failed
                {
                    // this BLOCK updates the UI
                    NSString *errorString = [NSString stringWithFormat:@"ERROR: Image was NOT downloaded - %@.", [url absoluteString]];
                    completionBlock(NO, errorString);
                }
                
            }); // End inner block

        }); // End outer block
        
    } // end for (NSString *stringURL in self.listOfURLs)

} // end performAsyncImageDownloadsWithCompletionBlock

#pragma mark - User interactions

/*!
 Downloads images on a concurrent background queue and jumps
 onto the main thread to display each image.
*/
- (IBAction)startAsyncButtonTapped:(id)sender
{
    
    [self prepareForAsyncImageDownloads];
    
} // end startAsyncButtonTapped

/*!
 Downloads images on a serial background queue and jumps
 onto the main thread to display each image.
*/
- (IBAction)startSyncButtonTapped:(id)sender
{
    dispatch_queue_t serialQueue = dispatch_queue_create("com.iosbrain.SerialImageQueue", DISPATCH_QUEUE_SERIAL);

    for (NSString *stringURL in self.listOfURLs)
    {
        
        dispatch_async(serialQueue, ^
        {
            
            NSURL *url = [NSURL URLWithString:stringURL];
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:imageData];
            self.counter++;

            dispatch_async(dispatch_get_main_queue(), ^
            {
                NSLog(@"URL: %@", [url path]);
                self.imageView.image = image;
                self.progressView.progress = (float)self.counter / (float)self.listOfURLs.count;
            });
           
        });
        
    }

} // end startSyncButtonTapped

/*!
 Proves that UI is responsive during background image download.
 Pressing button increments variable and displays value in text box.
*/
- (IBAction)pressButtonTapped:(id)sender
{
    self.pressCounter++;
    // self.counterValueTextField.text = [NSString stringWithFormat:@"%li", (unsigned long)self.pressCounter];
    // Drew 12/29/17: display counter as a double
    self.counterValueTextField.text = [NSString stringWithFormat:@"%1.1f", (float)self.pressCounter];
}

@end
