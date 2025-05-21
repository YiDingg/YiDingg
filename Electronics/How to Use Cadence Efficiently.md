# How to Use Cadence Efficiently

> [!Note|style:callout|label:Infor]
> Initially published at 17:05 on 2025-05-20 in Beijing.

## Install Cadence IC618

详见文章 [How to Install Cadence IC618](<Electronics/How to Install Cadence IC618.md>).


## Tips and Tricks

### Recommended Settings

- 修改字体、字号：`初始窗口 > Options > Fonts`
- 修改快捷键：`初始窗口 > Options > Bindkeys`, 关于 `Bindkeys`, 我们有以下建议：



<div class='center'>

| 快捷键 | 默认设置及其效果 | 修改建议与修改后的效果 |
|:-:|:-:|:-:|
 | `None<Btn4Down>` 鼠标滚轮上滑 (食指上滑) | `hiZoomInAtMouse` 放大界面 | `geScroll(nil "n" nil)`  界面上移 |
 | `None<Btn5Down>` 鼠标滚轮下滑 (食指下滑) | `hiZoomOutAtMouse` 缩小界面 | `geScroll(nil "s" nil)` 界面下移 |
 | `Ctrl<Btn4Down>` Ctrl + 鼠标滚轮上滑 (食指上滑) | `geScroll(nil "n" nil)` 界面上移 | `hiZoomInAtMouse` 放大界面 |
 | `Ctrl<Btn5Down>` Ctrl + 鼠标滚轮下滑 (食指下滑) | `geScroll(nil "s" nil)` 界面下移 | `hiZoomOutAtMouse` 缩小界面 |
 |  键盘 U | <> |
 |  键盘 Shift + U | <> |
</div>

- 将仿真背景从默认黑色修改为白色：`初始界面 > Options > Cdsenv Editor > viva > graphFrame`, 然后把 `viva.graphFrame` 的 `background` 改为 `white` 即可 (默认是 `black`)；修改后记得保存，否则下次再用时又变回默认值了
- 


### Simulation Tips

## Simulation Example

- [Simulate CMOS Inverter in Cadence IC618 (Virtuoso)](<Electronics/Simulate CMOS Inverter in Cadence IC618 (Virtuoso).md>)
- [Simulate ...... in Cadence IC618 (Virtuoso)]()



