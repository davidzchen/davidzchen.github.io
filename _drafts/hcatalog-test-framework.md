---
layout: post
title: "A Read/Write Test Framework for HCatalog"
date:   2014-06-11 20:13:24
categories: hive
---

This test suite.

# HCatalog Core

The first part of the test suite will test HCatalog core against various storage formats.

## Existing Tests

The HCatalog core tests has a collection of tests that test HCatalog read/write with different kinds of partitioning schemes and setups. These tests all extend the `HCatMapReduceTest`, which  These include:

<table class="table table-bordered table-condensed table-striped">
  <thead>
    <tr>
      <th>Test</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>`TestHCatPartitioned`</td>
      <td></td>
    </tr>
    <tr>
      <td>`TestHCatDynamicPartitioned`</td>
      <td></td>
    </tr>
    <tr>
      <td>`TestHCatNonPartitioned`</td>
      <td></td>
    </tr>
    <tr>
      <td>`TestHCatMutablePartitioned`</td>
      <td></td>
    </tr>
    <tr>
      <td>`TestHCatMutableDynamicPartitioned`</td>
      <td></td>
    </tr>
    <tr>
      <td>`TestHCatMutableNonPartitioned`</td>
      <td></td>
    </tr>
    <tr>
      <td>`TestHCatExternalPartitioned`</td>
      <td></td>
    </tr>
    <tr>
      <td>`TestHCatExternalDynamicPartitioned`</td>
      <td></td>
    </tr>
    <tr>
      <td>`TestHCatExternalNonPartitioned`</td>
      <td></td>
    </tr>
  </tbody>
</table>

`HCatMapReduceTest` allows tests that subclass it to specify the InputFormat, OutputFormat, and SerDe to run the tests by overriding the `inputFormat`, `outputFormat`, and `serdeClass` methods.

By default, all tests are run with RCFile, which is the default format specified in `HCatMapReduceTest`. There is currently one test, `TestOrcDynamicPartitioned`, that extends `HCatMapReduceTest` (via `TestHCatDynamicPartitioned`) and overrides the storage format, in this case to test against ORC rather than RCFile.

## New Tests

This test framework will use `HCatMapReduceTest` as a starting point.

# HCatalog Pig Adapter

## Existing Tests


## New Tests


