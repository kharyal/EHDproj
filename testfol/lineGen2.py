i=0
for i in range(0,255):
    a=str(i)
    print("if (inp["+a+"]!=0)begin")
    print("    connected[inp["+a+"][3:0]-1]<=connected[inp["+a+"][3:0]-1]+inp["+a+"][7:4]<<count[inp["+a+"][3:0]-1];")
    print("    connected[inp["+a+"][7:4]-1]<=connected[inp["+a+"][7:4]-1]+inp["+a+"][3:0]<<count[inp["+a+"][7:4]-1];")
    print("    weights[inp["+a+"][3:0]-1]<=weights[inp["+a+"][3:0]-1]+inp["+a+"][11:8]<<count[inp["+a+"][3:0]-1];")
    print("    weights[inp["+a+"][7:4]-1]<=weights[inp["+a+"][7:4]-1]+inp["+a+"][11:8]<<count[inp["+a+"][7:4]-1];")
    print("    count[inp["+a+"][3:0]-1]=count[inp["+a+"][3:0]-1]+1;")
    print("    count[inp["+a+"][7:4]-1]=count[inp["+a+"][7:4]-1]+1;")
    print("end")


"""
                    connected[inp[0][3:0]-1]<=connected[inp[0][3:0]-1]+inp[0][7:4]<<count[0];
                    connected[inp[0][7:4]-1]<=connected[inp[0][7:4]-1]+inp[0][3:0]<<count[0];
                    weights[inp[0][3:0]-1]<=weights[inp[0][3:0]-1]+inp[0][11:8]<<count[0];
                    weights[inp[0][7:4]-1]<=weights[inp[0][7:4]-1]+inp[0][11:8]<<count[0];
                    count[0]=count[0]+1;
"""