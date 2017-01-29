#import <UIKit/UIKit.h>
#import "Macros.h"
#import "vm_writeData.h"

bool shown;

int menuCreationCount = 0;
int hookCount = 0;

NSUserDefaults *defaults;

UIButton *closeButton;
UIButton *openButton;
UIButton *resetFOV;

UISlider *fovSlider;

UILabel *currentFOV;

UILongPressGestureRecognizer *longPress;

UIView *main;

float fov(void *self){
    return fovSlider.value;
}

%hook UnityAppController

- (void)applicationDidBecomeActive:(id)arg0 {
    %orig;
    
    defaults = [NSUserDefaults standardUserDefaults];

    if(!shown){
        alert(@"Critical Ops Field of View Chooser", @"Made by shmoo for iosgods.com. IMPORTANT: triple click the home button to get the red button to show.", @"Thanks");

    shown = !shown;
    }

    if(![defaults boolForKey:@"alertShown"]){
        alert(@"NOTICE: iPhone 5/5s/5c/SE and iPod 5/6 Users", @"Hold down on the red button to close the UI. This alert will not be shown again.", @"Okay");

        [defaults setBool:true forKey:@"alertShown"];
    }

    main = [UIApplication sharedApplication].keyWindow.rootViewController.view;

    openButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    openButton.frame = CGRectMake((main.frame.size.width/2)-15,(main.frame.size.height/2)+75,30,30);
    openButton.backgroundColor = [UIColor clearColor];
    openButton.layer.cornerRadius = 16;
    openButton.layer.borderWidth = 2.0f;
    openButton.layer.borderColor = rgb(0xaa0114).CGColor;
    [openButton addTarget:self action:@selector(setupGUI) 
forControlEvents:UIControlEventTouchDragInside];
    [main addSubview:openButton];

    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(closeGUI)];
    [openButton addGestureRecognizer:longPress];
}

%new
- (void)setupGUI {
    if(menuCreationCount == 0){
        fovSlider = [[UISlider alloc] initWithFrame:CGRectMake(main.frame.origin.x+18, main.frame.origin.y+9, 460, 31)];
        fovSlider.maximumValue = 180;
        fovSlider.minimumValue = 10;

        if(![defaults floatForKey:@"fovvalue"]){
            fovSlider.value = 60;
        }
        else{
            fovSlider.value = [defaults floatForKey:@"fovvalue"];
        }

        if(hookCount == 0){
               MSHookFunction((void*)(_dyld_get_image_vmaddr_slide(0) + /*removed*/ + 1),(void*)fov,(void**)0);
        }

        hookCount++;

        [fovSlider setMinimumTrackTintColor:rgb(0xaa0114)];
        [fovSlider setMaximumTrackTintColor:rgb(0xaa0114)];
        [fovSlider addTarget:self action:@selector(changeFOV:) forControlEvents:UIControlEventValueChanged];
        [main addSubview:fovSlider];

        resetFOV = [UIButton buttonWithType:UIButtonTypeCustom];
        resetFOV.frame = CGRectMake(fovSlider.frame.origin.x+466, main.frame.origin.y+9, 68, 30);
        [resetFOV setTitle:@"Reset" forState:UIControlStateNormal];
        [resetFOV setTitleColor:rgb(0xaa0114) forState:UIControlStateNormal];
        [resetFOV addTarget:self action:@selector(resetFOVToNormal) forControlEvents:UIControlEventTouchDown];
        [main addSubview:resetFOV];

        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(resetFOV.frame.origin.x+79, main.frame.origin.y+9, 68, 30);
        [closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [closeButton setTitleColor:rgb(0xaa0114) forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeGUI) forControlEvents:UIControlEventTouchDown];
        [main addSubview:closeButton];

        currentFOV = [[UILabel alloc] initWithFrame:CGRectMake(main.frame.origin.x+18, main.frame.origin.y+47, 456, 21)];
        currentFOV.text = [NSString stringWithFormat:@"Current FOV: %.2f", fovSlider.value];
        currentFOV.textColor = rgb(0xaa0114);
        [main addSubview:currentFOV];
    }

    menuCreationCount++;
}

%new
- (void)changeFOV:(UISlider *)slider {
    currentFOV.text = [NSString stringWithFormat:@"Current FOV: %.2f", fovSlider.value];
    
    [defaults setFloat:fovSlider.value forKey:@"fovvalue"];
}

%new
- (void)resetFOVToNormal {
    fovSlider.value = 60;
    
    currentFOV.text = [NSString stringWithFormat:@"Current FOV: %.2f", fovSlider.value];
    
    [defaults setFloat:fovSlider.value forKey:@"fovvalue"];
}

%new
- (void)closeGUI {
    [fovSlider removeFromSuperview];
    [resetFOV removeFromSuperview];
    [closeButton removeFromSuperview];
    [currentFOV removeFromSuperview];

    menuCreationCount = 0;
}
%end