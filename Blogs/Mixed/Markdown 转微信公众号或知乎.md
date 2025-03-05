# Markdown 转微信公众号或知乎

> [!Note|style:callout|label:Infor]
Initially published at 19:12 on 2025-02-27 in Beijing.

## 背景

通常情况下，我的博客和文章等会用 Markdown 写成后，先发布到自己的个人网站，再同步发送到微信公众号或知乎，因此衍生出 Markdown 转微信公众号或知乎的需求。

在网上检索之后，我找到了下面的几个编辑器，可以将 Markdown 转成微信公众号或知乎的格式：

<div class='center'>

| 网址 | 支持微信或知乎 | 特点 |
|:-:|:-:|:-:|
 | [https://md.openwrite.cn](https://md.openwrite.cn/) | 微信 | 完美支持 Latex 公式渲染，简洁而实用的样式设置，支持自定义 CSS |
 | [https://markdown.com.cn/](https://markdown.com.cn/) | 微信、知乎 | 完美支持 html 图片插入，但微信公众号公式渲染不够好，支持自定义 CSS |
 | [https://foxmd.cn](https://foxmd.cn/) |  |  |
 | [https://mdnice.com/](https://mdnice.com/) |  | 需登录 |
</div>

最终我选择使用 [https://md.openwrite.cn](https://md.openwrite.cn/) 作为 Markdown 转微信公众号的工具，选择 [https://markdown.com.cn/](https://markdown.com.cn/) 作为 Markdown 转知乎的工具。

我的微信公众号 [https://md.openwrite.cn](https://md.openwrite.cn) 转换代码如下：


<!-- 主题色为 rgba(107, 97, 235, 1) -->
```css
/**
 * 按 Alt/Option + Shift + F 可格式化
 * 如需使用主题色，请使用 var(--md-primary-color) 代替颜色值
 * 如：color: var(--md-primary-color);
 *
 * 召集令：如果你有好看的主题样式，欢迎分享，让更多人能够使用到你的主题。
 * 提交区：https://github.com/doocs/md/discussions/426
 */
/* 顶层容器样式 */
container {
  text-align: left;
  line-height: 1.75;
}
p {
  margin:0px 0px;
  line-height:1.5;
  letter-spacing:2em;
  font-size: 15px;
  word-spacing:0em;
}
/* 一级标题样式 */
h1 {
  display: table;
  padding: 0.3em 0em;
  border-bottom: 2px solid var(--md-primary-color);
  margin: 0em 0 0em;
  color: hsl(var(--foreground));
  font-size: 1.5em;
  font-weight: bold;
  text-align: center;
  text-shadow: 1px 1px 5px rgba(0,0,0,0.05);
}
/* 二级标题样式 */
h2 {
  display: table;
  padding: 0.1em 0.5em;
  margin: 3em auto 0em;
  color: #fff;
  background: var(--md-primary-color);
  font-size: 1.4em;
  font-weight: bold;
  text-align: center;
  border-radius: 10px 10px 10px 10px;
  box-shadow: 0 5px 6px rgba(0,0,0,0.06);
}
/* 三级标题样式 */
h3 {
  padding-left: 12px;
  font-size: 1.2em;
  border-radius: 10px;
  line-height: 2.1em;
  border-left: 4px solid var(--md-primary-color);
  border-right: 1px solid color-mix(in srgb, var(--md-primary-color) 80%, transparent);
  background: color-mix(in srgb, var(--md-primary-color) 60%, transparent);
  color: white;
  margin: 2em 8px 0.75em 0;
  font-weight: bold;
}
/* 四级标题样式 */
h4 {
  margin: 2em 8px 0.5em;
  color: var(--md-primary-color);
  font-size: 1.1em;
  font-weight: bold;
  border-radius: 6px;
}
/* 五级标题样式 */
h5 {
  margin: 1.5em 8px 0.5em;
  color: var(--md-primary-color);
  font-size: 1em;
  font-weight: bold;
  border-radius: 6px;
}
/* 六级标题样式 */
h6 {
  margin: 1.5em 8px 0.5em;
  font-size: 1em;
  color: var(--md-primary-color);
  border-radius: 6px;
}
/* 图片样式 */
image {
  display: block;
  width: 100% !important;
  margin: 0.1em auto 0.5em;
  border-radius: 8px;
  border: 1px solid rgba(0, 0, 0, 0.04);
}
/* 引用样式 */
blockquote {
  font-style: italic;
  padding: 1em 1em 1em 2em;
  border-left: 4px solid var(--md-primary-color);
  border-radius: 6px;
  color: rgba(0,0,0,0.6);
  background: var(--blockquote-background);
  margin-top: 1em;
  margin-bottom: 1em;
  border-bottom: 0.2px solid rgba(0, 0, 0, 0.04);
  border-top: 0.2px solid rgba(0, 0, 0, 0.04);
  border-right: 0.2px solid rgba(0, 0, 0, 0.04);
}
/* 引用段落样式 */
blockquote_p {
  display: block;
  font-size: 1em;
  letter-spacing: 0.1em;
  color: hsl(var(--foreground));
}
/* GFM note 样式 */
blockquote_note {
  font-style: italic;
}
/* GFM tip 样式 */
blockquote_tip {
  font-style: italic;
}
/* GFM important 样式 */
blockquote_important {
  font-style: italic;
}
/* GFM warning 样式 */
blockquote_warning {
  font-style: italic;
}
/* GFM caution 样式 */
blockquote_caution {
  font-style: italic;
}
/* GFM 通用标题 */
blockquote_title {
  display: flex;
  align-items: center;
  gap: 0.5em;
  margin-bottom: 0.5em;
}
/* GFM note 标题 */
blockquote_title_note {
  color: #478be6;
}
/* GFM tip 标题 */
blockquote_title_tip {
  color: #57ab5a;
}
/* GFM important 标题 */
blockquote_title_important {
  color: #986ee2;
}
/* GFM warning 标题 */
blockquote_title_warning {
  color: #c69026;
}
/* GFM caution 标题 */
blockquote_title_caution {
  color: #e5534b;
}
/* GFM note 段落样式 */
blockquote_p_note {
}
/* GFM tip 段落样式 */
blockquote_p_tip {
}
/* GFM important 段落样式 */
blockquote_p_important {
}
/* GFM warning 段落样式 */
blockquote_p_warning {
}
/* GFM caution 段落样式 */
blockquote_p_caution {
}
/* 段落样式 */
p {
  margin: 1.5em 8px;
  letter-spacing: 0.1em;
  color: hsl(var(--foreground));
  text-align: justify;
}
/* 分割线样式 */
hr {
  height: 1px;
  border: none;
  margin: 2em 0;
  background: linear-gradient(to right, rgba(0,0,0,0), rgba(0,0,0,0.1), rgba(0,0,0,0));
}
/* 行内代码样式 */
codespan {
  font-size: 90%;
  color: #d14;
  background: rgba(27,31,35,.05);
  padding: 3px 5px;
  border-radius: 4px;
}
/* 粗体样式 */
strong {
  color: var(--md-primary-color);
  font-weight: bold;
  font-size: inherit;
}
/* 链接样式 */
link {
  color: #576b95;
}
/* 微信链接样式 */
wx_link {
  color: #576b95;
  text-decoration: none;
}
/* 有序列表样式 */
ol {
  padding-left: 1.5em;
  margin-left: 0;
  color: hsl(var(--foreground));
}
/* 无序列表样式 */
ul {
  list-style: none;
  padding-left: 1.5em;
  margin-left: 0;
  color: hsl(var(--foreground));
}
/* 列表项样式 */
li {
  text-indent: -1em;
  display: block;
  margin: 0.5em 8px;
  color: hsl(var(--foreground));
}
/* 代码块样式 */
code {
  margin: 0;
  white-space: pre-wrap;
  font-family: 'Fira Code', Menlo, Operator Mono, Consolas, Monaco, monospace;
}
/* 代码块外层样式 */
code_pre {
  font-size: 14px;
  overflow-x: auto;
  border-radius: 8px;
  padding: 1em;
  line-height: 1.5;
  margin: 10px 8px;
  border: 1px solid rgba(0, 0, 0, 0.04);
}
```











































知乎 [https://markdown.com.cn/editor/](https://markdown.com.cn/editor/) 的转换代码：
``` css
/*自定义样式，实时生效*/

/*自定义样式，实时生效*/

/* 全局属性
 * 页边距 padding:10px;
 * 全文字体 font-family:ptima-Regular;
 * 英文换行 word-break:break-all;
 */
#nice {
  font-family:PingFangSC-Light;
}

/* 段落，下方未标注标签参数均同此处
 * 上边距 margin-top:5px;
 * 下边距 margin-bottom:5px;
 * 行高 line-height:26px;
 * 词间距 word-spacing:3px;
 * 字间距 letter-spacing:3px;
 * 对齐 text-align:left;
 * 颜色 color:#ffffff;
 * 字体大小 font-size:5px;
 * 首行缩进 text-indent:2em;
 */
#nice p {
  margin:0px 0px;
  line-height:1.5;
  letter-spacing:0.2em;
  font-size: 12px;
  word-spacing:0.1em;
}

/* 一级标题 */
#nice h1 {
  border-bottom: 2px solid #0e88eb;
  font-size: 1em;
  text-align: center;
}

/* 一级标题内容 */
#nice h1 .content {
  font-size: 1em;
  display:inline-block;
  font-weight: bold;
  //background: #0e88eb;
  color:#ffffff;
  color: #0e88eb;
  padding:3px 10px 1px;
  border-top-right-radius:3px;
  border-top-left-radius:3px;
  margin-right:3px;
}

/* 一级标题修饰 请参考有实例的主题 */
#nice h1:after {
}
 
/* 二级标题 */
#nice h2 {
  text-align:left;
  margin:20px 10px 0px 0px;
}

/* 二级标题内容 */
#nice h2 .content {
  font-family:STHeitiSC-Light;
  font-size: 14px;
  color:#0e88eb;
  font-weight:bolder;
  display:inline-block;
  padding-left:10px;
  border-left:5px solid #0e88eb;
}

/* 二级标题修饰 请参考有实例的主题 */
#nice h2:after {
}

/* 三级标题 */
#nice h3 {
    font-size: 18px;
     color: #0e88eb;
}

/* 三级标题内容 */
#nice h3 .content {
  font-size: 13px;
  color: #0e88eb;
}

/* 三级标题修饰 请参考有实例的主题 */
#nice h3:after {
}

/* 无序列表整体样式
 * list-style-type: square|circle|disc;
 */
#nice ul {
}

/* 有序列表整体样式
 * list-style-type: upper-roman|lower-greek|lower-alpha;
 */
#nice ol {
}

/* 列表内容，不要设置li
 */
#nice li section {
  font-size: 11px;
}

/* 引用
 * 左边缘颜色 border-left-color:black;
 * 背景色 background:gray;
 */
#nice blockquote {
  font-style:normal;
  border-left:none;
  padding:10px;
  position:relative;
  line-height:1.8;
  border-radius:0px 0px 10px 10px;
  color: #0e88eb;
  background:#fff;
  box-shadow:#84A1A8 0px 10px 15px;
}
#nice blockquote:before {
 % content:"★  ";
  display:inline;
  color: #0e88eb;
  font-size:1.2em;
  font-family:Arial,serif;
  line-height:0em;
  font-weight:700;
}

/* 引用文字 */
#nice blockquote p {
  color: #0e88eb;
  font-size:12px;
  display:inline;
}
#nice blockquote:after {
  %content:"”";
  float:right;
  display:inline;
  color:#0e88eb;
  font-size:1.2em;
  line-height:1em;
  font-weight:500;
}

/* 链接 
 * border-bottom: 1px solid #009688;
 */
#nice a {
  color: #0e88eb;
  border-bottom: 0px solid #ff3502;
  font-family:STHeitiSC-Light;
}

/* 加粗 */
#nice strong {
  font-weight: border;
  color: #0e88eb;
}

/* 斜体 */
#nice em {
  color: #555555;
  letter-spacing:0.0em;
}

/* 加粗斜体 */
#nice em strong {
  color: #0e88fa;
  letter-spacing:0.3em;
}

/* 删除线 */
#nice del {
}
 
/* 分隔线
 * 粗细、样式和颜色
 * border-top:1px solid #3e3e3e;
 */
#nice hr {
  height:1px;
  padding:0;
  border:none;
  border-top:medium solidid #333;
  text-align:center;
  background-image:linear-gradient(to right,rgba(248,57,41,0),#0e88eb,rgba(248,57,41,0));
}

/* 图片
 * 宽度 width:80%;
 * 居中 margin:0 auto;
 * 居左 margin:0 0;
 */
#nice img {
  border-radius:0px 0px 5px 5px;
  display:block;
  margin:20px auto;
  width:85%;
  height:100%;
  object-fit:contain;
  box-shadow:#84A1A8 0px 10px 15px;
}

/* 图片描述文字 */
#nice figcaption {
  display:block;
  font-size:12px;
  font-family:PingFangSC-Light;
}

/* 行内代码 */
#nice p code, #nice li code {
  color:/*自定义样式，实时生效*/
}

/* 非微信代码块
 * 代码块不换行 display:-webkit-box !important;
 * 代码块换行 display:block;
 */
#nice pre code {
}

/*
 * 表格内的单元格
 * 字体大小 font-size: 16px;
 * 边框 border: 1px solid #ccc;
 * 内边距 padding: 5px 10px;
 */
#nice table tr th,
#nice table tr td {
  font-size: 15px;
}

/* 脚注文字 */
#nice .footnote-word {
  color: #2d59b3;
}

/* 脚注上标 */
#nice .footnote-ref {
  color: #6a88c5;
}

/* 非微信代码块
 * 代码块不换行 display:-webkit-box !important;
 * 代码块换行 display:block;
 */
#nice pre code {
}

/* 脚注文字 */
#nice .footnote-word {
  color: #0e88eb;
}

/* 脚注上标 */
#nice .footnote-ref {
  color: #0e88eb;
}

/*脚注链接样式*/
#nice .footnote-item em {
  color: #082a71;
  font-size:12px;
}

/* "参考资料"四个字 
 * 内容 content: "参考资料";
 */
#nice .footnotes-sep:before {
}

/* 参考资料编号 */
#nice .footnote-num {
}

/* 参考资料文字 */
#nice .footnote-item p { 
}

/* 参考资料解释 */
#nice .footnote-item p em {
}

/* 行间公式
 * 最大宽度 max-width: 300% !important;
 */
#nice .block-equation svg {
  width:60%;
  height:100%;
}

/* 行内公式
 */
#nice .inline-equation svg {
}
```