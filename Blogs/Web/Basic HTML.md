# Basic HTML

>[!TIP]
Awesome site for learning web development:   
https://developer.mozilla.org/zh-CN/docs/Learn/Getting_started_with_the_web (中文)  
https://developer.mozilla.org/en-US/docs/Learn/Getting_started_with_the_web (English)  <br><br>
Editing and preview HTML+CSS+JS online:  
https://codepen.io/madzadev/pen/zYdOVPV


## HTML常用标签

### Head常用标签

网页相关：

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

```html
meta标签必须写在头部head标签之内，而description的meta标签务必要写在keywords的meta标签之后，像下面这样的顺序写：
1.关键字：description要用简短的文字描述网站或网页的主要内容，有利于各大搜索引擎的抓取收录你的网站或网页。
2.页面描述：当你设置了description网站描述文字，才会显示在搜索引擎的结果页中，而每个网页的description也是同样的道理，简短又准确的网页描述文字，可以帮助用户在搜索引擎中更方便的找到你的网站和网页！

<!-- 指定文档的编码类型(需要知道) -->
<meta http-equiv="content-Type" charset=UTF8">
                                             
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

### Body常用标签
<!-- tabs:start -->

#### **基本标签(块级标签和内联标签)**
```html
<!--b Bold 粗体（文本）-->
<b>加粗</b>

<!--i Italic /ɪˈtælɪk/ 斜体（文本）-->
<i>斜体</i>

<!--u Underlined 下划线（文本）-->
<u>下划线</u>

<!--s Strikethrough  /straɪk/	删除线-->
<s>删除</s>

<p>段落标签</p>

<!--h1~h6 Header 1 to Header 6 标题1到标题6-->
<h1>标题1</h1>
<h2>标题2</h2>
<h3>标题3</h3>
<h4>标题4</h4>
<h5>标题5</h5>
<h6>标题6</h6>

<!--br Break 换行-->
<br>

<!--hr Horizontal Rule  /ˌhɒrɪˈzɒntl/ 水平线，分割线-->
<hr>

<!--br Break 修改文字大小，颜色-->
<font color="red" size="10px">我是菜鸟</font>

引用斜体标签 `<em>`：<em>斜体</em>  
粗体标签`<strong>`：<strong>粗体</strong>  
下划线`<ins>`：<ins>下划线</ins>  
大于号 `&gt;`：&gt;  
小于号`&lt;`：&lt;  
引号`&quot;`：&quot;  
注册商标`&reg;`：&reg;  
空格`&nbsp;` 
水平线 `<hr/>` 或 `<hr>`
换行标签 `<br/>` 或 `<br>`  
注释 `<!--注释内容-->`  

后面几个是HTML新加入的：strong == b, ins == u, em == i, del == s。新的标签是有语义的，而老的只是单纯的添加样式（这是CSS干的事）
strong的语义：定义重要性强调的文字
ins的语义（inserted）：定义插入的文字
em的语义（emphasized）：定义强调的文字
del的语义（deleted）：定义被删除的文字

```



#### **`<image>`**
`src='{path}'`：`{path}`可以为相对路径、根路径'/'、同级路径'./'、上级路径'../'、绝对路径等<br>
`width={wid}`：`{wid}`可以为10%(不推荐)、400px(像素，推荐)等  
`height={hei}`：同理(width和height仅设置一个时自动等比缩放)  
`alt='{text}'`：图片加载错误时显示的内容
`title='{text}'`：鼠标悬停时显示的内容

#### **`<a>`**

#### **`<p>`**
#### **`<div>`**
#### **`<button>`**

<!-- tabs:end -->

1.  超链接

语法：<a href="链接地址" ></a>

1.   <!-- 跳转至本项目 -->

自身窗口：_self：自身窗口

  <a href="../4.jpg" target="_self">跳转到首页</a>

 新建窗口：_blank：新建窗口

    <a href="../4.jpg" target="_blank"> 这是一个超链接，a链接。跳转到其他页面</a>

2.  <!-- 跳转至外网 -->

<a href="https://www.baidu.com" target="_blank">百度一下你就知道 </a>

3. <!-- 点图片跳转 -->

<a href="https://www.hao123.com " target="_blank">

        <img src="../4.jpg" width="150px" height="200px">

4.<!-- 拨打电话   tel -->

<a href="tel:16688483388">16688483388</a>

5.<!-- 下载文件

        浏览器直接打开跳转【html/txt】    

        浏览器下载文件【ppt/doc/excel/pdf/exe】  -->

<a href="./文件.doc">下载文件

6.锚连接

创建跳转链接：  <a href =“#maker”>链接</a>

创建跳转标记： <a name =“maker” >跳转位置</a>、

举例：


标题
三、HTML列表

1.无序列表

<ul>用来声明无序列表      <li>用来表示列表项。

type属性值:  none 没有列表符号

                     circle 空心圆

                     disc   实心圆

                     square  实心正方形

2.有序列表

<ol>用来声明有序列表。 <li>用来表示列表项。

type属性值：1    数字1、2、3……

type属性值：a/A    小/大写英文字母

type属性值：i/I    小/大写罗马数字

3.自定义列表

<dl>用来声明自定义列表

<dt>用来表示列表标题 

<dd>用来表示列表内容

4.HTML表格的基本语法

rowspan跨行  ：rowspan 属性规定单元格可横跨的行数。

colspan跨列    ：colspan 属性规定单元格可横跨的列数。

<td> 标签：每行被分割为若干单元格使用td定义

 <tr> 标签：表格均有若干行组成使用tr定义

<table> 标签：定义表格

5.HTML表格美化

border：设置边框

bgcolor：设置背景颜色

align：设置表格在网页中的对齐方式

cellspacing：设置单元格与单元格之间的距离

cellpadding：设置文字与单元格之间的距离

width/height：表格的宽度/表格高度

四.HTML表单

1.发送表单数据的方式：

标签属性：method

常用值：get  | post

2.向何处发送表单数据：

标签属性：action

<form  method="post" action="xxx.html"></form>

3.表单元素属性

文本输入：

属性值：text,password

作    用：text,表单中键入字母、数字等内容。

               password，输入密码字段。

文件选择：

属性值：file

作    用：file,定义了文件选择。

按钮：

属性值：button

作    用：button,定义了普通按钮。

选择：

属性值：checkboxes,radio

作    用：checkboxes,表单复选框。

              radio,表单单选框。

提交按钮：

属性值：submit，image

作    用：submit,定义了提交按钮。

              image,定义了图片提交按钮。

重置按钮：

属性值：reset

作    用：reset,定义了重置按钮。

size属性：元素的宽度，当 type 为 text 或 password时。

maxlength：type为text 或 password 时，输入的最大字符数

checked：type为radio或checkbox时，指定按钮是否是被选中

4.HTML下拉列表

select 标签用于声明下来列表

option 标签用于声明列表项



5.HTML多行文本域

可见行数：

 标签属性：rows

rows 属性规定 textarea 的可见高度。

可见宽度：

标签属性：cols

cols 属性规定 textarea 的可见宽度。

最大长度：

标签属性：maxlength

maxlength 属性规定文本区域的最大长度（以字符计）。

名称：
标签属性：name

name 属性为文本区规定名称。

<textarea rows="3" cols="20" maxlength="50" name="demo"></textarea>

 6.表单的高级应用

隐藏域 type="hidden”

只读：readonly=“readonly”

禁用：disabled="disabled"

7.

 HTML语义化表单：

域：使用<fieldset>来定义。将一组表单元素放到域中

域标题：使用<legend>。所谓的域标题就是给创建的域设置个标题。

## 参考文章

[《HTML常用标签详解》](https://blog.csdn.net/weixin_44621343/article/details/114378212)
