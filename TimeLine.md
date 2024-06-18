# Time Line

## To Do List
- [ ] 
- [ ] Reorganize the content arrangement
- [ ] Customize plugins

* [x] 2024.6.18 Customize components and themes  
* [x] 2024.6.17 Add plugins
* [x] 2024.6.16 Decide the structure and mport blogs and   
* [x] 2024.6.14 Bulit the website and add basic components

## Time Line of the Site

<div style='margin-left:18%'>
<ul class="timeline-list">
<!-- The Top 1 -->
<li class="timeline-item">
    <div class="timeline-item_tail"></div>
    <div class="timeline-item_node"></div>
    <div class="timeline-item_wrapper">
        <div class="timeline-item_timestamp">July 2024</div>
        <div class="timeline-item_content"><br><!-- 每块顶部单独留一些空间 -->
            <div class="tbox">
                <div class='outerBox'>
                    <div class="dateBox"><div>
                        <tl-title>时间</tl-title>
                        <ul>事件的详细内容事件的详细内容事件的详细内容事件的详细内容事件的详细内容</ul>
                    </div></div>
                </div>
            </div>
            <div class="tbox">
                <div class='outerBox'>
                    <div class="dateBox"><div>
                        <tl-title>时间</tl-title>
                        <ul>事件的详细内容事件的详细内容事件的详细内容事件的详细内容事件的详细内容</ul>
                    </div></div>
                </div>
            </div>
        </div>
    </div>
</li>
<!-- Another Part -->
<li class="timeline-item">
    <div class="timeline-item_tail"></div>
    <div class="timeline-item_node"></div>
    <div class="timeline-item_wrapper">
        <div class="timeline-item_timestamp">July 2024</div>
        <div class="timeline-item_content"><br><!-- 每块顶部单独留一些空间 -->
            <div class="tbox">
                <div class='outerBox'>
                    <div class="dateBox"><div>
                        <tl-title>时间</tl-title>
                        <ul>事件的详细内容事件的详细内容事件的详细内容事件的详细内容事件的详细内容</ul>
                    </div></div>
                </div>
            </div>
            <div class="tbox">
                <div class='outerBox'>
                    <div class="dateBox"><div>
                        <tl-title>时间</tl-title>
                        <ul>事件的详细内容事件的详细内容事件的详细内容事件的详细内容事件的详细内容</ul>
                    </div></div>
                </div>
            </div>
        </div>
    </div>
</li>
<!-- The Bottom Part -->
<li class="timeline-item">
    <div class="timeline-item_tail"></div>
     <div class="timeline-item_tail_add" style='top:10px'></div>
    <div class="timeline-item_node"></div>
    <div class="timeline-item_wrapper">
        <div class="timeline-item_timestamp">July 2024</div>
        <div class="timeline-item_content"><br><!-- 每块顶部单独留一些空间 -->
            <div class="tbox">
                <div class='outerBox'>
                    <div class="dateBox"><div>
                        <tl-title>时间</tl-title>
                        <ul>事件的详细内容事件的详细内容事件的详细内容事件的详细内容事件的详细内容</ul>
                    </div></div>
                </div>
            </div>
            <div class="tbox">
                <div class='outerBox'>
                    <div class="dateBox"><div>
                        <tl-title> The site's birthday!</tl-title>
                        <ul>
Our site comes his first birthday on June 14, 2024. A long journey can be covered only by taking one step at a time.
Everything is possible from this day! 
                        </ul></div></div>
                </div>
            </div>
        </div>
    </div>
    <div class="timeline-item_node"></div>
    <div class="timeline-item_wrapper">
    <div class="timeline-item_timestamp">July 14, 2024</div>
</li>
</ul>
</div>

<style>
.timeline-list{
    margin: 0;
    font-size: 14px;
    list-style: none;  
}
.timeline-item:last-child .timeline-item_tail {
    display: none;
}
.timeline-item{
    position: relative;
    padding-bottom: 20px;
}
.timeline-item_tail{
    position: absolute;
    left: 5px;
    height: 100%;
    border-left: 2px solid rgb(228,231,237);
}

.timeline-item_tail_add{
    position: absolute;
    left: 5px;
    height: 285px;
    border-left: 2px solid rgb(228,231,237);
}

.timeline-item_node{
    position: absolute;
    background-color: #e4e7ed;
    border-radius: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
    left: -2px;
    width: 15px;
    height: 15px;
    background: #fff;
    border:3px solid #2395FF
}
.timeline-item_wrapper{
    position: relative;
    padding-left: 20px;
    top: 0px;
}
.timeline-item_timestamp{
    margin-bottom: 8px;
    padding-top: 0px;
    color: #242424;
    line-height: 1;
    font-weight: 700;
    font-size: 13px;      
}
.delclass{
    color: #0379FB;
    font-weight: normal;
    cursor: pointer;
}
.delclass:hover{
    color: #2395FF;
}
.tbox{
    padding:10px;
    height:94px;
    margin-left: -27px;
}
.tbox-content{
    background:rgb(238, 255, 255);
    padding: 15px;
    width: auto;
    height: auto;
}
.pannel{
    border-radius: 4px;
    border: 1px solid #ebeef5;
    background-color: #fff;
    overflow: hidden;
    color: #303133;
    transition: .3s;
   
}
.pannel-header{
    padding: 20px;
}
.pannel-body{
    padding: 20px;
}
.pannel.shadow{
    box-shadow: 0 2px 12px 0 rgba(0,0,0,.1);
}
.config{
    background:rgba(252,252,252,1);
    padding: 20px;
    margin-bottom: 15px;
    position: relative;  
}
.delItem{
    position: absolute;
    font-size: 17px;
    color: #333;
    top: -8px;
    right: -5px;
    cursor: pointer;
}
.config-content{
    margin-top: 15px;
}
.imgLabel{
    width: 80px;
    color: #999;
}
.imgList{
    margin-left: 80px;
    padding: 10px;
    background: rgba(246,246,246,1);
}
</style>
