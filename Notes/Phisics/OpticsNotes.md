#  Optics <br> 光学

> [!Note|style:callout|label:Infor]
Initially published by YiDingg at 11:48 on 2024-08-23 in Lincang.


## Notes 

!> **<span style='color:red'>Attention:</span>**<br>
You might not be able to view pdf online on the mobile devices as the broswer dosen't support the extension. Therefore, make sure you are using a mordern broswer on PC, such as Edge, Chrome, Quark, LianXiang, etc. You can also try clicking the link below to view or download
the file.

The raw source url: <button onclick="window.open('https://gcore.jsdelivr.net/gh/YiDingg/LatexNotes/[Notes]Optics/[Notes]Optics.pdf')" type="button">[Notes]Optics.pdf</button>

```pdf
https://gcore.jsdelivr.net/gh/YiDingg/LatexNotes/[Notes]Optics/[Notes]Optics.pdf
```

## Homework

The raw source url: <button onclick="window.open('https://gcore.jsdelivr.net/gh/YiDingg/LatexNotes/[Homework]Optics/[Homework]Optics.pdf')" type="button">[Homework]Optics.pdf</button>

```pdf
https://gcore.jsdelivr.net/gh/YiDingg/LatexNotes/[Homework]Optics/[Homework]Optics.pdf
```

## Intro


### 课程信息

- 教师：奚婷婷
- 考核方式：平时作业 30% + 期中考试 30% + 期末考试 40%。
- 分数限制：优秀率 $\leqslant 35\ \%$ ，不及格率 $\leqslant 15\  \%$

### “学长有话说”

- 奚老师的 PPT 主要参考的是“光学新概念物理教程 (赵凯华)”，内容顺序基本一致，因此建议看这本书（PPT 上的内容太过简略，不推荐）。并且，“光学新概念物理教程 (赵凯华)”这本书每章末位都会有章末总结，不想听课但考前要突击一下的同学可以仅看总结部分。其次是“光学（第五版）optics (尤金，Eugene Hecht)”，这本书内容更丰富一些，但是顺序有些出入，如果你对某些问题的原理感到好奇，想推导其原理，可参考此书。相关书籍的下载链接在文末 `Resources` 部分。
- 尽量不要缺勤，奚老师有时会在课上出题，现做现交，当作考勤分，有时也会在下课前点名
- 作业是每讲完一章（2 ~ 3 周），再过一周后收（可以提前交）


### Workflow
- 光路仿真
  - Web 在线端
    - [Optico](https://www.optico.app/en/start-en/)
    - [Ray Optics Simulation](https://phydemo.app/ray-optics/cn/)
  - Local 软件端
    - Thorlabs 器件文档 + Solidworks 中仿真
- 光学示意图
  - 方式一：Drawio in VSCode --> `svg`
  - 方式二：AxGlyph --> inkscape export --> `pdf`
  - 方式三：AxGlyph --> print --> [Crop PDF](https://www.i2pdf.com/crop-pdf) --> `pdf`
  - 方式四：AxGlyph --> export --> `svg`
  - 光学素材库
    - [svg 格式](https://www.gwoptics.org/ComponentLibrary/)
    - [png, ppt 格式](https://markelz.physics.buffalo.edu/node/411)
    - [Latex 库](https://ctan.org/pkg/pst-optexp)（比较折磨）
    - [2D, 3D 库](https://github.com/amv213/ComponentLibrary)
    - [在 inkscape 中进行光路仿真](https://github.com/damienBloch/inkscape-raytracing)
- 可视化：用 Matlab 求解可视化数据结果
- 其它：GeoGebra、[Mathcha](https://www.mathcha.io/editor) 

<div class='center'><img src='assets/draw.ioFiles/Optics_test.drawio.svg' alt='img'/>
<div class='caption'>Figure: 光学 svg 示意图示例</div></div>

``` html
<div class='center'><img src='assets/draw.ioFiles/Optics_test.drawio.svg' alt='img'/>
<div class='caption'>Figure: 光学 svg 示意图示例</div></div>
```


## Resources

### 相关书籍

Refer to [here (123 Cloud)](https://www.123865.com/s/0y0pTd-1GKj3) for all relevant resources. You can freely preview them online and download them. 

- 教材：
  - [Optics (Eugene Hecht).pdf](https://www.writebug.com/static/uploads/2024/9/2/3ed06af7e4f074f1964feb480a541a6b.pdf)
  - [光学新概念物理教程 (赵凯华).pdf](https://www.writebug.com/static/uploads/2024/9/2/4354c0a83b3b86c3c390cb816f649675.pdf)
  - [光学 PPT（奚婷婷）](https://www.123865.com/s/0y0pTd-4GKj3)
- 辅导书：
  - [光学原理：光的传播、干涉和衍射的电磁理论（马科斯·玻恩，埃米尔）(第7版).pdf](https://s.b1n.net/DABQD)
  - [物理光学（第五版） (梁铨廷).pdf](https://www.writebug.com/static/uploads/2024/9/2/501fb70a8ae70b6d7fa45c5c328e50e9.pdf)
  - Fundamentals of Photonics (Bahaa E. A. Saleh, Malvin Carl Teich): 包括几何光学（矩阵光学）、波动光学、光的电磁理论、波导光学、半导体光电器件、激光原理、最基础的统计光学，最基础的量子光学，最基础的非线性光学，超快光学等，最新已达 edition 3 (2019)
  - 光学（钱列加）(2024年8月第1版).pdf

<!--   - [光学 PPT（奚婷婷）](https://www.writebug.com/code/53666336-413e-11ef-afda-0242c0a84017/src/branch/main/%E5%85%89%E5%AD%A6%20PPT/#) -->

<!-- - 教材：
    - [光学 PPT（奚婷婷）](https://www.123865.com/s/0y0pTd-4GKj3)
    - [光学（第五版）optics (尤金，Eugene Hecht).pdf](https://www.123865.com/s/0y0pTd-xGKj3)
- 辅导书：
    - 光学原理：光的传播、干涉和衍射的电磁理论（马科斯·玻恩，埃米尔）(第7版).pdf
    - 光学新概念物理教程 新概念物理教程 (赵凯华).pdf
    - 物理光学（第五版） (梁铨廷).pdf
 -->

### 拓展阅读

- [光力类比：理论力学与光学的奇妙碰撞](https://zhuanlan.zhihu.com/p/666330436)
