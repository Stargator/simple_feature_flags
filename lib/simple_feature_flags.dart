// Copyright (c) 2015, Ole Martin Gjersvik. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The simple_feature_flags library.
///
/// This is an awesome library. More dartdocs go here.
library simple_feature_flags;

/// returns true if any source has the [feature]. 
bool isOn(String feature) => _union.contains(feature);
/// returns true if none of the source has the [feature]. 
bool isNotOn(String feature) => !_union.contains(feature);

/// Add or replace a named source.
void addSource(String name, Iterable<String> source){
  _sources[name] = source.toSet();
  _updateUnion();
}

/// Removes a source. If there is not a source by that name this function is a noop.
void removeSource(String name){
  if(_sources.remove(name) != null){
    _updateUnion();
  }
}

/// Removes all sources. May be useful to reset after unittest.
void removeAll(){
  _sources.clear();
  _union.clear();
}

Map<String,Set<String>> _sources = {};
Set<String> _union = new Set();

_updateUnion(){
  _union = _sources.values.fold(new Set(), (Set a,Set b) => a.union(b));
}