#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr  5 14:36:18 2017

@author: henryleemr
"""

import matplotlib.pyplot as plt
import numpy as np

## Do this in a separate python interpreter session, since you only have to do it once
#import nltk
#
## Do this in your ipython notebook or analysis script
#from nltk.tokenize import word_tokenize
#
#
#
#example = ['Mary had a little lamb' , 
#            'Jack went up the hill' , 
#            'Jill followed suit' ,    
#            'i woke up suddenly' ,
#            'it was a really bad dream...']
#tokenized_sents = [word_tokenize(i) for i in example]
#
#for i in tokenized_sents:
#    print (i)

class IntContainer(object):
    def __init__(self, i):
        self.i = int(i)
        
    def add_one(self):
        self.i += 1
        
ic = IntContainer(2)
ic.add_one()
print(ic.i)


class Cal(object):
    pi = 3.142
    
    def __init__(self, radius, boom):
        self.radius = radius
        self.boom = boom
        
    def area(self, radius):
        return self.pi * (self.radius ** 2) + radius + self.boom
    
    
a = Cal(10, 20)
print (a.area(100))


class Plot(object):
    q = [1,5,0,10]
    g = 30
    
    def __init__(self, x, y):
        self.x = x
        self.y = y
          
    def add(self, added):
         return self.x + added + self.q 
    
    def curve(self, y):
        return (y ** 2) + self.g
        
     
input1 = [1,2,3,4]
input2 = 0.02

inputs = Plot(input1, input2)

a = 2
b = 10
added = [1,2,3,4,5,6,7,8]

t1 = np.arange(a, b, (b - a)/len(inputs.add(added)))
x = inputs.add(added)

t2 = [1,2,3,4,5,6,7,8]
y = [inputs.curve(t2[i - 1]) for i in t2]

plt.plot(t1, x, t2, y, linewidth=2.0, color='r')
plt.ylabel('y-axis')
plt.xlabel('x-axis')
plt.show()



