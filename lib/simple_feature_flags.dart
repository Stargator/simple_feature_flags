// Copyright (c) 2015, Ole Martin Gjersvik. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The simple_feature_flags library.
///
/// This is an awesome library. More dartdocs go here.
library simple_feature_flags;

import 'dart:async';

/// returns true if any source has the [feature]. 
bool isOn(String feature) => _union.contains(feature);
/// returns true if none of the source has the [feature]. 
bool isOff(String feature) => !_union.contains(feature);

/// returns a Future that fires true when a source has the feature.
/// This future will never throw or return any other value than true. But it may never fire.
/// If the feature alredy exist then the future will complete fast with true.
Future<bool> whenOn(String feature) async{
  if(isOn(feature)){
    return true;
  }
  if(!_whenOn.containsKey(feature)){
    _whenOn[feature] = new Completer();
  }
  return _whenOn[feature].future;
}

/// works like whenOff only that it returns false when the feature is removed from all sources.
Future<bool> whenOff(String feature) async{
  // TODO unittest me;
  if(isOff(feature)){
    return false;
  }
  
  if(!_whenOff.containsKey(feature)){
    _whenOff[feature] = new Completer();
  }
  
  return _whenOff[feature].future;
}

/// Add or replace a named source.
void addSource(String name, Iterable<String> source){
  _sources[name] = source.toSet();
  _updateUnion();
}

/// Removes a source if it exsist.
void removeSource(String name){
  if(_sources.remove(name) != null){
    _updateUnion();
  }
}

/// Removes all sources. May be useful to reset after unittest.
void removeAll(){
  _sources.clear();
  _updateUnion();
}

/// get the names of all sources registered.
List<String> sources(){
  return _sources.keys.toList();
}

/// get a set of all fatures that are enabled.
Set<String> getAll(){
  // TODO unittest me;
  return new Set.from(_union);
}

/// return a union of sources metions. Sources that do not exist are ignored.
Set<String> get(Iterable<String> names){
  // TODO unittest me;
  return names
    .where(_sources.containsKey)
    .map((name)=> _sources[name])
    .fold(new Set(), (Set a,Set b)=> a.union(b));
}

Map<String,Completer<bool>> _whenOn = {};
Map<String,Completer<bool>> _whenOff = {};
Map<String,Set<String>> _sources = {};
Set<String> _union = new Set();

_updateUnion(){
  var oldUnion = _union;
  _union = _sources.values.fold(new Set(), (Set a,Set b) => a.union(b));
  
  // removed
  oldUnion.difference(_union)
    .where(_whenOff.containsKey)
    .map(_whenOff.remove)
    .forEach((Completer c) => c.complete(false));
  
  // added
  _union.difference(oldUnion)
    .where(_whenOn.containsKey)
    .map(_whenOn.remove)
    .forEach((Completer c) => c.complete(true));
}