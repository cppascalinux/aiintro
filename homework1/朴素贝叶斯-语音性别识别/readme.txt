.xls文件就是下载得到的文件，将它通过文件xls2mat.m之后即可获得voice_data.mat文件，这就是上文所提到的那个3168*21矩阵。mydiscretization.m进行量化处理就得到了量化后的数据文件，该数据文件覆盖voice_data.mat.
training.m得到训练集TrainingSets.mat
validation.m得到验证集ValidationSets.mat。
在实验中，先后运行training.m和validation.m即可得到结果。

另外的3个.m文件是辅助性文件，它们的功能分别是：   
myhowmany.m：查询某个数据在某个矩阵中的数量。   
myisinterger.m：查询某矩阵中整数的个数，并找出非整数元素的坐标。   
myrowcheck.m：找出某2个矩阵的相同行并返回其在原矩阵中的行坐标。