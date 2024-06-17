# Basic HTML

## HTML常用标签

### 基本标签

<!-- tabs:start -->
#### **基本标签1**
`<!DOCTYPE>`：必须在 HTML 文档的第一行。用来指示浏览器页面使用哪个 HTML 版本编译指令。  
`<html>`：此元素可告知浏览器其自身是一个 HTML 文档。  
`<head>`：用于定义文档的头部，它是所有头部元素的容器。  
`<body>`：body 元素包含文档的所有内容（如文本、超链接、图像、表格和列表）
标题标签 `<h1>`-`<h6>`：标明文章、作品等内容的简短语句。  
段落标签 `<p>`：占据至少一行，在网页中描述具有一个相对完整的内容。  

#### **基本标签2**
斜体标签 `<em>`：<em>斜体</em>  
粗体标签`<strong>`：<strong>粗体</strong>  
大于号 `&gt;`：&gt;  
小于号`&lt;`：&lt;  
引号`&quot;`：&quot;  
注册商标`&reg;`：&reg;  
空格`&nbsp;` 
水平线 `<hr/>` 或 `<hr>`
换行标签 `<br/>` 或 `<br>`  
注释 `<!--注释内容-->`  
<!-- tabs:end -->

### 常用标签

网页相关：

<!-- tabs:start -->
#### **`<script>`**

#### **`<link>`**

#### **`<meta>`**
`<meta name='' http-equiv='' content=''>`  
http-equiv：

```html
<!--2秒后跳转到对应的网址-->
<meta http-equiv="refresh" content="2;URL=https://www.baidu.com">
```

<!-- tabs:end -->

内容相关：
<!-- tabs:start -->
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
