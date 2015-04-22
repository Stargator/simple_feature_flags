# simple_feature_flags

This is a simple libary to handle feature flags. Its is enviroment agnostic.
A feature is considded enabed if any of the sources enable it.

## Usage

A simple usage example will print 'I am cool' and
'Everything cool becomes lame':

  import 'package:simple_feature_flags/simple_feature_flags.dart' as feature;

  main() {
    feature.addSource('base', ['cool_feature']);
    
    if(feature.isOn('cool_feature')){
      print('I am cool.');
    }
    
    if(feature.isOn('lame_feature')){
      print('I am lame');
    }
    
    feature.whenOn('lame_feature').then((_){
      print('Everything cool becomes lame');
    });
    
    feature.addSource('time', ['lame_feature']);
  }

## Features
 * Can have mutiple sources of feature data.
 * Only suport static features.
 * Run code on feature change.
 
## Planed features when the need arises.
 * Sub features where some code can have its code anbaled but other not. 

## Features and bugs
Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/dartup/simple_feature_flags/issues
