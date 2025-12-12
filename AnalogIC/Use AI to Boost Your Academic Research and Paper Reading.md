# Use AI to Boost Your Academic Research and Paper Reading

> [!Note|style:callout|label:Infor]
> Initially published by YiDingg at 16:57 on 2025-12-08 in Beijing.


## Paper Summary and Analysis

prompt 如下：
``` bash
附件（五十篇）论文是我所在课题组近年来的主要论文产出，总结上面五十篇论文的关键词、主要内容、创新点和论文质量点评，用 list 和 table 呈现，例如下面这样：

list: 
- [1] year + paper name
    - keywords 
    - content (one sentence)
    - quality of the paper (one sentence)
- [2] year + paper name
    - keywords 
    - content (one sentence)
    - quality of the paper (one sentence)

具体例子：
- [1] (2025) A Fast Auto-Frequency Calibration Technique for Wideband PLL with Wide Reference Frequency Range
    - keywords: Frequency Calibration, Wideband PLL, Wide Reference Frequency Range
    - ……
    - ……


给出 list 后，再给一个 table 汇总
```


### 1. DeepSeek (2025.12.08)

最多能上传共 50 个附件 (一次性最多上传 20 个，然后要等一会儿)，大致能满足需求，但是字数仍有限制，我们的测试中仅能阅读全部论文的 15% 字数：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-08-16-40-48_Use AI to Boost Your Academic Research and Paper Reading.png"/></div>

### 2. Kimi (2025.12.08)

能一次性上传完 50 个附件，但单个对话最多只能有 20 万字 (包括附件)，所以还是不行：

<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2025-12-08-16-43-46_Use AI to Boost Your Academic Research and Paper Reading.png"/></div>

### 3. 

``` bash
附件（五十篇）论文是我所在课题组近年来的主要论文产出，总结上面五十篇论文的关键词、主要内容、创新点和论文质量点评，用 list 和 table 呈现，例如下面这样：

list: 
- [1] year + paper name
    - keywords 
    - content (one sentence)
    - quality of the paper (one sentence)
- [2] year + paper name
    - keywords 
    - content (one sentence)
    - quality of the paper (one sentence)

具体例子：
- [1] (2023) A 60-Gb/s 1.2-pJ/bit 1/4-Rate PAM-4 Receiver With a Jitter Compensation CDR
    - keywords: PAM4, Jitter Compensation, CDR, High-Speed Communication.
    - This work presents a 1/4-rate PAM-4 receiver that incorporates a jitter compensation CDR circuit, achieving 60 Gb/s data rate with high energy efficiency.
    - The paper demonstrates a leading-edge design with superior energy efficiency and jitter performance, as evidenced by its top-tier placement in a comparative table of state-of-the-art works.

给出 list 后，再给一个 table 汇总
```
