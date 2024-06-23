# Syntax Examples

## Basic Components

### Music

<div class='center'>
<audio id='Music-1' controls>
	<source src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Syntax Examples--2024-06-22-01-24-43.mp3" type="audio/mpeg">
	Your browser does not support the audio element.
</audio>
</div>

<iframe id='Music-2' frameborder="no" marginwidth="0" marginheight="0" width=280 height=52 src="//music.163.com/outchain/player?type=2&id=488249475&auto=0&height=32"></iframe>

<script>
myVid=document.getElementById("Music-1");
myVid.volume=0.15;
</script> 

```html
<audio id='Music-1' controls="controls" autoplay='ture'>
	<source src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/Syntax Examples--2024-06-22-01-24-43.mp3" type="audio/mpeg">
</audio>

<iframe id='Music-2' frameborder="no" marginwidth="0" marginheight="0" width=280 height=52 src="//music.163.com/outchain/player?type=2&id=488249475&auto=0&height=32"></iframe>

<script>
myVid=document.getElementById("Music-1");
myVid.volume=0.15;
</script> 
```

### Picture

<div class='center'>

|1|2|
|:-:|:-:|
|<img src='https://cdn.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406171018025.jpg' style="width:40px"/>|<img src="https://cdn.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406171018025.jpg" style='width:10%'/>|
</div>

```html
<!-- Recommanded: -->
 <div class='center'><img src="https://gcore.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406171018025.jpg" style="width:40px"/></div>

<!-- Other: -->
<img src="https://gcore.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406171018025.jpg" style='width:10%'/>
```
### GIF
 <div class='center'><img src="https://d.igdu.xyz/ZoIG" style="width:300px"/></div>

- Convert video to gif online: [convertio](https://convertio.co/zh/)
- Convert video to gif by app: [screentogif](https://www.screentogif.com/)

!> **<span style='color:red'>Attention:</span>**<br>
Converting video to gif with high quality might cause a size surge. 

<!-- ![image](https://cdn.jsdelivr.net/gh/YiDingg/ImageBank_0/main/20240616/171923032.gif) -->

### Video

<div class='center'><video controls="controls"  muted="muted" id="video-example" style="width:900px;max-width:80%" loop='0'><source src="https://d.igdu.xyz/qSTL" type="video/mp4"></video></div>


```html
<div class='center'>
	<video controls="controls"  muted="muted" id="video-example" style="width:900px;max-width:80%" loop='0'><source src="https://gcore.jsdelivr.net/gh/YiDingg/VideoBank_0/PicGo/202406170046093.mp4" type="video/mp4"></video>
</div>
```

### Button

<div class='center'>

| Self | Self | Blank(new window) |
|:-:|:-:|:-:|
 | <a href="https://www.writebug.com/git/DY130810/Notes/raw/commit/77732e15298f9d2390549ae3a26fd23e5e795d6f/Linear%20Algebra%202/notes/Linear%20Algebra%202%20notes.pdf"><button class="docsify-tabs__tab--active" data-tab="my tab">'a' and 'button'</button></a>  | <button onclick="window.location.href='pdf/GitHub_YiDingg_pdf/Linear%20Algebra%202%20notes.pdf'" type="button">'button' and 'window.location.href'</button>|<button onclick="window.open('pdf/GitHub_YiDingg_pdf/Linear%20Algebra%202%20notes.pdf')" type="button">'button' and 'window.open()'</button>|

 
</div>

### Font

<span style='color:red; font-style:italic; font-family:Arial; font-size:16px; font-weight:bold;'>Arial</span>
<span style="color:blue; font-family:华文彩云; font-style:italic; font-size:16px; font-weight:bold;">华文彩云</span>
<p style="color:purple; font-family:华文彩云; font-style:italic; font-size:16px; font-weight:bold;">华文彩云</p>


```html
<span style='color:red; font-style:italic; font-family:Arial; font-size:16px; font-weight:bold;'>Arial</span>
<span style="color:blue; font-family:华文彩云; font-style:italic; font-size:16px; font-weight:bold;">华文彩云</span>
<p style="color:purple; font-family:华文彩云; font-style:italic; font-size:16px; font-weight:bold;">华文彩云</p>
```


### Table


<div class='center'>
<span style="font-family:黑体; font-size:12px; color:black;">Table 1: Example</span>

| Example | Example | Example |
|:-:|:-:|:-:|
| Example  | Example  |  Example |
| Example  | Example  |  Example |
</div>



```html
<div class='center'>
<span style="font-family:黑体; font-size:12px; color:black;">Table 1: Example</span>

|  |  |  |
|:-:|:-:|:-:|
|   |   |   |
|   |   |   |
</div>
```


### Accordion

<details>
<summary>Self-assessment (Click to expand)</summary>

- Abc
- Abc

</details>

```html
<details>
<summary>Self-assessment (Click to expand)</summary>

- Abc
- Abc

</details>
```

### To do list

* [ ] hi
* [ ] hi
- [x] hi
- [x] hi

```html
* [ ] hi
* [ ] hi
- [x] hi
- [x] hi
```


