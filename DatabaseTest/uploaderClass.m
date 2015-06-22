//
//  uploaderClass.m
//  DatabaseTest
//
//  Created by Tanmay Bakshi on 2015-06-15.
//  Copyright © 2015 TBSS. All rights reserved.
//

#import "uploaderClass.h"

@implementation uploaderClass

-(void)uploadImageToServer: (UIImage *)image name:(NSString*)filename {
    NSString *urlString = @"http://www.tanmaybakshi.com/upload.php";
    
    //Convert your UIImage to NSData
    NSData *imageData = UIImagePNGRepresentation(image);
    
    if (imageData != nil)
    {
        NSString *filenames = [NSString stringWithFormat:filename];      //set name here
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filenames\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[filenames dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //I use a method called randomStringWithLength: to create a unique name for the file, so when all the aapps are sending files to the server, none of them will have the same name:
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        //I chose to run my code async so the app could continue doing stuff while the image was sent to the server.
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             
             NSData *returnData = data;
             NSLog(@"data recieved!");
             doneYet = true;
             //Do what you want with your return data.
             
         }];
    }
}

-(BOOL)doneYetFunc {
    if (doneYet == true) {
        doneYet = false;
        return true;
    }
    return doneYet;
}
@end

