// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import "RTRViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AbbyyRtrSDK/AbbyyRtrSDK.h>

#import "RTRSelectedAreaView.h"

/// Cell ID for languagesTableView.
/// Name for text region layers.
static NSString* const RTRTextRegionLayerName = @"RTRTextRegionLayerName";

@interface RTRViewController () <AVCaptureVideoDataOutputSampleBufferDelegate,
	RTRDataCaptureServiceDelegate>



/// View with camera preview layer.
@property (nonatomic, weak) IBOutlet UIView* previewView;

/// View for displaying current area of interest.
@property (nonatomic, weak) IBOutlet RTRSelectedAreaView* overlayView;
/// Is recognition running.
@property (atomic, assign, getter=isRunning) BOOL running;
/// Image size.
@property (atomic, assign) CGSize imageBufferSize;

@end

#pragma mark -

@implementation RTRViewController {
	/// Camera session.
	AVCaptureSession* _session;
	/// Video preview layer.
	AVCaptureVideoPreviewLayer* _previewLayer;
	/// Session Preset.
	NSString* _sessionPreset;

	/// Engine for AbbyyRtrSDK.
	RTREngine* _engine;
	/// Service for runtime recognition.
	id<RTRDataCaptureService> _dataCaptureService;

	/// Area of interest in view coordinates.
	CGRect _selectedArea;
}

#pragma mark - UIView LifeCycle

- (void)viewDidLoad
{
	[super viewDidLoad];

	// Recommended session preset.
	_sessionPreset = AVCaptureSessionPreset1920x1080;
	_imageBufferSize = CGSizeMake(1920.f, 1080.f);

	__weak RTRViewController* weakSelf = self;
	void (^completion)(BOOL) = ^(BOOL accessGranted) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[weakSelf configureCompletionAccessGranted:accessGranted];
		});
	};

	AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
	switch(status) {
		case AVAuthorizationStatusAuthorized:
			completion(YES);
			break;

		case AVAuthorizationStatusNotDetermined:
		{
			[AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
				completion(granted);
			}];
			break;
		}

		case AVAuthorizationStatusRestricted:
		case AVAuthorizationStatusDenied:
			completion(NO);
			break;

		default:
			break;
	}
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

	BOOL wasRunning = self.isRunning;
	self.running = NO;
	[_dataCaptureService stopTasks];

	__weak typeof(self) weakSelf = self;
	[coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
		{
			CGSize oldSize = weakSelf.imageBufferSize;
			CGSize newSize = CGSizeMake(MIN(oldSize.width, oldSize.height), MAX(oldSize.width, oldSize.height));
			if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
				newSize = CGSizeMake(newSize.height, newSize.width);
			}
			weakSelf.imageBufferSize = newSize;
			[weakSelf updateAreaOfInterest];
			weakSelf.running = wasRunning;
		}];
}

- (void)configureCompletionAccessGranted:(BOOL)accessGranted
{
	if(![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        NSLog(@"Device has no camera");
		return;
	}

	if(!accessGranted) {
        NSLog(@"Camera access denied");
		return;
	}

	NSString* licensePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"ABBYY_2023"];
	_engine = [RTREngine sharedEngineWithLicenseData:[NSData dataWithContentsOfFile:licensePath]];
	if(_engine == nil) {
        NSLog(@"Invalid License");
		return;
	}

	_dataCaptureService = [_engine createDataCaptureServiceWithDelegate:self profile:@"MRZ"];

	[self configureAVCaptureSession];
	[self configurePreviewLayer];
	[_session startRunning];
    
    self.running = YES;

	[[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(avSessionFailed:)
		name: AVCaptureSessionRuntimeErrorNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(applicationDidEnterBackground)
		name: UIApplicationDidEnterBackgroundNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(applicationWillEnterForeground)
		name: UIApplicationWillEnterForegroundNotification object:nil];

}

- (void)updateAreaOfInterest
{
	// Scale area of interest from view coordinate system to image coordinates.
	CGRect selectedRect = CGRectApplyAffineTransform(_selectedArea,
		CGAffineTransformMakeScale(_imageBufferSize.width * 1.f / CGRectGetWidth(_overlayView.frame),
		_imageBufferSize.height * 1.f / CGRectGetHeight(_overlayView.frame)));

	[_dataCaptureService setAreaOfInterest:selectedRect];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[_session stopRunning];
	self.running = NO;
	[_dataCaptureService stopTasks];

	[super viewWillDisappear:animated];
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];

	[self updatePreviewLayerFrame];
}

- (void)updatePreviewLayerFrame
{
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	[_previewLayer.connection setVideoOrientation:[self videoOrientationFromInterfaceOrientation:orientation]];

	CGRect viewBounds = self.view.bounds;

	_previewLayer.frame = viewBounds;

	if(UIInterfaceOrientationIsPortrait(orientation)) {
		self.selectedArea = CGRectInset(viewBounds, CGRectGetWidth(viewBounds) / 15, 	CGRectGetHeight(viewBounds) / 3);
	} else {
		self.selectedArea = CGRectInset(viewBounds, CGRectGetWidth(viewBounds) / 8, CGRectGetHeight(viewBounds) / 8);
	}

	[self updateAreaOfInterest];
}

- (void)setSelectedArea:(CGRect)selectedArea
{
	_selectedArea = selectedArea;
	_overlayView.selectedArea = _selectedArea;
}

- (AVCaptureVideoOrientation)videoOrientationFromInterfaceOrientation:(UIInterfaceOrientation)orientation
{
	AVCaptureVideoOrientation result = AVCaptureVideoOrientationPortrait;
	switch(orientation) {
		case UIInterfaceOrientationPortrait:
			result = AVCaptureVideoOrientationPortrait;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			result = AVCaptureVideoOrientationPortraitUpsideDown;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			result = AVCaptureVideoOrientationLandscapeLeft;
			break;
		case UIInterfaceOrientationLandscapeRight:
			result = AVCaptureVideoOrientationLandscapeRight;
			break;
		default:
			break;
	}

	return result;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)applicationDidEnterBackground
{
	[_session stopRunning];
	[_dataCaptureService stopTasks];
}

- (void)applicationWillEnterForeground
{
	[_session startRunning];
}

#pragma mark - Actions

- (IBAction)CloseClick:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - AVCapture configuration

- (void)configureAVCaptureSession
{
	NSError* error = nil;
	_session = [[AVCaptureSession alloc] init];
	[_session setSessionPreset:_sessionPreset];

	AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if(error != nil) {
		NSLog(@"%@",[error localizedDescription]);
	}
	NSAssert([_session canAddInput:input], @"impossible to add AVCaptureDeviceInput");
	[_session addInput:input];

	AVCaptureVideoDataOutput* videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
	dispatch_queue_t videoDataOutputQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	[videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
	[videoDataOutput alwaysDiscardsLateVideoFrames];
	videoDataOutput.videoSettings = @{
		(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange),
	};
	NSAssert([_session canAddOutput:videoDataOutput], @"impossible to add AVCaptureVideoDataOutput");
	[_session addOutput:videoDataOutput];

	[[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
	AVCaptureVideoOrientation videoOrientation = [self videoOrientationFromInterfaceOrientation:
		[UIApplication sharedApplication].statusBarOrientation];
	[[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:videoOrientation];

	BOOL locked = [device lockForConfiguration:nil];
	if(locked) {
		if([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
			[device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
		}

		if([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
			[device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
		}

		[device unlockForConfiguration];
	}
}

- (void)configurePreviewLayer
{
	_previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
	_previewLayer.backgroundColor = [[UIColor blackColor] CGColor];
	_previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	CALayer* rootLayer = [self.previewView layer];
	[rootLayer insertSublayer:_previewLayer atIndex:0];

	[self updatePreviewLayerFrame];
}

- (void)avSessionFailed:(NSNotification*)notification
{
	UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"AVSession Failed!" message:nil preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction* alertControllerOkAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
	[alertController addAction:alertControllerOkAction];

	[self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput*)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
	fromConnection:(AVCaptureConnection*)connection
{
	if(!self.isRunning) {
		return;
	}

	__block BOOL invalidFrameOrientation = NO;
	dispatch_sync(dispatch_get_main_queue(), ^{
		AVCaptureVideoOrientation videoOrientation = [self videoOrientationFromInterfaceOrientation:
			[UIApplication sharedApplication].statusBarOrientation];
		if(connection.videoOrientation != videoOrientation) {
			[connection setVideoOrientation:videoOrientation];
			invalidFrameOrientation = YES;
		}
	});

	if(invalidFrameOrientation) {
		return;
	}

	[_dataCaptureService addSampleBuffer:sampleBuffer];
}

#pragma mark - RTRDataCaptureServiceDelegate

- (void)onBufferProcessedWithDataScheme:(RTRDataScheme*)dataScheme dataFields:(NSArray<RTRDataField*>*)dataFields
	resultStatus:(RTRResultStabilityStatus)resultStatus
{
	if(!self.isRunning) {
		return;
	}

	if(dataScheme != nil && resultStatus == RTRResultStabilityStable) {
		self.running = NO;
        [self dismissViewControllerAnimated:NO completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PassportScanSuccess" object:dataFields];
        }];
	}
}

- (void)onWarning:(RTRCallbackWarningCode)warningCode {
	
}

- (void)onError:(NSError*)error {
	NSLog(@"Error: %@", error);
	if(!self.isRunning) {
		return;
	}
    NSString* description = error.localizedDescription;
    if([error.localizedDescription containsString:@"MRZ.rom"]) {
        description = @"MRZ is available in EXTENDED version only. Contact us for more information.";
    } else if([error.localizedDescription containsString:@"ChineseJapanese.rom"]) {
        description = @"Chineze, Japanese and Korean are available in EXTENDED version only. Contact us for more information.";
    }
	self.running = NO;
}

@end
