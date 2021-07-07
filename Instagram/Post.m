//
//  Post.m
//  Instagram
//
//  Created by Sanjana Meduri on 7/7/21.
//

#import "Post.h"

//from codepath

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;
@dynamic image;
@dynamic likeCount;
@dynamic commentCount;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    
    [newPost saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
     if (!image)
         return nil;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    if (!imageData)
        return nil;
    
    return [PFFileObject fileObjectWithName:@"image.jpeg" data:imageData];
}

@end
