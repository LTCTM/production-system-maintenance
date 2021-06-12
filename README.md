# 状态一览

| 编号  | 字母  | 中文名 |
| :---: | :---: | :----- |
|   1   |  Fon  | 生产中 |
|   2   |  MC   | 维修中 |
|   3   |  MP   | 维护中 |
|   4   |       | 满仓中 |


# 事件一览

| 编号  | 中文名         | 流程  |
| :---: | :------------- | :---: |
|   1   | 机器故障了     | 生产  |
|   2   | 机器修好了     | 生产  |
|   3   | 机器开始维护   | 生产  |
|   4   | 机器完成维护   | 生产  |
|   5   | 生产了一个产品 | 生产  |
|   6   | 客户拿货       | 交付  |

# 常量一览

| 字母  | 中文名               | 单位  |
| :---: | :------------------- | :---- |
|  tbf  | 生成故障的随机函数   | 秒    |
|   H   | 设计运行总时长       | 秒    |
|  Uc   | 单次维修时长         | 秒/次 |
|  Up   | 单次维护时长         | 秒/次 |
|   f   | 交货频率             | 秒    |
|   q   | 单次交货量           | 个    |
|   T   | 维护频率             | 秒    |
| Umax  | 生产一个产品所需时间 | 秒/个 |
| nsmax | 满容                 | 个    |

| 字母  | 中文名                 | 单位       |
| :---: | :--------------------- | :--------- |
|  cmc  | 一次维修的成本         | 元/次      |
|  cmp  | 一次维护的成本         | 元/次      |
|  cup  | 生产一个产品的成本     | 元/个      |
|  cus  | 单位时间单位产品仓储费 | 元/(个·秒) |
| cupe  | 每件交付失败罚金       | 元/个      |

# 板书中的重要变量

| 字母  | 中文名                         | 单位 |
| :---: | :----------------------------- | :--- |
|  pe   | 从上一个事件到本事件之间的时长 | 秒   |

# 要求计算的值

| 编号  | 字母  | 中文名             | 单位  |
| :---: | :---: | :----------------- | :---- |
|   1   | tsim  | 累计运行时长       | 秒    |
|   2   |  CMC  | 累计维修成本       | 元    |
|   3   |  CMP  | 累计维护成本       | 元    |
|   4   |  CPR  | 累计生产产品的成本 | 元    |
|   5   |  CS   | 累计仓储费         | 元    |
|   6   |  CPE  | 累计交付失败罚金   | 元    |
|   7   |  CT   | 累计总花费         | 元    |
|   8   |  CM   | 累计单位时间花费   | 元/秒 |
|   9   |  ns   | 当前库存量         | 个    |


# 状态-事件

注意满仓状态本质上是生产中状态，在代码里用另一个变量表示是否满仓才更合理，因此不计入这个表

| <sub>事件</sub> \ <sup>状态</sup> |   1   |   2   |   3   |
| :-------------------------------: | :---: | :---: | :---: |
|                 1                 |   A   |   x   |   x   |
|                 2                 |   x   |   B   |   x   |
|                 3                 |   C   |   x   |   x   |
|                 4                 |   x   |   x   |   D   |
|                 5                 |   E   |   x   |   x   |
|                 6                 |   F   |   F   |   F   |

# 逻辑流程
## 维修与维护的关系

法国人认为

- 如果现在处于维护中，那么即使维修时间插在中间，下一个事件还是维护结束
- 维护**结束**后刷新维修
- 维修维护互换同理
- 交货可以插在维修或维护中间，需要加if分支

这样和我们自己的逻辑等效

- 维护**开始**时就刷新维修
- 维修刷新时间要加上一个维护的长度
- 维修维护互换同理
- 交货独立于维修或维护计算

## 维护或维修期间，生产出产品时间的延时

法国人认为

- 如果现在处于维护中，那么只有维护结束时间和交货时间会正常减去一次维护时长
- 维修相关的时间被刷新
- 生产出产品时间**不变**，也就是变相地延后了一次维护时长
- 维修维护互换同理

这样和我们自己的逻辑等效

- 维护或维修开始时直接令生产出产品的时间**延后**对应的区间时长

另外，满仓交货时重置生产出产品的时间。

## 算法分支

循环找到使找花费最小的维护周期T值

## 多机器

法国人写的代码超出人类理解范畴，已自己维护代码
