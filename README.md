# simple_feature_flags

This is a simple libary to handle feature flags. Its is enviroment agnostic.
A feature is considded enabed if any of the sources enable it.

## Usage

A simple usage example will only print 'I am awesome':

    import 'package:simple_feature_flags/simple_feature_flags.dart' as feature;

    main() {
      feature.addSource('base', ['awesome_feature']);
      
      if(feature.isOn('awesome_feature')){
        print('I am awesome.');
      }
      
      if(feature.isOn('lame_feature')){
        print('I am lame');
      }
    }
    
## Features
 * Can have mutiple sources of feature data.
 * Only suport static features.
 
## Planed features when the need arises.
 * Dynamic features. Give a predicate as source bool (String feature).
 * Change events. Both as streams and futures.
 * Async sources.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
