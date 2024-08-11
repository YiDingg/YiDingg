# Mathematical Modeling (1.3): CUMCM 2023-B

## 概览

- 主题：多波束测深
- 重点：
- 时间：2024年8月（集训）
- 赛题：
  - [CUMCM 2023-B 赛题.pdf](https://www.writebug.com/static/uploads/2024/8/9/4693a624a6cea21bcf2a071afa57d43a.pdf)
  - [CUMCM 2023-B 赛题附件.xlsx](https://www.writebug.com/static/uploads/2024/8/9/4b2680c148c0fa58fc4dde784cc46555.xlsx)
- 优秀论文：
  - [CUMCM 2023-B 优秀论文 B226.pdf](https://www.writebug.com/static/uploads/2024/8/9/220dd99474853db8c327a481ed31bf4a.pdf)
  - [CUMCM 2023-B 优秀论文 B311.pdf](https://www.writebug.com/static/uploads/2024/8/9/fb15a9a26d41b7eaa0811c5743b96623.pdf)
  - [CUMCM 2023-B 优秀论文 B477.pdf](https://www.writebug.com/static/uploads/2024/8/9/d3f32b081197d7a84470b5d36504a560.pdf)

## 问题一 


## 问题二


问题二的建模我们提出了两种思路，第一种为椭圆，第二种为两仰角，两种方法都能得到相同的正确结果。

### 思路一：椭圆

如图，随着 $\beta$ 的变化，覆盖宽度的两端点不断旋转，本质上是圆锥被斜平面所截，最终构成一个椭圆。$x$ 轴（横轴）上为短轴，短轴长见后文 公式，$y$ 轴上为长轴，长轴即为问题一的结果。

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-11-13-13-46_MM(1.3)-CUMCM2023B.jpg"/></div>



<!-- <div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-08-11-13-05-51_MM(1.3)-CUMCM2023B.jpg"/></div> -->

### 思路二：两个仰角