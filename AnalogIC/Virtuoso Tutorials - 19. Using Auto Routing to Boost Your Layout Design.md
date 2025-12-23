# Virtuoso Tutorials - 18. How to Create a Voltage Supply Source with White Noise

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 23:37 on 2025-12-20 in Beijing.

## Introduction

从接触 Virtuoso 已经过了快半年，这半年间时不时就会听到/刷到 "自动布线" 的相关讨论，最近几次项目又深深感受到手动布线的痛苦。今天终于有时间和精力来探索一下 Virtuoso 的自动布线功能。

## 1. Basic Functions

**先在菜单栏右键勾选上 `Placement`** ，然后我们大致探索了一下 `Placement` 菜单下的功能，下面几个是比较实用的：
- (1) Auto Placement: 其实也不太实用，毕竟大多数情况下还是我们需要手动布局，除非一大堆纯数字管子
- (2) Add Guard Ring: 下面几个是可能用到的 (`onc18` 工艺库)


<!-- 自动布线时记得放 P&R Boundary, 否则过孔设置不会生效 (只会打一个过孔)。
 -->

自动布线前记得确保 `Preferred` 和 `Routable` 选项一致，否则过孔设置不会生效 (只会打一个过孔)。后面试的时候发现不一样也能两个过孔，反正奇怪得很。



### 1. Auto Placement

**先在菜单栏右键勾选上 `Placement`, 然后就能在 `Placement > Auto Placement` 中找到这个功能。** 注意 Auto Placement 只能对存在 PR Boundary 的版图作自动布局。



## Reference


- [博客园 > 自动布局布线使用说明](https://www.cnblogs.com/jinzbr/p/18235464)
- [Blogs > Analog/Custom Design > Routing Techniques for Custom IC Layout Design in Virtuoso Layout Suite](https://community.cadence.com/cadence_blogs_8/b/cic/posts/knowledge-booster-training-bytes-_2d00_-routing-techniques-in-virtuoso-layout-suite)