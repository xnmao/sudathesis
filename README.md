# `sudathesis` 苏州大学学位论文 LaTeX 模板


## 模板下载

* 页面右边点击：**Code -> [Download ZIP](<https://github.com/xnmao/sudathesis/archive/refs/heads/master.zip>)**


## 模板简介

模板基于[mohuangrui/ucasthesis](<https://github.com/mohuangrui/ucasthesis>)。
因此，使用该模板前建议先尝试`ucasthesis`能否编译成功。
然后阅读该模板的对`ucasthesis`的**主要更改**和**注意事项**。

### 主要更改

#### 页边距及排版方式

已遵照《苏州大学研究生学位论文基本格式》，即“版心内心尺寸为155×230mm，含页眉、页码的版心尺寸为155×250mm”。
在`thesis.tex`中可设置排版方式：
```latex
\documentclass[oneside]{style/sudathesis}% 单面排版，适合作为电子版
\documentclass[twoside]{style/sudathesis}% 双面排版，适合作为电子版
\documentclass[print]{style/sudathesis}% 预留装订距离的双面排版，适合作为纸质打印版
```
PS:《苏州大学研究生学位论文基本格式》要求“使用时左侧要留出2.5cm以备装订”。
这一点有些奇怪，因为A4纸宽210mm，文字宽度要求155mm，
如果文字居中，则左右皆有2.75cm的边距，已经满足2.5cm的装订要求。
因此我在`print`版中，设置的是左边距30mm（用于装订），右边距25mm。

#### 页眉
已遵照《基本格式》，即“奇数页页眉横线左侧为论文题目，右侧为章节标题；偶数页页眉横线左侧为章节标题，右侧为论文题目”。

#### 字体字号

已遵照《基本格式》，即“标题用小二号黑体（或标宋体）；正文用4号或小4号宋体，小标题用4号黑体”。
在这份模板中：
标题是小二号黑体，正文是小四号宋体，小标题是四号黑体。

参考文献的字体字号在`thesis.tex`中设置：
```latex
\renewcommand{\bibfont}{\zihao{-4}}% 参考文献使用小4号
```
《基本格式》中要求“参考文献及附录内容用4号或小4号楷体”。
这份模板没有设置楷体（因为楷体`\itshape`或`\textit`对应的英文字体看上去很奇怪？）。
如果有内容用到楷体，需要自行调整。

#### 其它

其它在《基本格式》中未提及的要求，例如行间距、段间距等，都遵循了源代码usasthesis即国科大指导文件的格式要求。


### 注意事项

#### 封面

使用研究生院提供的word封面模板，导出pdf文件，把它与论文pdf拼接起来。
很多工具都能拼接pdf，比如[ilovepdf](<https://www.ilovepdf.com/>)。
也可使用Python工具：
```python
from PyPDF2 import PdfFileMerger

merger = PdfFileMerger()
for file in ('cover.pdf', 'thesis.pdf'): # 封面，正文
    merger.append(file)
merger.write('10285_20184214032_LW.pdf') # 合并
```
最终的封面都由学校指定印刷单位按学校规定统一制作。


## 苏州大学研究生院-学位工作
* 相关表格下载(含格式要求):
http://yjs.suda.edu.cn/d4/c8/c8368a316616/page.htm
