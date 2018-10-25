from heapq import *
#import queue as q
waiting=[0,0]
nodes=[]

"""functions for waiting heap"""
def empty():
    if len(waiting)<=1:
        return True
    else:
        return False

def put(no):
    waiting.append(no)
    siftup()

def siftup():
    i=len(waiting)-1
    while(i>1 and nodes[waiting[i//2]].shortest>nodes[waiting[i]].shortest):
        (waiting[i],waiting[i//2])=(waiting[i//2],waiting[i])
        i//=2

def getmin():
    if(not empty()):
        minval=waiting[1]
        waiting[1]=waiting[len(waiting)-1]
        del waiting[len(waiting)-1]
        siftdown()
        return minval

def siftdown():
    i=1
    if not empty():
        while((2*i+1<len(waiting) and (nodes[waiting[i]].shortest>nodes[waiting[2*i]].shortest or nodes[waiting[i]].shortest>nodes[waiting[2*i+1]].shortest))):
            if(nodes[waiting[2*i]].shortest>nodes[waiting[2*i+1]].shortest):
                (waiting[i],waiting[2*i+1])=(waiting[2*i+1],waiting[i])
                i=2*i+1
            else:
                (waiting[i],waiting[2*i])=(waiting[2*i],waiting[i])
                i*=2
        if ((2*i<len(waiting)) and (nodes[waiting[i]].shortest>nodes[waiting[2*i]].shortest)):
            (waiting[i],waiting[2*i])=(waiting[2*i],waiting[i])
            i*=2

"""
class for node 
    stores:
        node number
        nodes it is connected to
        weight of edge with each node it is connected to
        shortest path to that node
        if it is visited during BFS
"""
class node:
    def __init__(self,num):
        self.num=num
        self.connected=[]
        self.size=[]
        self.shortest=-1
        self.visited=0
    def connect(self,connected,size):
        self.connected.append(connected)
        self.size.append(size)


#taking inputs

numb=int(input())    
edg=int(input())
for i in range(numb):
    k=node(i)
    nodes.append(k)

for i in range(edg):
    k=str(input())
    a,b,c=k.split()
    a=int(a)
    b=int(b)
    c=int(c)
    nodes[a].connect(b,c)
    nodes[b].connect(a,c)
#

nodes[0].shortest=0

while(not empty()):
    i=getmin()
    for no in range(len(nodes[i].connected)):
        if nodes[nodes[i].connected[no]].visited==0:
            if nodes[nodes[i].connected[no]].shortest==-1 or nodes[nodes[i].connected[no]].shortest>nodes[i].shortest+nodes[i].size[no] :
                nodes[nodes[i].connected[no]].shortest=nodes[i].shortest+nodes[i].size[no]
            put(nodes[i].connected[no]) 
    nodes[i].visited=1

for i in nodes:
    print(i.shortest)