http://www.360doc.com/content/17/0307/19/39202731_634787879.shtml

### kernels简介

TF中包含大量Op算子，这些算子组成Graph的节点集合。这些算子对Tensor实现相应的运算操作。

OpKernel类（core/framework/op_kernel.h）是所有Op类的基类。继承OpKernel还可以自定义新的Op类。用的较多的Op如（MatMul,  Conv2D,  SoftMax,  AvgPooling, Argmax等）。



所有Op包含注册（Register Op）和实现（正向计算、梯度定义）两部分。



所有Op类的实现需要overide抽象基函数 void Compute(OpKernelContext* context)，实现自身Op功能。用户可以根据需要自定义新的Op操作，参考[12]。



TF中所有Op操作的属性定义和描述都在 ops/ops.pbtxt。如下Add操作，定义了输入参数x、y，输出参数z。


> 下面介绍不同的op实现的办法

### UnaryOp & BinaryOp



UnaryOp和BinaryOp定义了简单的一元操作和二元操作，类定义在/core/kernels/ cwise_ops.h文件，类实现在/core/kernels/cwise_op_*.cc类型的文件中，如cwise_op_sin.cc文件。



一元操作全称为Coefficient-wise unary operations，一元运算有abs， sqrt， exp， sin， cos，conj（共轭）等。如abs的基本定义：


二元操作全称为Coefficient-wise binary operations，二元运算有add，sub， div， mul，mod等。如sum的基本定义：

