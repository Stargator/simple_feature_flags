// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library simple_feature_flags.test;

import 'package:unittest/unittest.dart';
import 'package:simple_feature_flags/simple_feature_flags.dart' as feature;

main() {
  setUp(() {
    feature.removeAll();
  });

  test('No featrues', () {
    expect(feature.isOn('any_feature'),isFalse);
    expect(feature.isNotOn('any_feature'),isTrue);
  });

  test('Has a feature', () {
    feature.addSource('test_source', ['test_feature']);
    
    expect(feature.isOn('test_feature'),isTrue);
    expect(feature.isNotOn('test_feature'),isFalse);
  });

  test('Mutiple sources', () {
    feature.addSource('test_source', ['test1','test2']);
    feature.addSource('test_source2', ['test2','test3']);
    
    expect(feature.isOn('test1'),isTrue);
    expect(feature.isOn('test2'),isTrue);
    expect(feature.isOn('test3'),isTrue);
    expect(feature.isOn('test4'),isFalse);
  });

  test('Remove sources', () {
    feature.addSource('test_source', ['test1','test2']);
    feature.addSource('test_source2', ['test2','test3']);
    feature.removeSource('test_source');
    
    expect(feature.isOn('test1'),isFalse);
    expect(feature.isOn('test2'),isTrue);
    expect(feature.isOn('test3'),isTrue);
  });

  test('Handle missbehaved sources', () {
    feature.addSource('double_source', ['test','test']);
    
    expect(feature.isOn('test'),isTrue);
  });
}
