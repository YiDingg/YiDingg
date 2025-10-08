# Virtuoso Tutorials - 14. Understanding Substrate, Well, Tap, and Guard Ring in Analog IC Layout

> [!Note|style:callout|label:Infor]
> Initially published by Yi Ding (丁毅) at 20:03 on 2025-09-19 in Beijing.

## Introduction

作为一名 Analog IC Designer/Engineer, 不知你在 cadence virtuoso 中做版图设计时是否有过这样的疑问：
- 书上不是说 NMOS 都是放在 p-substrate 上吗，为什么版图界面黑黢黢的什么都没有？
- 这个这个蓝蓝的 PO 层是什么，好像就是晶体管的 gate? 那 PO 是啥意思，为什么要叫 PO 层不叫 GA 层？
- source/drain 端口下面这个红红的 OD 层又是什么？
- 怎么 NMOS/PMOS 的 source/drain 下面都是 OD 层？明明一个是 n-doping 一个是 p-doping，为什么都用 OD 层？
- 身边人都说晶体管外围要加 guard ring, 那么 guard ring 是什么，要怎么加？
- 怎么 guard ring (GR) 还分 n-well GR 和 p-sub GR 两种，我该用哪种？不管了，别人说 NMOS 用 n-well GR, PMOS 用 p-sub GR, 我就照葫芦画瓢吧
- tap 是什么？为什么有的人说晶体管要加 tap (连接 bulk), 但我自己做时完全没有 bulk (tap) 端口啊？
- PMOS 单独放在 n-well 里，所以 bulk 可以不统一连接这我知道，但 NMOS 不想统一连接 bulk 该如何处理？
- nch_dnw 里的 dnw (deep n-well) 又是啥，不是都有 n-well 了吗？

被太多类似的问题困扰，以至于做版图时一直云里雾里，只能参考别人做的版图依葫芦画瓢，总是提心吊胆，生怕哪里弄错了。

本文，我们就来聊聊这些问题，理清各种概念之间的关系，重点理解 substrate, well, tap, guard ring 这些概念在 Analog IC 版图设计中的作用和意义。

>注：本文中的所有示意图，除第一张来自 *Razavi CMOS* 外，均为笔者自己所绘制。

## Sub, Well, Tap, and GR

在 MOSFET 的结构示意图中, [Razavi CMOS page.8](https://www.zhihu.com/question/452068235/answer/95164892409) 所给出的图一定是经典之一：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-19-22-01-34_Virtuoso Tutorials - 14. Understanding Substrate, Well, Tap, and Guard Ring in Analog IC Layouts.png"/></div>


上图确实比较清晰，但是并不能帮助我们理解 layout 设计中各个层次的作用。作为对比，我们用结合版图视角/剖面视角看一下最简单的标准 NMOS/PMOS 结构：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-19-22-13-28_Virtuoso Tutorials - 14. Understanding Substrate, Well, Tap, and Guard Ring in Analog IC Layouts.png"/></div>

<!-- 上图中省略了 PP/NP 层等更深层次的工艺细节，这些细节对于理解晶体管的结构和原理并非必须，因此本文均予以忽略。 -->

在上图并没有连接晶体管的衬底，也即衬底并 NMOS bulk (p-substrate) 和 PMOS 的 bulk (n-well) 并没有得到连接，而是各自悬空 (floating)。有两种方法可以连接晶体管的 bulk (B)，一种是使用 tap (也称 bodytie)，另一种是借助 guard ring (GR)，如下图：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-19-22-13-47_Virtuoso Tutorials - 14. Understanding Substrate, Well, Tap, and Guard Ring in Analog IC Layouts.png"/></div>
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-19-22-13-58_Virtuoso Tutorials - 14. Understanding Substrate, Well, Tap, and Guard Ring in Analog IC Layouts.png"/></div>

然后是使用 guard ring (GR) 连接 bulk (B) 的示意图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-19-22-14-18_Virtuoso Tutorials - 14. Understanding Substrate, Well, Tap, and Guard Ring in Analog IC Layouts.png"/></div>

## Deep N-Well (DNW)

在一些工艺中，除了 n-well 之外，还会提供 deep n-well (DNW) 层。DNW 的作用是将 NMOS 与 global p-substrate 进行隔离，从而使此 NMOS 能够工作在一个独立的 local p-substrate 上，此时 NMOS 的 bulk (B) 端口就可以连接非 VSS (GND) 电位了，例如与 source (S) 短接。

需要注意的是 PMOS 是没有 DNW 结构的, NMOS with DNW 的结构示意图如下：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-09-20-10-36-37_202509_tsmcN65_LDO__basic_in-1d8-to-2d5_out-1d2__layout.png"/></div>


简单来讲, DNW NMOS 就是一个 bulk 可以不连接到 global p-substrate (VSS) 的 NMOS, 只要给其加上一个 n-well guard ring 就行。至于其 bulk (B) 的连接方式，与普通 NMOS 是一样的，即可以用 tap 也可以用 p-substrate guard ring.

## Reference

- [Planet Analog > Analog layout: Why wells, taps, and guard rings are crucial](https://www.planetanalog.com/analog-layout-why-wells-taps-and-guard-rings-are-crucial/)
- [Planet Analog > Additional structures in analog layout beyond schematic](https://www.planetanalog.com/additional-structures-in-analog-layout-beyond-schematic/)
- [Planet Analog > Using Deep N Wells in Analog Design](https://www.planetanalog.com/using-deep-n-wells-in-analog-design/)
- [Cadence Blogs > Analog Layout – Wells, Taps, and Guard rings](https://community.cadence.com/cadence_blogs_8/b/cic/posts/analog-layout-wells-taps-and-guard-rings)