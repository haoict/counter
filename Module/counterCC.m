#import "counterCC.h"

CounterViewController *globalVC;
@implementation CounterViewController
- (CounterViewController *)initWithNibName:(NSString*)name bundle:(NSBundle*)bundle {
    self = [super initWithNibName:name bundle:bundle];

    if(self) {
        self.view.clipsToBounds = YES;

        self.counter = [CounterManager sharedInstance];

        self.counterLabel = [[UILabel alloc] init];
        self.counterLabel.textAlignment = NSTextAlignmentCenter;
        self.counterLabel.textColor = [UIColor whiteColor];
        self.counterLabel.text = [NSString stringWithFormat:@"%i", self.counter.unlocks];
        self.counterLabel.font = [UIFont boldSystemFontOfSize:30.0f];
        self.counterLabel.adjustsFontSizeToFitWidth = YES;
        self.counterLabel.minimumScaleFactor = 0.05;
        self.counterLabel.numberOfLines = 1;

        [self.view addSubview:self.counterLabel];

        self.counterLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.counterLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
        [self.counterLabel.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
        [self.counterLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
        [self.counterLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;

        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reset)];
        [self.view addGestureRecognizer:singleFingerTap];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/MagmaEvo.dylib"]) {
            NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.noisyflake.magmaevo.plist"];
            NSString *togglesContainerBackground = settings[@"togglesContainerBackground"]; 

            if(togglesContainerBackground) {
                [self.view.layer setContinuousCorners:YES];
                self.view.layer.cornerRadius = 19.0f;
                self.view.backgroundColor = LCPParseColorString(togglesContainerBackground, @"#000000:1.00");
            }
        }
    }

    return self;
}

- (void)willBecomeActive {
    [self.counter sync];
    self.counterLabel.text = [NSString stringWithFormat:@"%i", self.counter.unlocks];
}

- (void)reset {
    [self.counter reset];
    self.counterLabel.text = [NSString stringWithFormat:@"%i", self.counter.unlocks];
}

- (BOOL)_canShowWhileLocked {
    return YES;
}

- (BOOL)shouldBeginTransitionToExpandedContentModule {
    return NO;
}

@end

@implementation counterCC
- (counterCC *)init {
    self = [super init];

    if (self) {
        _contentViewController = [[CounterViewController alloc] init];
    }

    return self;
}

@end
