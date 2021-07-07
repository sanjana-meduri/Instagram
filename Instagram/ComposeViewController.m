//
//  ComposeViewController.m
//  Instagram
//
//  Created by Sanjana Meduri on 7/7/21.
//

#import "ComposeViewController.h"
#import "Post.h"

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *composeTextView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = nil;
    self.composeTextView.text = @"";
    
    self.composeTextView.delegate = self;
    self.composeTextView.layer.borderWidth = 2.0f;
    self.composeTextView.layer.borderColor = [[UIColor systemGrayColor] CGColor];
    self.composeTextView.layer.cornerRadius = 8;
    
    [self getPicture:YES];
}

//refactored codepath snippet into function with boolean parameter
- (void) getPicture:(BOOL)willTakePicture{
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if (willTakePicture){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        else
            NSLog(@"Camera 🚫 available so we will use photo library instead");
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // next two lines are from codepath
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    CGSize newSize = CGSizeMake(20, 20);
    UIImage *resizedImage = [self resizeImage:editedImage withSize:newSize];
    
    [self.imageView setImage:editedImage];
    
    
    // following line from codepath
    [self dismissViewControllerAnimated:YES completion:nil];
}

//method from codepath
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)onPost:(id)sender {
    UIImage *imageToPost = self.imageView.image;
    NSString *captionToPost = self.composeTextView.text;
    
    [Post postUserImage:imageToPost withCaption:captionToPost withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            NSLog(@"posted image successfuly");
            [self dismissViewControllerAnimated:true completion:nil];
        }
        else{
            NSLog(@"Error posting: %@", error.localizedDescription);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
