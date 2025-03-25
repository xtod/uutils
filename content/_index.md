---
title: 首页
type: docs
---
<center><img src="/logo.svg" alt="uutils logo" title="uutils logo" /></center>

# uutils

uutils项目计划将命令必用程序全部使用Rust语言重新实现，并且使程序更加现代化，同时保持与现有必用程序的完全兼容性。

后续计划替换所有必要的Linux工具。

{{% columns ratio="1:1"  %}} <!-- begin columns block -->

## coreutils

uutils coreutils 是 Rust 中 GNU coreutils 的跨平台重构。虽然所有程序都已完成重构，但可能会缺少某些选项，或者可能会有一些不同的用法。

<---> <!-- magic separator, between columns -->

## findutils
GNU findutils 的Rust重构：`xargs`、`find`、`locate` 和 `updatedb`。

该项目旨在成为原始命令的直接替代品。

<---> <!-- magic separator, between columns -->

## diffutils
GNU diffutils 的Rust重构：`diff`、`cmp`、`diff3` 和 `sdiff`。

该项目旨在成为原始命令的直接替代品。
{{% /columns %}}