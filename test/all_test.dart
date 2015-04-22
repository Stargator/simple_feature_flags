// Copyright (c) 2015, Ole Martin Gjersvik. All rights reserved. Use of this
// source code is governed by a BSD-style license that can be found in the
// LICENSE file.

library simple_feature_flags.test;

import 'dart:async';

import 'package:unittest/unittest.dart';
import 'package:simple_feature_flags/simple_feature_flags.dart' as feature;

main() {
  tearDown(() {
    feature.removeAll();
  });
  
  group('is*', (){
    test('No featrues', () {
      expect(feature.isOn('any_feature'),isFalse);
      expect(feature.isOff('any_feature'),isTrue);
    });

    test('Has a feature', () {
      feature.addSource('test_source', ['test_feature']);
      
      expect(feature.isOn('test_feature'),isTrue);
      expect(feature.isOff('test_feature'),isFalse);
    });
  });
  
  group('whenOn', (){
    test('If its alredy there shuld complete quikly',() async {
      feature.addSource('test_source', ['test']);
      var future = feature.whenOn('test').timeout(new Duration(milliseconds:100));
      
      expect(await future, isTrue);
    });
    
    test('If never added shuld never complete',() async {
      feature.addSource('test_source', ['test']);
      try{
        await feature.whenOn('not_a_feature').timeout(new Duration(milliseconds:100));
        fail('Shuld not have completed');
      }catch(e){
        expect(e,new isInstanceOf<TimeoutException>('TimeoutException'));
        return;
      }
    });
    
    test('Completes if added later',() async {
      feature.addSource('test_source', ['test']);
      
      var future = feature.whenOn('test2');
      bool notYet = await future.timeout(new Duration(milliseconds:100),onTimeout: () => null);
      expect(notYet, isNull);
      feature.addSource('test_source2', ['test2']);
      
      return expect(await future.timeout(new Duration(milliseconds:100)), isTrue);
    });
  });
  
  group('whenOff', (){
    test('If its not there shuld complete quikly',() async {
      var future = feature.whenOff('test').timeout(new Duration(milliseconds:100));
      
      expect(await future, isFalse);
    });
    
    test('If never removed shuld never complete',() async {
      feature.addSource('test_source', ['test']);
      try{
        await feature.whenOff('test').timeout(new Duration(milliseconds:100));
        fail('Shuld not have completed');
      }catch(e){
        expect(e,new isInstanceOf<TimeoutException>('TimeoutException'));
        return;
      }
    });
    
    test('Completes if removed later',() async {
      feature.addSource('test_source', ['test']);
      
      var future = feature.whenOff('test');
      bool notYet = await future.timeout(new Duration(milliseconds:100),onTimeout: () => null);
      expect(notYet, isNull);
      feature.removeSource('test_source');
      
      return expect(await future.timeout(new Duration(milliseconds:100)), isFalse);
    });
  });
  
  group('sources', (){
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
    
    test('get sources',(){
      feature.addSource('test_source', ['test1','test2']);
      feature.addSource('test_source2', ['test2','test3']);
      
      expect(feature.sources(),['test_source','test_source2']);
    });
  });
  
  group('get', (){
    setUp((){
      feature.addSource('source', ['test1','test2']);
      feature.addSource('source2', ['test2','test3']);
      feature.addSource('source3', ['test1','test4']);
    });
    
    test('getAll', (){
      expect(feature.getAll(),['test1','test2','test3','test4']);
    });
    
    test('empty', (){
      expect(feature.get([]),[]);
    });
    
    test('some sources', (){
      expect(feature.get(['source','source3']),['test1','test2','test4']);
    });
  });

}
