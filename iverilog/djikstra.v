module top(
    input [3083:0] inp,
    input clk,
    input reset,
    valid,
    ready,
    hold,
    output reg [4096:0] sp,   
    output reg valid_out 
);
    Dijkstra d(.n(inp[3:0]), .e(inp[11:4]), .data(inp[3083:12]), .clk(clk), .reset(reset), .valid(valid), .ready(ready), .hold(hold));
endmodule

module sel_child(input [59:0] con, input [3:0] sel, output [3:0]child);
    assign child={con[3*sel+3], con[3*sel+2], con[3*sel+1], con[3*sel]};
endmodule
module sel_weight(input [59:0] con, input [3:0] sel, output [3:0]wt);
    assign wt={con[3*sel+3], con[3*sel+2], con[3*sel+1], con[3*sel]};
endmodule
/*
    module for Dijkstra:

    input n: number of nodes
    input e: number of edges
    input data: 
                input [11:0] data [0:255],
                12 bit * 256 data units
                [0:3] contain parent node
                [4:7] contain child node
                [8:11] contain weight of edge from parent to child
    output sp:
                output reg [255:0] sp [0:15],
                16 bits * 256 data units
                shortest path of each node from node 0
    other inputs and outputs are self explainatory
*/
module Dijkstra
(
    input [3:0] n,
    input [7:0] e,
    input [3071:0] data,
    input clk,
    reset,
    valid,
    ready,
    hold,

    output reg [4096:0] sp,   
    output reg valid_out
);
    reg [3:0] hp [0:15];     //heap (starts from index 1),(stores weights)
    reg [3:0] parallel_hp [0:15]; //stores corresponding nodes
    reg [31:0] len;           //length of heap at any given time
    reg [31:0] state;        
    reg [3:0] nn;            //number of nodes
    reg [7:0] ee;            //number of edges
    reg [11:0] inp [0:255];  // this is input
    reg [59:0] connected [0:15]; //stores all the nodes connected to (index+1)th node
    reg [59:0] weights [0:15];   //stores the weights of corresponding edges 
    reg [3:0] count [0:15];     //this counts the number of elements filled in 'connected' and 'weights' arrays
    reg [3:0] edgcnt;           //used in making adjecency list
    reg [9:0] shortest [0:15];  //this stores shortest path from source node to (index+1)th node
    reg visited [0:15];         //If the node is visited or not during dijkstra
    reg [3:0] selected;         //node selected from min heap
    wire [3:0] child[0:15];
    wire [3:0] child_wt[0:15];
    reg [31:0] index;
    integer i=0;
    integer j=0;

// instansiating child and weight selection module
sel_child s0(.con(connected[0]), .sel(count[0]), .child(child[0]));
sel_child s1(.con(connected[1]), .sel(count[1]), .child(child[1]));
sel_child s2(.con(connected[2]), .sel(count[2]), .child(child[2]));
sel_child s3(.con(connected[3]), .sel(count[3]), .child(child[3]));
sel_child s4(.con(connected[4]), .sel(count[4]), .child(child[4]));
sel_child s5(.con(connected[5]), .sel(count[5]), .child(child[5]));
sel_child s6(.con(connected[6]), .sel(count[6]), .child(child[6]));
sel_child s7(.con(connected[7]), .sel(count[7]), .child(child[7]));
sel_child s8(.con(connected[8]), .sel(count[8]), .child(child[8]));
sel_child s9(.con(connected[9]), .sel(count[9]), .child(child[9]));
sel_child s10(.con(connected[10]), .sel(count[10]), .child(child[10]));
sel_child s11(.con(connected[11]), .sel(count[11]), .child(child[11]));
sel_child s12(.con(connected[12]), .sel(count[12]), .child(child[12]));
sel_child s13(.con(connected[13]), .sel(count[13]), .child(child[13]));
sel_child s14(.con(connected[14]), .sel(count[14]), .child(child[14]));
sel_child s15(.con(connected[15]), .sel(count[15]), .child(child[15]));

sel_weight w0(.con(weights[0]), .sel(count[0]), .wt(child_wt[0]));
sel_weight w1(.con(weights[1]), .sel(count[1]), .wt(child_wt[1]));
sel_weight w2(.con(weights[2]), .sel(count[2]), .wt(child_wt[2]));
sel_weight w3(.con(weights[3]), .sel(count[3]), .wt(child_wt[3]));
sel_weight w4(.con(weights[4]), .sel(count[4]), .wt(child_wt[4]));
sel_weight w5(.con(weights[5]), .sel(count[5]), .wt(child_wt[5]));
sel_weight w6(.con(weights[6]), .sel(count[6]), .wt(child_wt[6]));
sel_weight w7(.con(weights[7]), .sel(count[7]), .wt(child_wt[7]));
sel_weight w8(.con(weights[8]), .sel(count[8]), .wt(child_wt[8]));
sel_weight w9(.con(weights[9]), .sel(count[9]), .wt(child_wt[9]));
sel_weight w10(.con(weights[10]), .sel(count[10]), .wt(child_wt[10]));
sel_weight w11(.con(weights[11]), .sel(count[11]), .wt(child_wt[11]));
sel_weight w12(.con(weights[12]), .sel(count[12]), .wt(child_wt[12]));
sel_weight w13(.con(weights[13]), .sel(count[13]), .wt(child_wt[13]));
sel_weight w14(.con(weights[14]), .sel(count[14]), .wt(child_wt[14]));
sel_weight w15(.con(weights[15]), .sel(count[15]), .wt(child_wt[15]));



//    integer count [0:15];
    always @(posedge clk or reset==1'b0)
    begin
        if (reset==1'b0) begin          //reset
            for(i=0;i<16;i=i+1) begin
                hp[i]<=4'b000;
                parallel_hp[i]<=4'b000;
                shortest[i]<=10'b1000000000;
                visited[i]<=0;
            end
            valid_out<=1'b0;
            sp<=0;
            len<=1;
            state<=0;
            edgcnt<=4'b0000;
            for(i=0;i<16;i=i+1) begin
                connected[i]<=4'b000;
            end
        end
        else begin
            if(state==0) begin
                nn<=n;
                ee<=e;
                //input copying begin
                inp[0]<=data[11:0];
                inp[1]<=data[23:12];
                inp[2]<=data[35:24];
                inp[3]<=data[47:36];
                inp[4]<=data[59:48];
                inp[5]<=data[71:60];
                inp[6]<=data[83:72];
                inp[7]<=data[95:84];
                inp[8]<=data[107:96];
                inp[9]<=data[119:108];
                inp[10]<=data[131:120];
                inp[11]<=data[143:132];
                inp[12]<=data[155:144];
                inp[13]<=data[167:156];
                inp[14]<=data[179:168];
                inp[15]<=data[191:180];
                inp[16]<=data[203:192];
                inp[17]<=data[215:204];
                inp[18]<=data[227:216];
                inp[19]<=data[239:228];
                inp[20]<=data[251:240];
                inp[21]<=data[263:252];
                inp[22]<=data[275:264];
                inp[23]<=data[287:276];
                inp[24]<=data[299:288];
                inp[25]<=data[311:300];
                inp[26]<=data[323:312];
                inp[27]<=data[335:324];
                inp[28]<=data[347:336];
                inp[29]<=data[359:348];
                inp[30]<=data[371:360];
                inp[31]<=data[383:372];
                inp[32]<=data[395:384];
                inp[33]<=data[407:396];
                inp[34]<=data[419:408];
                inp[35]<=data[431:420];
                inp[36]<=data[443:432];
                inp[37]<=data[455:444];
                inp[38]<=data[467:456];
                inp[39]<=data[479:468];
                inp[40]<=data[491:480];
                inp[41]<=data[503:492];
                inp[42]<=data[515:504];
                inp[43]<=data[527:516];
                inp[44]<=data[539:528];
                inp[45]<=data[551:540];
                inp[46]<=data[563:552];
                inp[47]<=data[575:564];
                inp[48]<=data[587:576];
                inp[49]<=data[599:588];
                inp[50]<=data[611:600];
                inp[51]<=data[623:612];
                inp[52]<=data[635:624];
                inp[53]<=data[647:636];
                inp[54]<=data[659:648];
                inp[55]<=data[671:660];
                inp[56]<=data[683:672];
                inp[57]<=data[695:684];
                inp[58]<=data[707:696];
                inp[59]<=data[719:708];
                inp[60]<=data[731:720];
                inp[61]<=data[743:732];
                inp[62]<=data[755:744];
                inp[63]<=data[767:756];
                inp[64]<=data[779:768];
                inp[65]<=data[791:780];
                inp[66]<=data[803:792];
                inp[67]<=data[815:804];
                inp[68]<=data[827:816];
                inp[69]<=data[839:828];
                inp[70]<=data[851:840];
                inp[71]<=data[863:852];
                inp[72]<=data[875:864];
                inp[73]<=data[887:876];
                inp[74]<=data[899:888];
                inp[75]<=data[911:900];
                inp[76]<=data[923:912];
                inp[77]<=data[935:924];
                inp[78]<=data[947:936];
                inp[79]<=data[959:948];
                inp[80]<=data[971:960];
                inp[81]<=data[983:972];
                inp[82]<=data[995:984];
                inp[83]<=data[1007:996];
                inp[84]<=data[1019:1008];
                inp[85]<=data[1031:1020];
                inp[86]<=data[1043:1032];
                inp[87]<=data[1055:1044];
                inp[88]<=data[1067:1056];
                inp[89]<=data[1079:1068];
                inp[90]<=data[1091:1080];
                inp[91]<=data[1103:1092];
                inp[92]<=data[1115:1104];
                inp[93]<=data[1127:1116];
                inp[94]<=data[1139:1128];
                inp[95]<=data[1151:1140];
                inp[96]<=data[1163:1152];
                inp[97]<=data[1175:1164];
                inp[98]<=data[1187:1176];
                inp[99]<=data[1199:1188];
                inp[100]<=data[1211:1200];
                inp[101]<=data[1223:1212];
                inp[102]<=data[1235:1224];
                inp[103]<=data[1247:1236];
                inp[104]<=data[1259:1248];
                inp[105]<=data[1271:1260];
                inp[106]<=data[1283:1272];
                inp[107]<=data[1295:1284];
                inp[108]<=data[1307:1296];
                inp[109]<=data[1319:1308];
                inp[110]<=data[1331:1320];
                inp[111]<=data[1343:1332];
                inp[112]<=data[1355:1344];
                inp[113]<=data[1367:1356];
                inp[114]<=data[1379:1368];
                inp[115]<=data[1391:1380];
                inp[116]<=data[1403:1392];
                inp[117]<=data[1415:1404];
                inp[118]<=data[1427:1416];
                inp[119]<=data[1439:1428];
                inp[120]<=data[1451:1440];
                inp[121]<=data[1463:1452];
                inp[122]<=data[1475:1464];
                inp[123]<=data[1487:1476];
                inp[124]<=data[1499:1488];
                inp[125]<=data[1511:1500];
                inp[126]<=data[1523:1512];
                inp[127]<=data[1535:1524];
                inp[128]<=data[1547:1536];
                inp[129]<=data[1559:1548];
                inp[130]<=data[1571:1560];
                inp[131]<=data[1583:1572];
                inp[132]<=data[1595:1584];
                inp[133]<=data[1607:1596];
                inp[134]<=data[1619:1608];
                inp[135]<=data[1631:1620];
                inp[136]<=data[1643:1632];
                inp[137]<=data[1655:1644];
                inp[138]<=data[1667:1656];
                inp[139]<=data[1679:1668];
                inp[140]<=data[1691:1680];
                inp[141]<=data[1703:1692];
                inp[142]<=data[1715:1704];
                inp[143]<=data[1727:1716];
                inp[144]<=data[1739:1728];
                inp[145]<=data[1751:1740];
                inp[146]<=data[1763:1752];
                inp[147]<=data[1775:1764];
                inp[148]<=data[1787:1776];
                inp[149]<=data[1799:1788];
                inp[150]<=data[1811:1800];
                inp[151]<=data[1823:1812];
                inp[152]<=data[1835:1824];
                inp[153]<=data[1847:1836];
                inp[154]<=data[1859:1848];
                inp[155]<=data[1871:1860];
                inp[156]<=data[1883:1872];
                inp[157]<=data[1895:1884];
                inp[158]<=data[1907:1896];
                inp[159]<=data[1919:1908];
                inp[160]<=data[1931:1920];
                inp[161]<=data[1943:1932];
                inp[162]<=data[1955:1944];
                inp[163]<=data[1967:1956];
                inp[164]<=data[1979:1968];
                inp[165]<=data[1991:1980];
                inp[166]<=data[2003:1992];
                inp[167]<=data[2015:2004];
                inp[168]<=data[2027:2016];
                inp[169]<=data[2039:2028];
                inp[170]<=data[2051:2040];
                inp[171]<=data[2063:2052];
                inp[172]<=data[2075:2064];
                inp[173]<=data[2087:2076];
                inp[174]<=data[2099:2088];
                inp[175]<=data[2111:2100];
                inp[176]<=data[2123:2112];
                inp[177]<=data[2135:2124];
                inp[178]<=data[2147:2136];
                inp[179]<=data[2159:2148];
                inp[180]<=data[2171:2160];
                inp[181]<=data[2183:2172];
                inp[182]<=data[2195:2184];
                inp[183]<=data[2207:2196];
                inp[184]<=data[2219:2208];
                inp[185]<=data[2231:2220];
                inp[186]<=data[2243:2232];
                inp[187]<=data[2255:2244];
                inp[188]<=data[2267:2256];
                inp[189]<=data[2279:2268];
                inp[190]<=data[2291:2280];
                inp[191]<=data[2303:2292];
                inp[192]<=data[2315:2304];
                inp[193]<=data[2327:2316];
                inp[194]<=data[2339:2328];
                inp[195]<=data[2351:2340];
                inp[196]<=data[2363:2352];
                inp[197]<=data[2375:2364];
                inp[198]<=data[2387:2376];
                inp[199]<=data[2399:2388];
                inp[200]<=data[2411:2400];
                inp[201]<=data[2423:2412];
                inp[202]<=data[2435:2424];
                inp[203]<=data[2447:2436];
                inp[204]<=data[2459:2448];
                inp[205]<=data[2471:2460];
                inp[206]<=data[2483:2472];
                inp[207]<=data[2495:2484];
                inp[208]<=data[2507:2496];
                inp[209]<=data[2519:2508];
                inp[210]<=data[2531:2520];
                inp[211]<=data[2543:2532];
                inp[212]<=data[2555:2544];
                inp[213]<=data[2567:2556];
                inp[214]<=data[2579:2568];
                inp[215]<=data[2591:2580];
                inp[216]<=data[2603:2592];
                inp[217]<=data[2615:2604];
                inp[218]<=data[2627:2616];
                inp[219]<=data[2639:2628];
                inp[220]<=data[2651:2640];
                inp[221]<=data[2663:2652];
                inp[222]<=data[2675:2664];
                inp[223]<=data[2687:2676];
                inp[224]<=data[2699:2688];
                inp[225]<=data[2711:2700];
                inp[226]<=data[2723:2712];
                inp[227]<=data[2735:2724];
                inp[228]<=data[2747:2736];
                inp[229]<=data[2759:2748];
                inp[230]<=data[2771:2760];
                inp[231]<=data[2783:2772];
                inp[232]<=data[2795:2784];
                inp[233]<=data[2807:2796];
                inp[234]<=data[2819:2808];
                inp[235]<=data[2831:2820];
                inp[236]<=data[2843:2832];
                inp[237]<=data[2855:2844];
                inp[238]<=data[2867:2856];
                inp[239]<=data[2879:2868];
                inp[240]<=data[2891:2880];
                inp[241]<=data[2903:2892];
                inp[242]<=data[2915:2904];
                inp[243]<=data[2927:2916];
                inp[244]<=data[2939:2928];
                inp[245]<=data[2951:2940];
                inp[246]<=data[2963:2952];
                inp[247]<=data[2975:2964];
                inp[248]<=data[2987:2976];
                inp[249]<=data[2999:2988];
                inp[250]<=data[3011:3000];
                inp[251]<=data[3023:3012];
                inp[252]<=data[3035:3024];
                inp[253]<=data[3047:3036];
                inp[254]<=data[3059:3048];
                inp[255]<=data[3071:3060];
                //input copying end
                state=2;
            end
            else if(state==2) begin   //state for making adjecency list
            //start of making adjecency list
                if (edgcnt<ee)begin
                    connected[inp[edgcnt][3:0]-1]<=connected[inp[edgcnt][3:0]-1]+inp[edgcnt][7:4]<<3*count[inp[edgcnt][3:0]-1];
                    connected[inp[edgcnt][7:4]-1]<=connected[inp[edgcnt][7:4]-1]+inp[edgcnt][3:0]<<3*count[inp[edgcnt][7:4]-1];
                    weights[inp[edgcnt][3:0]-1]<=weights[inp[edgcnt][3:0]-1]+inp[edgcnt][11:8]<<4*count[inp[edgcnt][3:0]-1];
                    weights[inp[edgcnt][7:4]-1]<=weights[inp[edgcnt][7:4]-1]+inp[edgcnt][11:8]<<4*count[inp[edgcnt][7:4]-1];
                    count[inp[edgcnt][3:0]-1]<=count[inp[edgcnt][3:0]-1]+1;
                    count[inp[edgcnt][7:4]-1]<=count[inp[edgcnt][7:4]-1]+1;
                    edgcnt<=edgcnt+1;
                end
            //end of making adjecency list
                else begin
                    shortest[0]<=0;    
                    hp[1]<=0;
                    parallel_hp[1]<=1;
                    state<=31;
                end
            end
            
            else if(state==31 || state==32) begin  //yo yo dijkstra
                if (len>0) begin
                    if(state==31) begin           //for selecting min element from min heap
                        selected<=parallel_hp[1]-4'b0001;
                        state<=41;
                    end
                    else begin
                        if(count[selected]>=0) begin
                            if(visited[child[selected]-1]==0)begin
                                if(shortest[child[selected]-1]>shortest[selected]+child_wt[selected])begin
                                    shortest[child[selected]-1]<=shortest[selected]+child_wt[selected];
                                    state<=4;
                                end
                            end
                            else begin
                                count[selected]<=count[selected]-1;
                            end 
                        end
                    end
                end
                else
                    state<=5;
            end
            
            else if(state==41||state==42||state==43) begin  //handles heap
                if(state==41) begin
                    hp[1]<=hp[len];
                    parallel_hp[1]<=parallel_hp[len];
                    index<=1;
                    state<=42;
                end
                else if(state<=42)begin
                    if(2*index+1<len && (hp[index]>hp[2*index+1] || hp[index]>hp[2*index]))begin
                        if(hp[2*index+1]>hp[2*index])begin
                            hp[index]<=hp[2*index];
                            parallel_hp[index]<=parallel_hp[2*index];
                            hp[2*index]<=hp[index];
                            parallel_hp[2*index]<=parallel_hp[index];
                            index<=2*index;
                        end
                        else begin
                            hp[index]<=hp[2*index+1];
                            parallel_hp[index]<=parallel_hp[2*index+1];
                            hp[2*index+1]<=hp[index];
                            parallel_hp[2*index+1]<=parallel_hp[index];
                            index<=2*index+1;
                        end
                    end
                    else if(2*index<len && hp[index]>hp[2*index])begin
                        hp[index]<=hp[2*index];
                        parallel_hp[index]<=parallel_hp[2*index];
                        hp[2*index]<=hp[index];
                        parallel_hp[2*index]<=parallel_hp[index];
                        index<=2*index;
                    end
                    else
                        state<=32;
                end
                if(state==43) begin
                
                end            
            end
            
            if(state==5)begin   //output state

            end
        end 
    end  
endmodule