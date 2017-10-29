# ISClusterFramework
Cluster pins on MapView in iOS SDK MapKit which using some clusterManager. It's help place pins on MapView.

# Example

<img src="https://github.com/DimaIgorevich/ISClusterFramework/blob/master/Resources/example0.PNG" width="290"> <img src="https://github.com/DimaIgorevich/ISClusterFramework/blob/master/Resources/example1.PNG" width="290"> <img src="https://github.com/DimaIgorevich/ISClusterFramework/blob/master/Resources/example2.PNG" width="290">

# Installation

You can upload project and just import files from [Core](ISClusterFramework/Core) to your project.

In folder Example you can find how configurate MapView with default-settings.

## Usage

Follow the instructions below:

### Step 1: Initialize a ClusterManager object

Create your clustering manager:
	
    self.clusteringManager = [[ISClusteringManager alloc] init];

### Step 2: Configurate a ClusterManager object
	
    self.clusteringManager.displaySettings.markerFont = [UIFont systemFontOfSize:14.f];
    self.clusteringManager.displaySettings.markerBorderColor = [UIColor whiteColor];
    self.clusteringManager.displaySettings.markerTextColor = [UIColor whiteColor];
    self.clusteringManager.displaySettings.displayBackgroundStyle = ISDisplayBackgroundStyleSolid;
    self.clusteringManager.displaySettings.markerBackgroundColor = [UIColor orangeColor];
    self.clusteringManager.displaySettings.scaleFactor = CGSizeMake(0.9, 1.2f);

### Step 3: Add annotations

	[self.clusteringManager addAnnotations:[self annotations]];
	
### Step 4: Reload the annotations
	
Implement MKMapView delegate method `mapView:regionDidChangeAnimated:` to display annotations grouped in clusters on the map. An example of implementation:

    - (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    	[[NSOperationQueue new] addOperationWithBlock:^{
        	double scale = self.vMap.bounds.size.width / self.vMap.visibleMapRect.size.width;
        	NSArray *annotations = [self.clusteringManager clusteredAnnotationsWithinMapRect:self.vMap.visibleMapRect 
									           withZoomScale:scale];
		[self.clusteringManager displayAnnotations:annotations onMapView:self.vMap];
    	}];
    }
	
**Important:** Call the method `mapView:regionDidChangeAnimated:` whenever you want to refresh currently visible map rectangle by yourself (for example, if you added annotations to `clusteringManager`).

### Step 5: Generate cluster view

All clusters will have `ISClusterAnnotation` class, so when MKMapView delegate methods are called, you can check if current annotation is cluster by checking its class. For example:

    - (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
   	if ([annotation isKindOfClass:ISClusterAnnotation.class]) {
            return [self.clusteringManager clusterAnnotationViewWithAnnotation:annotation onMapView:mapView];
    	} else {
	    NSLog(@"Normal annotation");
	}
		
	...
		
    return nil;
    }

**Important:** Call the method of clusterManager `clusterAnnotationViewWithAnnotationonMapView:` whenever you want to visible cluster view on map.

### Step 6: Show cluster view

Implement MKMapView delegate method `mapView:didSelectAnnotationView:` to show cluster view with grouped annotations on the map. An example of implementation:

    - (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(10_9, 4_0) {
   	if ([view isKindOfClass:ISClusterAnnotationView.class]) {
        	[self.vMap showClusterView:view animated:YES];
    	}
    }
	
## Additionals

You can configurate cluster view in next params:

+ DisplayBackgroundStyle (default ISDisplayBackgroundStyleSolid)
+ MarkerBackgroundColor
+ MarkerBorderColor
+ MarkerTextColor
+ MarkerFont
+ MarkerScaleFactor (default alpha = 0.3f delpha = 0.4f)

## Requirements

- iOS 8.3+
- Xcode 9.0+
- ARC

# License

ISClusterFramework is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
