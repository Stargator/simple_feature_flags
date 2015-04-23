# simple_feature_flags

This is a simple library to handle feature flags. Its is environment agnostic.
A feature is considered enabled if any of the sources enable it.

## Usage

A simple usage example will print 'I am cool' and
'Everything cool becomes lame':

```dart
import 'package:simple_feature_flags/simple_feature_flags.dart' as feature;

main() {
  feature.addSource('base', ['cool_feature']);
    
  if (feature.isOn('cool_feature')) {
    print('I am cool.');
  }
    
  if (feature.isOn('lame_feature')) {
    print('I am lame');
  }
    
  feature.whenOn('lame_feature').then((_) {
    print('Everything cool becomes lame');
  });
    
  feature.addSource('time', ['lame_feature']);
}
```

## Features

* Can have multiple sources of feature data.
* Only support static features.
* Run code on feature change.
 
## Planned features when the need arises.

* Sub features where what is enabled can be scoped.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/dartup/simple_feature_flags/issues
