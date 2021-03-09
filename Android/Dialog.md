**\>对话框**

-   AlertDialog

    1.  组成：包括图标区、标题区、内容区、按钮区

    2.  使用步骤：定义对象-\>设定标题-\>设定图标-\>设定对话框的内容-\>设置按钮-\>创建对象

    3.  相关方法：setTitle();setCustomTitle();setIcon();setPositiveButton();setNegativeButton;setNeutralButton();setMessage();setItems();setSingelChoiceItems();setAdapter();setView()

        遇到的问题：

        android:theme=”@android:style/Theme.Material.Dialog.Alert在manifest.xml中修改视图的主题失败，导致软件不能启动

        View root =
        this.getLayoutInflater().inflate(R.layout.popup,null);这句话的具体意图没有搞明白，似乎是把某个视图声明为子视图。
