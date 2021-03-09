# -*- coding: utf-8 -*-
import queue
import re
import urllib2
import time
import urllib2
headers=("User-Agent","Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36")
opener=urllib2.build_opener()
opener.addheaders=[headers]
#global the opener
urllib2.install_opener(opener)
listurl=[]

#use the procy server
def use_proxy(proxy_addr,url):
    try:
        import urllib2
        data = urllib2.urlopen(url).read().decode('utf-8')
        return data
    except urllib2.URLError as e:
        if hasattr(e,"code"):
            print(e.code)
        if hasattr(e,"reason"):
            print(e.reason)
        time.sleep(10)
    except Exception as e:
        print("exception:"+str(e))
        time.sleep(1)
# get the  picture
def craw(url,number):
    html1=urllib2.urlopen(url).read().decode('utf-8')
    html1=html1
    pat1='<tr><td class="contentstyle54611">(.*?)</body></html>'
    result1=re.compile(pat1,re.S).findall(html1)
    result1=result1[0]
    pat2='<IMG border="0" src="(.*?).jpg"'
    imagelist=re.compile(pat2,re.S).findall(result1)
    x=1;
    for imageurl in imagelist:
        imagename="E:/hello/"+str(x)+str(number)+".jpg"
        imageurl = imageurl.replace('../../', "")
        imageurl = "http://zdhxy.nwpu.edu.cn/" + imageurl+'.jpg'
        try:
            urllib2.urlretrieve(imageurl,filename=imagename)
        except urllib2.URLError as e:
            if hasattr(e, "code"):
                print(e.code)
            if hasattr(e, "reason"):
                print(e.reason)
        x+=1;


#get the content through the link
def getcontent(listurl,proxy):
    i=0
    #set local files's html code
    html1='''<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://
    www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>computer</title>
</head>
<body>'''
    fh=open("E:/hello/2.html","wb")
    fh.write(html1.encode("utf-8"))
    fh.close()
    fh=open("E:/hello/2.html","ab")
    for i in range(0,len(listurl)):
        for j in range(0,len(listurl[i])):
            try:
                url=listurl[i][j]
                url=url.replace("\"","")
                url = url.replace('../', "")
                url="http://jsj.nwpu.edu.cn/"+url
                data2=use_proxy(proxy,url)
                craw(url,j)
                titlepat='<title>(.*?)</title>'
                contentpat='<tr><td class="contentstyle54611">(.*?)</body></html>'
                title=re.compile(titlepat).findall(data2)
                content=re.compile(contentpat,re.S).findall(data2)
                thistitle=" "
                thiscontent=" "

                if(title!=[]):
                    thistitle=title[0]
                if(content!=[]):
                    thiscontent=content[0]
                dataall="<p>title is :"+thistitle+"</p><p>content is :"+thiscontent+"</p><br>"
                fh.write(dataall.encode("utf-8"))
                print("第"+str(i)+"第个网站"+str(j)+"次处理")
            except urllib2.URLError as e:
                if hasattr(e, "code"):
                    print(e.code)
                if hasattr(e, "reason"):
                    print(e.reason)
                time.sleep(10)
            except Exception as e:
                print("exception:" + str(e))
                time.sleep(1)
    fh.close()
    html2='''</body>
</html>
        '''
    fh=open("E:/hello/2.html","ab")
    fh.write(html2.encode("utf-8"))
    fh.close()

proxy="123.145.128.139:8118"
pagestart=1
pageend=2

url="http://jsj.nwpu.edu.cn/index/xyxw.htm"
data1=use_proxy(proxy,url)
listurlpat='<a class="c54630" href="(.*?)"'
listurl.append(re.compile(listurlpat,re.S).findall(data1))
getcontent(listurl,proxy)
#print(title);
#listurl=getlisturl(key,pagestart,pageend,proxy)
#getcontent(listurl,proxy)