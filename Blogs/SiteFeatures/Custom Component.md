# Custom Component (自定义组件)

> [!Note|style:callout|label:Infor]
Initially published at 18:36 on 2024-06-19 in Beijing.


## From HTML and CSS

### Button

focus属性会影响其它组件，因此注释掉了动画，可作静态按钮使用

<div class='button_1' onclick="window.open('')">this is a button 按钮</div>

<a class='button_1' onclick="window.open('')">this is a button 按钮</a>

<p class='button_1' onclick="window.open('')">this is a button 按钮</p>

可通过onclick属性设置点击跳转/新开链接。

<div class="button_2" data-tooltip="Size: 20Mb">
<div class="button_2-wrapper">
  <div class="text">Click to View or Download</div>
    <span class="icon">
      <svg xmlns="http://www.w3.org/2000/svg" aria-hidden="true" role="img" width="2em" height="2em" preserveAspectRatio="xMidYMid meet" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15V3m0 12l-4-4m4 4l4-4M2 17l.621 2.485A2 2 0 0 0 4.561 21h14.878a2 2 0 0 0 1.94-1.515L22 17"></path></svg>
    </span>
  </div>
</div>

<br>
<div class='button_3'>
<span>PLAY NOW</span>
</div>
<br>

<button type="button_4" class="button_4" >
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width="16"
    height="16"
    fill="currentColor"
    class="bi bi-arrow-repeat"
    viewBox="0 0 16 16"
  >
    <path
      d="M11.534 7h3.932a.25.25 0 0 1 .192.41l-1.966 2.36a.25.25 0 0 1-.384 0l-1.966-2.36a.25.25 0 0 1 .192-.41zm-11 2h3.932a.25.25 0 0 0 .192-.41L2.692 6.23a.25.25 0 0 0-.384 0L.342 8.59A.25.25 0 0 0 .534 9z"
    ></path>
    <path
      fill-rule="evenodd"
      d="M8 3c-1.552 0-2.94.707-3.857 1.818a.5.5 0 1 1-.771-.636A6.002 6.002 0 0 1 13.917 7H12.9A5.002 5.002 0 0 0 8 3zM3.1 9a5.002 5.002 0 0 0 8.757 2.182.5.5 0 1 1 .771.636A6.002 6.002 0 0 1 2.083 9H3.1z"
    ></path>
  </svg>
  Refresh
</button>

### Input Container 

<div class="input__container">
  <div class="shadow__input"></div>
  <button class="input__button__shadow">
    <svg fill="none" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" height="20px" width="20px">
      <path d="M4 9a5 5 0 1110 0A5 5 0 014 9zm5-7a7 7 0 104.2 12.6.999.999 0 00.093.107l3 3a1 1 0 001.414-1.414l-3-3a.999.999 0 00-.107-.093A7 7 0 009 2z" fill-rule="evenodd" fill="#17202A"></path>
    </svg>
  </button>
  <input type="text" name="text" class="input__search" placeholder="What do you want to search?">
</div>

### Loading

<div class="wrapper">
    <div class="circle-load"></div>
    <div class="circle-load"></div>
    <div class="circle-load"></div>
    <div class="shadow"></div>
    <div class="shadow"></div>
    <div class="shadow"></div>
</div>
<br><br>
<div class="spinner"></div>

## From Plugins

## More Plugins


<div class='center'> 

| Plugin | Note | <div style='width:150px'>Demo</div> |
| :-----: | :---------: | :---------: |
 |[Emact](https://emaction.cool/) | GitHub styled emoji reaction |<img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/CustomComponent-2024-06-21-12-53-54.png"/>|
 | [Counter](https://counterscale.dev/) | Web tracker and dashBoard |  <img src="https://imagebank-0.oss-cn-beijing.aliyuncs.com/VS-PicGo/CustomComponent-2024-06-21-12-52-52.png"/>  |
|  |  |  |

</div>



## Reference

[《有趣儿的组件（HTML/CSS）》](https://blog.csdn.net/qq_47945825/article/details/136108998)  
[《前端常用的CSS代码块》](https://blog.csdn.net/weixin_46102749/article/details/106947535)  
[《不需要 JavaScript，仅用 CSS 实现时间轴动画效果》](https://blog.csdn.net/Shids_/article/details/123792840)  
[《css 时间轴样式》](https://blog.csdn.net/q1ngqingsky/article/details/125526154)  