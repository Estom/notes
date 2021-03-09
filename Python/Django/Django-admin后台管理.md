与yii框架相似，通过脚手架的方式直接生成对原始数据的管理，并且可以通过对数据的简单控制实现管理的基础功能。

class ContactAdmin(admin.ModelAdmin):

list_display = ('name', 'age', 'email')

search_fields = ('name', 'age')

inlines = [TagInline, ]

fieldsets = (

['Main',{

'fields':('name','email'),

}],

['Advance',{

'classes': ('collapse',), \# CSS

'fields': ('age',),

}]

)
