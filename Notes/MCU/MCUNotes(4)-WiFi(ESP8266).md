# MCU Notes (4): WiFi (ESP8266)

> [!Note|style:callout|label:Infor]
Initially published at 16:49 on 2024-06-28 in Beijing.


## Intro

ESP8266 是乐鑫设计的一款 WiFi 芯片，底层代码不开源，提供 SDK 一体化开发环境。乐鑫是芯片原厂，研制 ESP 系列芯片，提供 ESP-IDF 操作系统以及各种框架，以及国内外常用的云平台对接方案。安信可是乐鑫的主要客户之一，负责生产基于ESP系列芯片的模组，开发者到手就能开发，所以一般到我们手里的 ESP 系列模组都是安信可科技的。（否则只有一片干巴巴的 ESP8266 芯片，你还得设计外围电路才能使用它）

ESP-12F 就是其中一款使用 ESP8266 设计的模组。除此之外还有 ESP-01S、ESP-12E 和 ESP-12S，ESP-01S 是 1M flash。下面是它们的对比图：
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-14-17-11-31_MCUSeries(4)-WiFi(ESP8266).jpg"/></div>


## Prepare

### Resources

由上面的叙述，我们直接到安信可官方地址 [here](https://www.ai-thinker.com/home) 寻找资料即可，下面是一些可能用到的资料：

- [ESP8266 文档中心](https://docs.ai-thinker.com/esp8266/docs)
- [ESP8266 开发工具清单](https://docs.ai-thinker.com/%E5%BC%80%E5%8F%91%E5%B7%A5%E5%85%B72)
- [ESP8266 系列入门教程](https://docs.ai-thinker.com/_media/esp8266/docs/esp8266_start_guide_1_.pdf)
- [ESP-01/07/12 系列模组用户手册](https://docs.ai-thinker.com/_media/esp8266/docs/esp8266_series_modules_user_manual_zh_v1.5.pdf)
<!-- - [ESP8266 系列常见问题](https://s.b1n.net/kifow) -->
- [ESP8266 系列常见问题](https://docs.ai-thinker.com/_media/esp8266/espressif_faq_cn.pdf)
- [ESP8266 技术参考](https://docs.ai-thinker.com/_media/esp8266/esp8266-technical_reference_cn.pdf)

### Developmenmt Environment

### Download 

ESP系列支持 UART 下载程序，使用CH340模块即可，下载软件为安信可提供的 ESPFlashDownloadTool，在[ESP8266 开发工具清单](https://docs.ai-thinker.com/%E5%BC%80%E5%8F%91%E5%B7%A5%E5%85%B72)可找到。

MCU 启动模式设置如下图。具体来讲，与运行模式仅有GPIO0电平不同，下载模式IO0被拉低，运行模式IO0被拉高。
<div class="center"><img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/2024-07-14-17-19-14_MCUSeries(4)-WiFi(ESP8266).jpg"/></div>

## Usage

<div class='center'><img src='https://image.lceda.cn/oshwhub/ad9f88622cfa462b8958e7fc2ef3640d.png' alt='img'/></div>

## 