
def func(x,y,z):
    return x+y+z

def func2(f, para1, args):
    back=f(para1, *args)
    print(back)

func2(func,1,(4,2))