# Data Host

When building your own blog site, it is crucial to select an appropriate image host (image bank, image bed). Here are our suggestions and reasons.

<b>

Conclusion: 
- upload <font color='red'>img to SM.MS</font> by PicGo or VS-PicGo, <font color='red'>vedio to GitHub</font> manually, <font color='red'>pdf to WB</font>(backup to local). 
- Use [OplimizeLLA](https://imagecompressor.com)(70 quality recommanded) or [TinyPNG](https://tinypng.com/) to conpress the image if it is too big.
- Use [Screen to GIF]() to convert video into gif if you need, and upload it to 今日头条 by 盘络 if too big.
</b>

## Host Advice
 
<div class='center'>

|Type| Host | Note |
|:-:|:-:|:-:|
| image (png, jpg, gif, ...) | SM.MS | Free 5G, 100G for LifeTime Premium ($59.00) |
| vedio (mp4, asf, rm ...)  | GitHub | Maximum 800MB for each repo, manually upload  |
| pdf | WB(backup to local) | 2G for free |
</div>

We may change to use ... if :
- Github + PicGo: Picgo uploading is fixed
- Github + MDTC: The plugin to change url automatically is found


!> **Attention:**
We do not recommand GitHub as a host because it does not fit GitHub's original intention. GitHub will manually review your repo that reaches 1G, and your repo <font color='red'>(even account)</font> might be banned if they find that you are using the repo as an image host or data bank.

## Reasons

For image hosts, we have tested lots of image hosts or platforms where you can upload pictures, including 腾讯云, 阿里云, GitHub, Gitee, MJJ.TODAY, 路过图床, 简单图床. Here are the details:

<div class='center'>

|Host| Property | Note |
|:-:|:-:|:-:|
| GitHub | Free, automaltical, but not advised  | Maximum 800MB for each  |
| Gitee  | Banned completely | Gitee official had banned this completely|
| WB | Free (for 2G), but completely manual   | No plugins or extensions support this new code hoster |
| MJJ.TODAY | Free, but manual | 10MB maximum for each img |
|路过图床| Free, but manual | 10 images limited per hour, 100 per day |
|腾讯云| Charged, automaltical, fast  |  |
|阿里云|Charged, automaltical, fast|  |
|[简单图床](https://github.com/icret/EasyImages2.0)| Free, img + video + pdf  | support PicGo, a bit difficult to deploy|
|今日头条|Free, no storage limit (stability to be tested)| Supported by 盘络上传 |

</div>

<div class='center'>

|Tools| Property | Note |
|:-:|:-:|:-:|
|[MDTC](http://tc.yangln.cn/help/index.html)|||
|[PicGo](https://github.com/Molunerfinn/PicGo)|  ||
|VS-PicGo|  ||
|盘络上传|  | |
|Hellohao|Free or 198￥, manually| practical and various functions, such as automatic compression |
</div>

## Test

Here are the test results of image hosts.

<div class='center'>

|Host|img|gif|mp4|note|mobile|PC|PC(accelerated)|
|:-:|:-:|:-:|:-:|:---:|:---:|:---:|:---:|
|GitHub(gcore)|V|V|V|perhaps slowly/not accessible|img+gif+mp4<br>(accelerated domain required)|img+gif+mp4<br>(accelerated domain required)|img+gif+mp4<br>(accelerated domain required)|
|Gitee|-|-|-|banned|-|-|-|
|SM.MS|V|V|-|MDTC: provide null url when uploaded before<br>PicGo: previous url when uploaded before|img+gif|img+gif|img+gif|
|MJJ图床|V|V|-|manual|img+gif|img+gif|img+gif|
|路过图床|V|-|-|manual|img|img|img|
|阿里云|V|V|V|charged|img+gif+mp4|img+gif+mp4|img+gif+mp4|
|腾讯云|V|V|V|charged|img+gif+mp4|img+gif+mp4|img+gif+mp4|
|今日头条|V|V|X|no limit|img+gif|img+gif|img+gif|

</div>

### 今日头条 Test

<img src="https://p3-feedback-sign.byteimg.com/tos-cn-i-0000c0797/302b8dbabc7143a2aa0110f7f00d7e5d~tplv-nztq419xn5-image.image?rk3s=336f70e4&x-expires=1718884811&x-signature=EC7tjyMNzHdnoS9bziwIDH5zNo0%3D" alt="toutiaoBed-normal" title="toutiaoBed-normal" style='width:100px'>

<img src="https://p3-feedback-sign.byteimg.com/tos-cn-i-0000c0797/c029642d085a4bd589287cdd1a1cd6c0~tplv-nztq419xn5-image.image?rk3s=336f70e4&x-expires=1718884927&x-signature=QjeOI6DSIuKRv%2BIXpif7N8iTnSw%3D" alt="toutiaoBed-normal" title="toutiaoBed-normal" style='width:100px'>

### GitHub Test

<div class='center'>

|域名<div width=10px></div>|图片|gif|mp4|
|:-:|:-:|:-:|:-:|
|gcore.jsdelivr.net|<img src="https://gcore.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406171018025.jpg" style="width:20px"/>|<img src="https://gcore.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406171019604.gif" style="width:20px"/>|<video controls="false"  muted="muted" id="video1" name="media" style="width:200px"><source src="https://gcore.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406170046093.mp4" type="video/mp4"></video>|
|cdn.jsdelivr.net|<img src="https://cdn.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406171018025.jpg" style="width:20px"/>|<img src="https://cdn.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406171019604.gif" style="width:20px"/>|<video controls="false"  muted="muted" id="video1" name="media" style="width:200px"><source src="https://cdn.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406170046093.mp4" type="video/mp4"></video>|6|
|fastly.jsdelivr.net|<img src="https://fastly.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406171018025.jpg" style="width:20px"/>|<img src="https://fastly.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406171019604.gif" style="width:20px"/>|<video controls="false"  muted="muted" id="video1" name="media" style="width:200px"><source src="https://fastly.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406170046093.mp4" type="video/mp4"></video>|
|testingcf.jsdelivr.net|<img src="https://testingcf.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406171018025.jpg" style="width:20px"/>|<img src="https://testingcf.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406171019604.gif" style="width:20px"/>|<video controls="false"  muted="muted" id="video1" name="media" style="width:200px"><source src="https://testingcf.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406170046093.mp4" type="video/mp4"></video>|
|code.webcache.cn|<img src="https://code.webcache.cn/gh/YiDingg/VideoBank_0@latest/PicGo/202406171018025.jpg" style="width:20px"/>|<img src="https://code-dev.webcache.cn/gh/YiDingg/VideoBank_0@main/PicGo/202406171019604.gif" style="width:20px"/>|<video controls="false"  muted="muted" id="video1" name="media" style="width:200px"><source src="https://code-dev.webcache.cn/gh/YiDingg/VideoBank_0/PicGo/202406170046093.mp4" type="video/mp4"></video>|
|cdn.staticaly.com|<img src="https://cdn.staticaly.com/gh/YiDingg/VideoBank_0@main/PicGo/202406171018025.jpg" style="width:20px"/>|<img src="https://cdn.staticaly.com/gh/YiDingg/VideoBank_0@main/PicGo/202406171019604.gif" style="width:20px"/>|<video controls="false"  muted="muted" id="video1" name="media" style="width:200px"><source src="https://cdn.staticaly.com/gh/YiDingg/VideoBank_0@main/PicGo/202406170046093.mp4" type="video/mp4"></video>|
|unpkg.com(仅限npm包)||||
</div>

### PDF Test

<!--无边框-->
<div class='center'><table><tr>
<th>本网站<br>use'/'</th><th>WB</th><th>gcore</th><th>cdn</th><th>testingcf</th>
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