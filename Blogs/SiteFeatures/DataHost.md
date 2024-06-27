# Data Host

When building your own blog site, it is crucial to select an appropriate image host (image bank, image bed) or data host. Here are our suggestions and reasons.

<b>

Conclusion: 
- <span style="color:red">img and small gif to Aliyun</span> by VS-PicGo
-  <!-- <s>gif to TouTiao manually by PanLuo Uploading,</s> --> <span style="color:red">gif, video, audio, pdf and other files to WB Cloud</span> manually.

Tools:
- Use<!--  [C1N](https://www.c1n.cn/) or --> [Short](https://d.igdu.xyz/) or [C1N](https://www.c1n.cn/) to create a short link for your file.
- Use [SINA](https://www.sina.lt/restore.html) to restore the short link.
- Use [Oplimize LLA](https://imagecompressor.com)(70 quality recommanded) or [TinyPNG](https://tinypng.com/) to compress the image and gif.
- Use [Video To Edit](https://www.video2edit.com) to compress the video.
- Use [YouCompress](https://www.youcompress.com/) to compress mp3.
- Use [I Love PDF](https://www.ilovepdf.com/) to compress pdf.
- Use [Screen to GIF]() to convert video into gif if you need.

</b>

Results Show:

<div class='center'>

|Type|display|
|:-:|:-:|
 |img|<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/_coverpage-2024-06-20.jpeg" alt="_coverpage-2024-06-20" style="width:200px">|
 |gif|<img src="https://d.igdu.xyz/ZoIG" alt="toutiaoBed-normal" title="toutiaoBed-normal" style="width:200px">|
 |video|<video controls="false"  muted="muted" id="video1" name="media" style="width:200px"><source src="https://www.writebug.com/git/DY130810/WB.VideoBank/raw/branch/main/video.mp4" type="video/mp4"></video>|
 |pdf|below|

</div>

```pdf
https://www.writebug.com/git/DY130810/Notes/raw/commit/77732e15298f9d2390549ae3a26fd23e5e795d6f/Linear%20Algebra%202/notes/Linear%20Algebra%202%20notes.pdf
```


## Host Advice
 
<div class='center'>

|Type| Host | Note |
|:-:|:-:|:-:|
| image(png, jpg, ...), small gif | GitHub, SM.MS for free<br>Aliyun, Tencent Cloud for premium | you can choose to pay for stability |
| gif, video(mp4, avi, webm, ...), audio  | GitHub, WB | GitHub: Maximum 800MB for each repo, manually upload  |
| pdf | GitHub, WB | |
</div>

We may change to use ... if :
- Github + PicGo: Picgo uploading is fixed
- Github + MDTC: The plugin to change url automatically is found


!> **<span style='color:red'>Attention:</span>**<br>
Though you can use GitHub's repo for free, we do not recommand GitHub as a host because it does not fit GitHub's original intention. GitHub will manually review your repo that reaches 1G, and your repo <font color='red'>(even account)</font> might be banned if they find that you are using the repo as an image host or data bank.

## Reasons

For image hosts, we have tested lots of image hosts or platforms where you can upload pictures, including Tencent Cloud(腾讯云), Aliyun(阿里云), GitHub, Gitee, MJJ.TODAY, ImgSE(路过图床), Easy Image(简单图床), etc. Here is part of the results:

<div class='center'>

|Host| Property | Note |
|:-:|:-:|:-:|
| GitHub | Free, automaltical, but not advised  | Maximum 800MB for each  |
| Gitee  | Banned completely | Gitee official had banned this completely|
| WB | Free (for 2G), but completely manual   | No plugins or extensions support this new code hoster |
| MJJ.TODAY | Free, but manual and not stable enough | 10MB maximum for each img |
|ImgSE(路过图床)| Free, but manual | 10 images limited per hour, 100 per day |
|Tencent Cloud(腾讯云)| Charged, automaltical, fast  |  |
|Aliyun(阿里云)|Charged, automaltical, fast| on sale these days |
|Easy Image (简单图床)| Free, img + video + pdf  | support PicGo, a bit difficult to deploy|
|Tou Tiao (今日头条)|Free, no storage limit (stability to be tested)| Supported by PanLuo(盘络上传) |

</div>

<div class='center'>

|Tools| Property | Note |
|:-:|:-:|:-:|
|[MDTC](http://tc.yangln.cn/help/index.html)|Free<br> automatically upload||
|[PicGo](https://github.com/Molunerfinn/PicGo)| Free<br> automatically upload ||
|VS-PicGo| Free<br> upload by shortcut key <br>automatically rename to local path | |
|PanLuo(盘络上传)| Free<br> upload by dropping| |
|Hellohao|Free or ¥198, manually| practical and various functions, such as automatic compression |
</div>

Go to [GitHub Test](Blogs\SiteFeatures\DataHost?id=github-test) and [Free Image Host Test](Blogs\SiteFeatures\DataHost?id=free-image-host-test) for details.

## Contrast

Here are the comparison of Aliyun OSS (Object Storage Service) and  Tencent Cloud COS(Cloud Object Storage) :

<div class='center'>

|Type| Aliyun OSS |Tencent Cloud|
|:-:|:-:|:-:|
| Shortage(1GB * 1month) | St: ¥0.12<br>IA: ¥0.08 | St: ¥0.118<br>IA: ¥0.08 |
| Outbound traffic over the Internet(1GB) |¥0.25(0:00-8:00)<br>0.50(8:00-24:00) | ¥0.5 |
| Plan of minimum shortage capacity   | St:40GB(¥4.98 for 6 months, on discount)(0-5GB free)<br>IA:100GB(¥35.86 for 6 months) |  St:10GB(¥4.96 for 6 months)(no free)<br>IA:10GB(¥3.36 for 6 months) |
| Plan of minimum outbound traffic  | 100GB(¥244.02 for 6 months)  | 10GB(¥21.00 for 6 months) |
| API Operation Calling | 0~20,000,000 for free(standard) | ¥0.01 per 10,000 |
</div>

## Test

Here are the test results of image hosts.

<div class='center'>

|Host|img|gif|mp4|note|mobile|PC|PC(accelerated)|
|:-:|:-:|:-:|:-:|:---:|:---:|:---:|:---:|
|GitHub(gcore)|V|V|V|perhaps slowly/not accessible|img+gif+mp4<br>(accelerated domain required)|img+gif+mp4<br>(accelerated domain required)|img+gif+mp4<br>(accelerated domain required)|
|Gitee|-|-|-|banned|-|-|-|
|SM.MS|V|V|-|MDTC: provide null url when uploaded before<br>PicGo: previous url when uploaded before|img+gif|img+gif|img+gif|
|MJJ.TODAY|V|V|-|manual|img+gif|img+gif|img+gif|
|ImgSE|V|-|-|manual|img|img|img|
|Aliyun|V|V|V|charged|img+gif+mp4|img+gif+mp4|img+gif+mp4|
|Tencent Cloud|V|V|V|charged|img+gif+mp4|img+gif+mp4|img+gif+mp4|
|Tou Tiao|V|V|X|no limit|img+gif|img+gif|img+gif|

</div>

### TouTiao Test

<div class='center'>

|img|gif|
|:-:|:-:|
 |<img src="https://p26-feedback-sign.byteimg.com/tos-cn-i-0000c0797/b1dbbb1325064dd2a438c3d6215b5513~tplv-nztq419xn5-image.image?rk3s=336f70e4&x-expires=1718909496&x-signature=69OL3QJ6WRsQRvK5VbwqbzYoDms%3D" alt="toutiaoBed-normal" title="toutiaoBed-normal" style='width:100px'>|<img src="https://p3-feedback-sign.byteimg.com/tos-cn-i-0000c0797/c029642d085a4bd589287cdd1a1cd6c0~tplv-nztq419xn5-image.image?rk3s=336f70e4&x-expires=1718884927&x-signature=QjeOI6DSIuKRv%2BIXpif7N8iTnSw%3D" alt="toutiaoBed-normal" title="toutiaoBed-normal" style='width:100px'>|
 |<img src="https://p6-feedback-sign.byteimg.com/tos-cn-i-0000c0797/8d8ad1343860402e8250f731c7d67f5d~tplv-nztq419xn5-image.image?rk3s=336f70e4&x-expires=1718909523&x-signature=9TJe24d7zx3eeguccax6gT5fxTM%3D" alt="toutiaoBed-normal" title="toutiaoBed-normal" style='width:100px'>|<img src="https://p3-feedback-sign.byteimg.com/tos-cn-i-0000c0797/302b8dbabc7143a2aa0110f7f00d7e5d~tplv-nztq419xn5-image.image?rk3s=336f70e4&x-expires=1718884811&x-signature=EC7tjyMNzHdnoS9bziwIDH5zNo0%3D" alt="toutiaoBed-normal" title="toutiaoBed-normal" style='width:100px'>|

</div>


### GitHub Test

<div class='center'>

|domain|img|gif|mp4|
|:-:|:-:|:-:|:-:|
 |gcore.jsdelivr.net|<img src="https://gcore.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406171018025.jpg" style="width:40px"/>|<img src="https://gcore.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406171019604.gif" style="width:40px"/>|<video controls="false"  muted="muted" id="video1" name="media" style="width:200px"><source src="https://gcore.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406170046093.mp4" type="video/mp4"></video>|
 |cdn.jsdelivr.net|<img src="https://cdn.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406171018025.jpg" style="width:40px"/>|<img src="https://cdn.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406171019604.gif" style="width:40px"/>|<video controls="false"  muted="muted" id="video1" name="media" style="width:200px"><source src="https://cdn.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406170046093.mp4" type="video/mp4"></video>|6|
 |fastly.jsdelivr.net|<img src="https://fastly.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406171018025.jpg" style="width:40px"/>|<img src="https://fastly.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406171019604.gif" style="width:40px"/>|<video controls="false"  muted="muted" id="video1" name="media" style="width:200px"><source src="https://fastly.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406170046093.mp4" type="video/mp4"></video>|
 |testingcf.jsdelivr.net|<img src="https://testingcf.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406171018025.jpg" style="width:40px"/>|<img src="https://testingcf.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406171019604.gif" style="width:40px"/>|<video controls="false"  muted="muted" id="video1" name="media" style="width:200px"><source src="https://testingcf.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406170046093.mp4" type="video/mp4"></video>|
 |code.webcache.cn|<img src="https://code.webcache.cn/gh/YiDingg/VideoBank_0@latest/PicGo/202406171018025.jpg" style="width:40px"/>|<img src="https://code-dev.webcache.cn/gh/YiDingg/VideoBank_0@main/PicGo/202406171019604.gif" style="width:40px"/>|<video controls="false"  muted="muted" id="video1" name="media" style="width:200px"><source src="https://code-dev.webcache.cn/gh/YiDingg/VideoBank_0/PicGo/202406170046093.mp4" type="video/mp4"></video>|
 |cdn.staticaly.com|<img src="https://cdn.staticaly.com/gh/YiDingg/VideoBank_0@main/PicGo/202406171018025.jpg" style="width:40px"/>|<img src="https://cdn.staticaly.com/gh/YiDingg/VideoBank_0@main/PicGo/202406171019604.gif" style="width:40px"/>|<video controls="false"  muted="muted" id="video1" name="media" style="width:200px"><source src="https://cdn.staticaly.com/gh/YiDingg/VideoBank_0@main/PicGo/202406170046093.mp4" type="video/mp4"></video>|
 |unpkg.com(仅限npm包)||||
</div>


### Free Image Host Test


<div class='center'>

|Host|note|img|gif|mp4|
|:-:|:-:|:-:|:-:|:-:|
 |[131213](https://img.131213.xyz/) | 5 MB maximum for each file<br>no space limit<br>no log in | <img src="https://img1.131213.xyz/file/676369b7e97e5d8f9aa58.jpg" style="width:40px"/> | <img src="https://img1.131213.xyz/file/ac37606e27b921f10486b.gif" style="width:60px"/> |<video controls="false"  muted="muted" id="video1" name="media" style="width:150px"><source src="https://img1.131213.xyz/file/8b327e6fbd8745e3685b8.mp4" type="video/mp4"></video>|
 | [Ming](https://images.mingming.dev/) |5 MB maximum for each file<br>no space limit<br>no log in| <img src="https://images.mingming.dev/file/214a340799a67002b8474.jpg" style="width:40px"/>   | <img src="https://images.mingming.dev/file/ea0685ad77470045728e3.gif" style="width:60px"/> | <video controls="false"  muted="muted" id="video1" name="media" style="width:150px"><source src="https://images.mingming.dev/file/636eaee3fbf10a724f1ed.mp4" type="video/mp4"></video> |
 | [PicoS](https://demo.pico.rocks/)| unlimited<br>need deployment  | <img src="https://demo.pico.rocks/-WWJRZxQsrH" style="width:40px"/> | <img src="https://demo.pico.rocks/-b9PyXd4iF5" style="width:60px"/> |<video controls="false"  muted="muted" id="video1" name="media" style="width:150px"><source src="https://demo.pico.rocks/-H5VXiB8Jhm" type="video/mp4"></video>||
 | [SuBed](https://www.superbed.cn/)| Free or Premium  | <img src="https://pic.imgdb.cn/item/66751485d9c307b7e9839790.jpg" style="width:40px"/> | <img src="https://pic.imgdb.cn/item/6675148dd9c307b7e983a381.gif" style="width:60px"/> |-|
 | [ImgURL](https://imgurl.org)| Free or Premium<br>5 MB limited | <img src="https://s3.bmp.ovh/imgs/2024/06/21/1e1162a4c840792d.jpg" style="width:40px"/> | <img src="https://s3.bmp.ovh/imgs/2024/06/21/0773b23f4b6f2575.gif" style="width:60px"/> |-|
 | [SM.MS](https://smms.app/)<br> started at 2014| Free or Premium<br>5 MB limited<br>a bit slow for free | <img src="https://s2.loli.net/2024/06/21/stFCLwufBjDaAEU.jpg" style="width:40px"/> | <img src="https://s2.loli.net/2024/06/21/jRptZe3bck2uLoi.gif" style="width:60px"/> |-|
 | [ImgSE](https://imgse.com/)<br> started at 2011| Free or Premium<br>10 MB limited<br>a bit slow for free | <img src="https://s21.ax1x.com/2024/06/21/pkDwiUf.jpg" style="width:40px"/> |-|-|
 | [MJJ](https://mjj.today/)<br> started at 2022| 10 MB limited<br> not stable enough| <img src="https://i3.mjj.rip/2024/06/21/70bcd8ac81e0749d588b9d6b57836296.jpeg" style="width:40px"/> |<img src="https://i3.mjj.rip/2024/06/21/8daf83afdd7fdc2a7b9459d9b632c5b8.gif" style="width:60px"/>|-|
 | [Post](https://postimg.cc/)| Free or Premium<br>12 MB limited |<img src="https://i.postimg.cc/kg033yyS/image.jpg" style="width:60px"/>| <img src="https://i.postimg.cc/qvhV5F20/charlie.gif" style="width:40px"/>|-|
 | [JiKe](https://jiketuchuang.com/)| Free <br>unlimited file size  |<img src="https://pic7.58cdn.com.cn/nowater/webim/big/n_v290745a54ae754db6be3e5d9c00d6b5f4.jpg" style="width:60px"/>| 16MB img<br><img src="https://pic4.58cdn.com.cn/nowater/webim/big/n_v2a46e87345cd54f58a37b5ec4d7599188.jpg" style="width:40px"/>|-|
 | [Ink](https://img.ink/)| Free <br>12 MB limited  |<img src="https://pic2.ziyuan.wang/user/1308102491/2024/06/头像_67607bebe8207.jpg" style="width:60px"/>|<img src="https://pic2.ziyuan.wang/user/1308102491/2024/06/charlie_037b88453cdf8.gif" style="width:40px"/>|-|
 | [Zeruns](https://tc.zeruns.tech/)| Free <br>15 MB limited  |<img src="https://tc2.zeruns.tech/2024/06/21/d8547cc26a8e892ba0f2f42a43512392.jpeg" style="width:60px"/>|<img src="https://tc2.zeruns.tech/2024/06/21/test.gif" style="width:40px"/>|-|

</div>

### PDF Test

<!--无边框-->
<div class='center'><table><tr>
<th>local site<br>(use'/')</th><th>WB</th><th>gcore</th><th>cdn</th><th>testingcf</th>
<tr><td><div class='pdftest'>

```pdf
pdf/GitHub_YiDingg_pdf/Linear%20Algebra%202%20notes.pdf
```
</div></td>

<td><div class='pdftest'>

```pdf
https://www.writebug.com/git/DY130810/GitHub_YiDingg_pdf/raw/branch/main/Linear%20Algebra%202%20notes.pdf
```
</div></td>

<td><div class='pdftest'>

```pdf
https:https://gcore.jsdelivr.net/gh/YiDingg/YiDingg/pdf/GitHub_YiDingg_pdf/Linear%20Algebra%202%20notes.pdf
```
</div></td>

<td><div class='pdftest'>

```pdf
https:https://cdn.jsdelivr.net/gh/YiDingg/YiDingg/pdf/GitHub_YiDingg_pdf/Linear%20Algebra%202%20notes.pdf
```
</div></td>

<td><div class='pdftest'>

```pdf
https:https://testingcf.jsdelivr.net/gh/YiDingg/YiDingg/pdf/GitHub_YiDingg_pdf/Linear%20Algebra%202%20notes.pdf
```
</div></td>
</tr></table></div>



<style>
 .pdftest{
    width: 50px;
    height: 200px;
    border: #000 solid 
}
</style>