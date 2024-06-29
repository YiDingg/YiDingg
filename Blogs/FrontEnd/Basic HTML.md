# Basic HTML

>[!TIP]<div>
here
- Awesome site for HTML+CSS+JS reference: https://www.w3schools.com/ (English)<br>
- Awesome site for HTML+CSS+JS reference: https://www.w3school.com.cn/ (中文)<br>
- Great site for learning web development: [https://developer.mozilla.org](https://developer.mozilla.org/en-US/docs/Learn) (English)<br>
- Great site for learning web development: [https://developer.mozilla.org](https://developer.mozilla.org/zh-CN/docs/Learn) (中文)<br>
- Edit and preview HTML+CSS+JS online: https://codepen.io/madzadev/pen/zYdOVPV
</div>


## Common Tags in HTML

### Tags in `<head>`

<!-- tabs:start -->
#### **`<script>`**

```html
<!--style: 定义内部样式表. 内部用来书写css代码-->
<style>
    h1 {
        color: greenyellow;
    }
</style>
<!--script: 内部用来书写js代码-->
<script>
    alert(123)
</script>
<!--script: 还可以引入外部js文件-->
<script src="myjs.js"></script>

```

#### **`<link>`**

```html
<!--link: 引入外部css文件 或 网站图标-->
<link rel="stylesheet" href="mycss.css">
```

#### **`<meta>`**

meta标签必须写在头部head标签之内，而description的meta标签务必要写在keywords的meta标签之后，像下面这样的顺序写：  
1.关键字：description要用简短的文字描述网站或网页的主要内容，有利于各大搜索引擎的抓取收录你的网站或网页。  
2.页面描述：当你设置了description网站描述文字，才会显示在搜索引擎的结果页中，而每个网页的description也是同样的道理，简短又准确的网页描述文字，可以帮助用户在搜索引擎中更方便的找到你的网站和网页！
```html
<!-- 指定文档的编码类型(需要知道) -->
<meta http-equiv="content-Type" charset="UTF8">
<!-- 2秒后跳转到对应的网址，注意引号(了解) -->
<meta http-equiv="refresh" content="2;URL=https://www.baidu.com">
<!-- 3秒后刷新 -->
<meta http-equiv="refresh" content="3">   
<!-- 告诉IE以最高级模式渲染文档(了解) -->
<meta http-equiv="x-ua-compatible" content="IE=edge">
<!--关键字：有助于搜索引擎SEO优化，再怎么优化也抵不过竞价排名-->
<meta name="keywords" content="meta总结,html meta,meta属性,meta跳转">
<!--页面描述-->
<meta name="description" content="给你骨质唱疏通">
```


<!-- tabs:end -->

### Tags in `<body>`
<!-- tabs:start -->

#### **基本标签(块级标签和内联标签)**

```html
<b>加粗</b>
<i>斜体</i>
<u>下划线</u>
<s>删除</s>
<p>段落标签</p>
<h1>标题1</h1>
<h2>标题2</h2>
<h3>标题3</h3>
<h4>标题4</h4>
<h5>标题5</h5>
<h6>标题6</h6>
<em>斜体</em>  
<strong>粗体</strong>  
<ins>下划线</ins>  
大于号：&gt;  
小于号：&lt;  
引号：&quot;  
注册商标：&reg;  
空格：&nbsp;
注释：<!--注释内容-->  
水平线：<hr/> or <hr>
换行标签：<br/> or <br>  
字体大小颜色：<font color="red" size="10px">我是菜鸟</font>
```

#### **`<image>`**
`src='{path}'`：`{path}`可以为相对路径、根路径'/'、同级路径'./'、上级路径'../'、绝对路径等<br>
`width=[wid]`：`[wid]`可以为10%(不推荐)、400px(像素，推荐)等  
`height=[hei]`：同理(width和height仅设置一个时自动等比缩放)  
`alt='[text]'`：图片加载错误时显示的内容
`title='[text]'`：鼠标悬停时显示的内容


<!-- tabs:end -->


## 参考文章

[《HTML常用标签详解》](https://blog.csdn.net/weixin_44621343/article/details/114378212)
