// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library simple_feature_flags.example;

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
