# Crab game

With only the first part I thought that concatenating lists and a bit of math would be enough (Spoiler alert Nope!). To do so, I implemented it in python and the implementation can be found in `main_23.py`. In the code, you can also find an attempt to store the positions in an array of size n but according to my estimation it would take 23 days to run. The python code is not clean as I did not take the time for it.

It turned out that the best structure to implement it was a circular linked list were for each node (Cup structure) in the implementation you store the value of the current cup, the pointer of the next cup and the pointer to the cup with value n-1. This implementation can be find in `main.c`. My final solution takes around 3 seconds to run:

```bash
The answer of part one is: 62934785                                                                                   
The answer of part two is: 875050 * 792708                                                                            
real    0m2,622s
user    0m2,292s
sys     0m0,328s
```


# Authors
-[Robin Camarasa](https://github.com/RobinCamarasa)
