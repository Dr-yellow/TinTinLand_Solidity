// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



// 使用 Solidity 实现一个插入排序算法

// 排序算法解决的问题是将无序的一组数字，例如[2, 5, 3, 1]，从小到大依次排列好。插入排序（InsertionSort）是最简单的一种排序算法，也是很多人学习的第一个算法。它的思路很简单，从前往后，依次将每一个数和排在他前面的数字比大小，如果比前面的数字小，就互换位置。

contract InsertionSortContract {
// 测试排序函数
function insertionSort_Test(uint256[] memory a)
public
pure
returns (uint256[] memory)
{
// note that uint can not take negative value
for (uint256 i = 1; i < a.length; i++) {
uint256 temp = a[i];
uint256 j = i;
while ((j >= 1) && (temp < a[j - 1])) {
a[j] = a[j - 1];
j--;
}
a[j] = temp;
}
return (a);
}
}