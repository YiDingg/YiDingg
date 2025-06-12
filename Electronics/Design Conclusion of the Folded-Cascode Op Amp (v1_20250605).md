# Design Conclusion of the Folded-Cascode Op Amp (v1_20250605).md

> [!Note|style:callout|label:Infor]
> Initially published at 22:17 on 2025-06-05 in Beijing.

## Introduction

在五月底、六月初的这几天，我们学习了 gm-Id 设计方法，并尝试设计了一个 [five-transistor OTA](<Electronics/Design Example of F-OTA using Gm-Id Method.md>) 和一个 [folded-cascode op amp](<Electronics/Design of Folded-Cascode using Gm-Id Method in Cadence Virtuoso.md>)。尤其是后一个设计，耗费了我们相当多的时间和精力，但最后的性能结果却并不理想（很多指标都未达到）。这是因为我们对 gm-Id 方法的理解存在根本性的错误，也是我们把“挑好的”晶体管放到电路中后其静态工作点差异很大的原因。在这篇文章，我们先更正这个方法论上的错误，然后再对这两次设计进行一些总结。

## “错误”的 gm-Id 方法

将固定 width, 扫描 length 所得的 $\frac{g_m}{I_D}\ \mathrm{vs.} \frac{I_D}{W}$ 曲线作为关键图像。

## “正确”的 gm-Id 方法

事实上， gm-Id 方法也有很多种设计流程，它们的计算流程稍有不同，但大体的思路是相同的，都是用 $\frac{g_m}{I_D}$ 替代 $V_{OV}$，作为设计变量之一。例如，计算 folded-cascode stage 的 PMOS 输入管时， 一种可行的方法是将 $\frac{g_m}{I_D}$, $\frac{W}{L}$ 和 $L$ 作为设计变量（三个独立的自由变量即可完全确定晶体管的尺寸）。具体方法和设计示例见文章 [An Introduction to gm-Id Methodology](<Electronics/An Introduction to gm-Id Methodology.md>)，我们这里不多赘述。

## F-OTA 设计总结

## Folded-Cascode 设计总结

