Integral_Displacement.m---时域积分得到每条航线的加速度计位移
TL_Coeff_Matrix_Dis.m---通过TL模型拟合得出信息矩阵（加上了Y轴的位移数据）
TL_Compensation.m---得到信息矩阵后，对L1-L8航线光泵数据进行补偿

ZiTai_Infor.m---TL模型信息矩阵函数
Mygradient.m---在ZiTai_Infor.m中算出输入数据的微分
DataPrecessing.m---在TL_Coeff_Matrix_Dis.m中计算X0值和滤波后的光泵值

CompenCoff.mat---保存TL模型的信息矩阵

Myfiltfilt和Myfilter是源代码使用的滤波器，本代码没有使用
Filter文件夹保存以上两个函数的滤波器参数

Data_Fly_Hainan_Original文件夹保存直接导出来的原始数据
Data_Fly_Hainan_Downsample_Displacement文件夹保存原始数据1/4下采样
并后三列加上加速度计三轴位移的数据

程序运行步骤为：
Integral_Displacement.m->TL_Coeff_Matrix_Dis.m->TL_Compensation.m
运行TL_Compensation.m查看最终补偿结果