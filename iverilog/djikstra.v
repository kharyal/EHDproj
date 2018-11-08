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
module Djikstra
(
    input [3:0] n,
    input [7:0] e,
    input [3071:0] data ,
    input clk,
    reset,
    valid,
    ready,
    hold,

    output reg [4096:0] sp,   
    output reg valid_out
);
    reg [3:0] hp [0:15];     //heap
    reg [3:0] len;           //length of heap at any given time
    reg [31:0] state;        
    reg [3:0] nn;            //number of nodes
    reg [7:0] ee;            //number of edges
    reg [11:0] inp [0:255];  // this is input
    reg [3:0] connected [0:15]; 
    reg [3:0] weights [0:15];
    //reg [3:0] count [0:15];     //this counts the number of elements filled in 'connected' and 'weights' arrays
    integer i=0;
    integer j=0;
    integer count [0:15];
    always @(posedge clk or reset==1'b0)
    begin
        if (reset==1'b0) begin          //reset
            for(i=0;i<16;i=i+1) begin
                hp[i]<=3'b000;
            end
            valid_out<=1'b0;
            sp<=0;
            len<=0;
            state<=0;
        end
        else begin
            if(state==0) begin
                nn<=n;
                ee<=e;
                //input copying begin (ends at line 312 or something)
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
            if(state==2) begin
                if (inp[0]!=0)begin
    connected[inp[0][3:0]-1]<=connected[inp[0][3:0]-1]+inp[0][7:4]<<count[inp[0][3:0]-1];
    connected[inp[0][7:4]-1]<=connected[inp[0][7:4]-1]+inp[0][3:0]<<count[inp[0][7:4]-1];
    weights[inp[0][3:0]-1]<=weights[inp[0][3:0]-1]+inp[0][11:8]<<count[inp[0][3:0]-1];
    weights[inp[0][7:4]-1]<=weights[inp[0][7:4]-1]+inp[0][11:8]<<count[inp[0][7:4]-1];
    count[inp[0][3:0]-1]=count[inp[0][3:0]-1]+1;
    count[inp[0][7:4]-1]=count[inp[0][7:4]-1]+1;
end
if (inp[1]!=0)begin
    connected[inp[1][3:0]-1]<=connected[inp[1][3:0]-1]+inp[1][7:4]<<count[inp[1][3:0]-1];
    connected[inp[1][7:4]-1]<=connected[inp[1][7:4]-1]+inp[1][3:0]<<count[inp[1][7:4]-1];
    weights[inp[1][3:0]-1]<=weights[inp[1][3:0]-1]+inp[1][11:8]<<count[inp[1][3:0]-1];
    weights[inp[1][7:4]-1]<=weights[inp[1][7:4]-1]+inp[1][11:8]<<count[inp[1][7:4]-1];
    count[inp[1][3:0]-1]=count[inp[1][3:0]-1]+1;
    count[inp[1][7:4]-1]=count[inp[1][7:4]-1]+1;
end
if (inp[2]!=0)begin
    connected[inp[2][3:0]-1]<=connected[inp[2][3:0]-1]+inp[2][7:4]<<count[inp[2][3:0]-1];
    connected[inp[2][7:4]-1]<=connected[inp[2][7:4]-1]+inp[2][3:0]<<count[inp[2][7:4]-1];
    weights[inp[2][3:0]-1]<=weights[inp[2][3:0]-1]+inp[2][11:8]<<count[inp[2][3:0]-1];
    weights[inp[2][7:4]-1]<=weights[inp[2][7:4]-1]+inp[2][11:8]<<count[inp[2][7:4]-1];
    count[inp[2][3:0]-1]=count[inp[2][3:0]-1]+1;
    count[inp[2][7:4]-1]=count[inp[2][7:4]-1]+1;
end
if (inp[3]!=0)begin
    connected[inp[3][3:0]-1]<=connected[inp[3][3:0]-1]+inp[3][7:4]<<count[inp[3][3:0]-1];
    connected[inp[3][7:4]-1]<=connected[inp[3][7:4]-1]+inp[3][3:0]<<count[inp[3][7:4]-1];
    weights[inp[3][3:0]-1]<=weights[inp[3][3:0]-1]+inp[3][11:8]<<count[inp[3][3:0]-1];
    weights[inp[3][7:4]-1]<=weights[inp[3][7:4]-1]+inp[3][11:8]<<count[inp[3][7:4]-1];
    count[inp[3][3:0]-1]=count[inp[3][3:0]-1]+1;
    count[inp[3][7:4]-1]=count[inp[3][7:4]-1]+1;
end
if (inp[4]!=0)begin
    connected[inp[4][3:0]-1]<=connected[inp[4][3:0]-1]+inp[4][7:4]<<count[inp[4][3:0]-1];
    connected[inp[4][7:4]-1]<=connected[inp[4][7:4]-1]+inp[4][3:0]<<count[inp[4][7:4]-1];
    weights[inp[4][3:0]-1]<=weights[inp[4][3:0]-1]+inp[4][11:8]<<count[inp[4][3:0]-1];
    weights[inp[4][7:4]-1]<=weights[inp[4][7:4]-1]+inp[4][11:8]<<count[inp[4][7:4]-1];
    count[inp[4][3:0]-1]=count[inp[4][3:0]-1]+1;
    count[inp[4][7:4]-1]=count[inp[4][7:4]-1]+1;
end
if (inp[5]!=0)begin
    connected[inp[5][3:0]-1]<=connected[inp[5][3:0]-1]+inp[5][7:4]<<count[inp[5][3:0]-1];
    connected[inp[5][7:4]-1]<=connected[inp[5][7:4]-1]+inp[5][3:0]<<count[inp[5][7:4]-1];
    weights[inp[5][3:0]-1]<=weights[inp[5][3:0]-1]+inp[5][11:8]<<count[inp[5][3:0]-1];
    weights[inp[5][7:4]-1]<=weights[inp[5][7:4]-1]+inp[5][11:8]<<count[inp[5][7:4]-1];
    count[inp[5][3:0]-1]=count[inp[5][3:0]-1]+1;
    count[inp[5][7:4]-1]=count[inp[5][7:4]-1]+1;
end
if (inp[6]!=0)begin
    connected[inp[6][3:0]-1]<=connected[inp[6][3:0]-1]+inp[6][7:4]<<count[inp[6][3:0]-1];
    connected[inp[6][7:4]-1]<=connected[inp[6][7:4]-1]+inp[6][3:0]<<count[inp[6][7:4]-1];
    weights[inp[6][3:0]-1]<=weights[inp[6][3:0]-1]+inp[6][11:8]<<count[inp[6][3:0]-1];
    weights[inp[6][7:4]-1]<=weights[inp[6][7:4]-1]+inp[6][11:8]<<count[inp[6][7:4]-1];
    count[inp[6][3:0]-1]=count[inp[6][3:0]-1]+1;
    count[inp[6][7:4]-1]=count[inp[6][7:4]-1]+1;
end
if (inp[7]!=0)begin
    connected[inp[7][3:0]-1]<=connected[inp[7][3:0]-1]+inp[7][7:4]<<count[inp[7][3:0]-1];
    connected[inp[7][7:4]-1]<=connected[inp[7][7:4]-1]+inp[7][3:0]<<count[inp[7][7:4]-1];
    weights[inp[7][3:0]-1]<=weights[inp[7][3:0]-1]+inp[7][11:8]<<count[inp[7][3:0]-1];
    weights[inp[7][7:4]-1]<=weights[inp[7][7:4]-1]+inp[7][11:8]<<count[inp[7][7:4]-1];
    count[inp[7][3:0]-1]=count[inp[7][3:0]-1]+1;
    count[inp[7][7:4]-1]=count[inp[7][7:4]-1]+1;
end
if (inp[8]!=0)begin
    connected[inp[8][3:0]-1]<=connected[inp[8][3:0]-1]+inp[8][7:4]<<count[inp[8][3:0]-1];
    connected[inp[8][7:4]-1]<=connected[inp[8][7:4]-1]+inp[8][3:0]<<count[inp[8][7:4]-1];
    weights[inp[8][3:0]-1]<=weights[inp[8][3:0]-1]+inp[8][11:8]<<count[inp[8][3:0]-1];
    weights[inp[8][7:4]-1]<=weights[inp[8][7:4]-1]+inp[8][11:8]<<count[inp[8][7:4]-1];
    count[inp[8][3:0]-1]=count[inp[8][3:0]-1]+1;
    count[inp[8][7:4]-1]=count[inp[8][7:4]-1]+1;
end
if (inp[9]!=0)begin
    connected[inp[9][3:0]-1]<=connected[inp[9][3:0]-1]+inp[9][7:4]<<count[inp[9][3:0]-1];
    connected[inp[9][7:4]-1]<=connected[inp[9][7:4]-1]+inp[9][3:0]<<count[inp[9][7:4]-1];
    weights[inp[9][3:0]-1]<=weights[inp[9][3:0]-1]+inp[9][11:8]<<count[inp[9][3:0]-1];
    weights[inp[9][7:4]-1]<=weights[inp[9][7:4]-1]+inp[9][11:8]<<count[inp[9][7:4]-1];
    count[inp[9][3:0]-1]=count[inp[9][3:0]-1]+1;
    count[inp[9][7:4]-1]=count[inp[9][7:4]-1]+1;
end
if (inp[10]!=0)begin
    connected[inp[10][3:0]-1]<=connected[inp[10][3:0]-1]+inp[10][7:4]<<count[inp[10][3:0]-1];
    connected[inp[10][7:4]-1]<=connected[inp[10][7:4]-1]+inp[10][3:0]<<count[inp[10][7:4]-1];
    weights[inp[10][3:0]-1]<=weights[inp[10][3:0]-1]+inp[10][11:8]<<count[inp[10][3:0]-1];
    weights[inp[10][7:4]-1]<=weights[inp[10][7:4]-1]+inp[10][11:8]<<count[inp[10][7:4]-1];
    count[inp[10][3:0]-1]=count[inp[10][3:0]-1]+1;
    count[inp[10][7:4]-1]=count[inp[10][7:4]-1]+1;
end
if (inp[11]!=0)begin
    connected[inp[11][3:0]-1]<=connected[inp[11][3:0]-1]+inp[11][7:4]<<count[inp[11][3:0]-1];
    connected[inp[11][7:4]-1]<=connected[inp[11][7:4]-1]+inp[11][3:0]<<count[inp[11][7:4]-1];
    weights[inp[11][3:0]-1]<=weights[inp[11][3:0]-1]+inp[11][11:8]<<count[inp[11][3:0]-1];
    weights[inp[11][7:4]-1]<=weights[inp[11][7:4]-1]+inp[11][11:8]<<count[inp[11][7:4]-1];
    count[inp[11][3:0]-1]=count[inp[11][3:0]-1]+1;
    count[inp[11][7:4]-1]=count[inp[11][7:4]-1]+1;
end
if (inp[12]!=0)begin
    connected[inp[12][3:0]-1]<=connected[inp[12][3:0]-1]+inp[12][7:4]<<count[inp[12][3:0]-1];
    connected[inp[12][7:4]-1]<=connected[inp[12][7:4]-1]+inp[12][3:0]<<count[inp[12][7:4]-1];
    weights[inp[12][3:0]-1]<=weights[inp[12][3:0]-1]+inp[12][11:8]<<count[inp[12][3:0]-1];
    weights[inp[12][7:4]-1]<=weights[inp[12][7:4]-1]+inp[12][11:8]<<count[inp[12][7:4]-1];
    count[inp[12][3:0]-1]=count[inp[12][3:0]-1]+1;
    count[inp[12][7:4]-1]=count[inp[12][7:4]-1]+1;
end
if (inp[13]!=0)begin
    connected[inp[13][3:0]-1]<=connected[inp[13][3:0]-1]+inp[13][7:4]<<count[inp[13][3:0]-1];
    connected[inp[13][7:4]-1]<=connected[inp[13][7:4]-1]+inp[13][3:0]<<count[inp[13][7:4]-1];
    weights[inp[13][3:0]-1]<=weights[inp[13][3:0]-1]+inp[13][11:8]<<count[inp[13][3:0]-1];
    weights[inp[13][7:4]-1]<=weights[inp[13][7:4]-1]+inp[13][11:8]<<count[inp[13][7:4]-1];
    count[inp[13][3:0]-1]=count[inp[13][3:0]-1]+1;
    count[inp[13][7:4]-1]=count[inp[13][7:4]-1]+1;
end
if (inp[14]!=0)begin
    connected[inp[14][3:0]-1]<=connected[inp[14][3:0]-1]+inp[14][7:4]<<count[inp[14][3:0]-1];
    connected[inp[14][7:4]-1]<=connected[inp[14][7:4]-1]+inp[14][3:0]<<count[inp[14][7:4]-1];
    weights[inp[14][3:0]-1]<=weights[inp[14][3:0]-1]+inp[14][11:8]<<count[inp[14][3:0]-1];
    weights[inp[14][7:4]-1]<=weights[inp[14][7:4]-1]+inp[14][11:8]<<count[inp[14][7:4]-1];
    count[inp[14][3:0]-1]=count[inp[14][3:0]-1]+1;
    count[inp[14][7:4]-1]=count[inp[14][7:4]-1]+1;
end
if (inp[15]!=0)begin
    connected[inp[15][3:0]-1]<=connected[inp[15][3:0]-1]+inp[15][7:4]<<count[inp[15][3:0]-1];
    connected[inp[15][7:4]-1]<=connected[inp[15][7:4]-1]+inp[15][3:0]<<count[inp[15][7:4]-1];
    weights[inp[15][3:0]-1]<=weights[inp[15][3:0]-1]+inp[15][11:8]<<count[inp[15][3:0]-1];
    weights[inp[15][7:4]-1]<=weights[inp[15][7:4]-1]+inp[15][11:8]<<count[inp[15][7:4]-1];
    count[inp[15][3:0]-1]=count[inp[15][3:0]-1]+1;
    count[inp[15][7:4]-1]=count[inp[15][7:4]-1]+1;
end
if (inp[16]!=0)begin
    connected[inp[16][3:0]-1]<=connected[inp[16][3:0]-1]+inp[16][7:4]<<count[inp[16][3:0]-1];
    connected[inp[16][7:4]-1]<=connected[inp[16][7:4]-1]+inp[16][3:0]<<count[inp[16][7:4]-1];
    weights[inp[16][3:0]-1]<=weights[inp[16][3:0]-1]+inp[16][11:8]<<count[inp[16][3:0]-1];
    weights[inp[16][7:4]-1]<=weights[inp[16][7:4]-1]+inp[16][11:8]<<count[inp[16][7:4]-1];
    count[inp[16][3:0]-1]=count[inp[16][3:0]-1]+1;
    count[inp[16][7:4]-1]=count[inp[16][7:4]-1]+1;
end
if (inp[17]!=0)begin
    connected[inp[17][3:0]-1]<=connected[inp[17][3:0]-1]+inp[17][7:4]<<count[inp[17][3:0]-1];
    connected[inp[17][7:4]-1]<=connected[inp[17][7:4]-1]+inp[17][3:0]<<count[inp[17][7:4]-1];
    weights[inp[17][3:0]-1]<=weights[inp[17][3:0]-1]+inp[17][11:8]<<count[inp[17][3:0]-1];
    weights[inp[17][7:4]-1]<=weights[inp[17][7:4]-1]+inp[17][11:8]<<count[inp[17][7:4]-1];
    count[inp[17][3:0]-1]=count[inp[17][3:0]-1]+1;
    count[inp[17][7:4]-1]=count[inp[17][7:4]-1]+1;
end
if (inp[18]!=0)begin
    connected[inp[18][3:0]-1]<=connected[inp[18][3:0]-1]+inp[18][7:4]<<count[inp[18][3:0]-1];
    connected[inp[18][7:4]-1]<=connected[inp[18][7:4]-1]+inp[18][3:0]<<count[inp[18][7:4]-1];
    weights[inp[18][3:0]-1]<=weights[inp[18][3:0]-1]+inp[18][11:8]<<count[inp[18][3:0]-1];
    weights[inp[18][7:4]-1]<=weights[inp[18][7:4]-1]+inp[18][11:8]<<count[inp[18][7:4]-1];
    count[inp[18][3:0]-1]=count[inp[18][3:0]-1]+1;
    count[inp[18][7:4]-1]=count[inp[18][7:4]-1]+1;
end
if (inp[19]!=0)begin
    connected[inp[19][3:0]-1]<=connected[inp[19][3:0]-1]+inp[19][7:4]<<count[inp[19][3:0]-1];
    connected[inp[19][7:4]-1]<=connected[inp[19][7:4]-1]+inp[19][3:0]<<count[inp[19][7:4]-1];
    weights[inp[19][3:0]-1]<=weights[inp[19][3:0]-1]+inp[19][11:8]<<count[inp[19][3:0]-1];
    weights[inp[19][7:4]-1]<=weights[inp[19][7:4]-1]+inp[19][11:8]<<count[inp[19][7:4]-1];
    count[inp[19][3:0]-1]=count[inp[19][3:0]-1]+1;
    count[inp[19][7:4]-1]=count[inp[19][7:4]-1]+1;
end
if (inp[20]!=0)begin
    connected[inp[20][3:0]-1]<=connected[inp[20][3:0]-1]+inp[20][7:4]<<count[inp[20][3:0]-1];
    connected[inp[20][7:4]-1]<=connected[inp[20][7:4]-1]+inp[20][3:0]<<count[inp[20][7:4]-1];
    weights[inp[20][3:0]-1]<=weights[inp[20][3:0]-1]+inp[20][11:8]<<count[inp[20][3:0]-1];
    weights[inp[20][7:4]-1]<=weights[inp[20][7:4]-1]+inp[20][11:8]<<count[inp[20][7:4]-1];
    count[inp[20][3:0]-1]=count[inp[20][3:0]-1]+1;
    count[inp[20][7:4]-1]=count[inp[20][7:4]-1]+1;
end
if (inp[21]!=0)begin
    connected[inp[21][3:0]-1]<=connected[inp[21][3:0]-1]+inp[21][7:4]<<count[inp[21][3:0]-1];
    connected[inp[21][7:4]-1]<=connected[inp[21][7:4]-1]+inp[21][3:0]<<count[inp[21][7:4]-1];
    weights[inp[21][3:0]-1]<=weights[inp[21][3:0]-1]+inp[21][11:8]<<count[inp[21][3:0]-1];
    weights[inp[21][7:4]-1]<=weights[inp[21][7:4]-1]+inp[21][11:8]<<count[inp[21][7:4]-1];
    count[inp[21][3:0]-1]=count[inp[21][3:0]-1]+1;
    count[inp[21][7:4]-1]=count[inp[21][7:4]-1]+1;
end
if (inp[22]!=0)begin
    connected[inp[22][3:0]-1]<=connected[inp[22][3:0]-1]+inp[22][7:4]<<count[inp[22][3:0]-1];
    connected[inp[22][7:4]-1]<=connected[inp[22][7:4]-1]+inp[22][3:0]<<count[inp[22][7:4]-1];
    weights[inp[22][3:0]-1]<=weights[inp[22][3:0]-1]+inp[22][11:8]<<count[inp[22][3:0]-1];
    weights[inp[22][7:4]-1]<=weights[inp[22][7:4]-1]+inp[22][11:8]<<count[inp[22][7:4]-1];
    count[inp[22][3:0]-1]=count[inp[22][3:0]-1]+1;
    count[inp[22][7:4]-1]=count[inp[22][7:4]-1]+1;
end
if (inp[23]!=0)begin
    connected[inp[23][3:0]-1]<=connected[inp[23][3:0]-1]+inp[23][7:4]<<count[inp[23][3:0]-1];
    connected[inp[23][7:4]-1]<=connected[inp[23][7:4]-1]+inp[23][3:0]<<count[inp[23][7:4]-1];
    weights[inp[23][3:0]-1]<=weights[inp[23][3:0]-1]+inp[23][11:8]<<count[inp[23][3:0]-1];
    weights[inp[23][7:4]-1]<=weights[inp[23][7:4]-1]+inp[23][11:8]<<count[inp[23][7:4]-1];
    count[inp[23][3:0]-1]=count[inp[23][3:0]-1]+1;
    count[inp[23][7:4]-1]=count[inp[23][7:4]-1]+1;
end
if (inp[24]!=0)begin
    connected[inp[24][3:0]-1]<=connected[inp[24][3:0]-1]+inp[24][7:4]<<count[inp[24][3:0]-1];
    connected[inp[24][7:4]-1]<=connected[inp[24][7:4]-1]+inp[24][3:0]<<count[inp[24][7:4]-1];
    weights[inp[24][3:0]-1]<=weights[inp[24][3:0]-1]+inp[24][11:8]<<count[inp[24][3:0]-1];
    weights[inp[24][7:4]-1]<=weights[inp[24][7:4]-1]+inp[24][11:8]<<count[inp[24][7:4]-1];
    count[inp[24][3:0]-1]=count[inp[24][3:0]-1]+1;
    count[inp[24][7:4]-1]=count[inp[24][7:4]-1]+1;
end
if (inp[25]!=0)begin
    connected[inp[25][3:0]-1]<=connected[inp[25][3:0]-1]+inp[25][7:4]<<count[inp[25][3:0]-1];
    connected[inp[25][7:4]-1]<=connected[inp[25][7:4]-1]+inp[25][3:0]<<count[inp[25][7:4]-1];
    weights[inp[25][3:0]-1]<=weights[inp[25][3:0]-1]+inp[25][11:8]<<count[inp[25][3:0]-1];
    weights[inp[25][7:4]-1]<=weights[inp[25][7:4]-1]+inp[25][11:8]<<count[inp[25][7:4]-1];
    count[inp[25][3:0]-1]=count[inp[25][3:0]-1]+1;
    count[inp[25][7:4]-1]=count[inp[25][7:4]-1]+1;
end
if (inp[26]!=0)begin
    connected[inp[26][3:0]-1]<=connected[inp[26][3:0]-1]+inp[26][7:4]<<count[inp[26][3:0]-1];
    connected[inp[26][7:4]-1]<=connected[inp[26][7:4]-1]+inp[26][3:0]<<count[inp[26][7:4]-1];
    weights[inp[26][3:0]-1]<=weights[inp[26][3:0]-1]+inp[26][11:8]<<count[inp[26][3:0]-1];
    weights[inp[26][7:4]-1]<=weights[inp[26][7:4]-1]+inp[26][11:8]<<count[inp[26][7:4]-1];
    count[inp[26][3:0]-1]=count[inp[26][3:0]-1]+1;
    count[inp[26][7:4]-1]=count[inp[26][7:4]-1]+1;
end
if (inp[27]!=0)begin
    connected[inp[27][3:0]-1]<=connected[inp[27][3:0]-1]+inp[27][7:4]<<count[inp[27][3:0]-1];
    connected[inp[27][7:4]-1]<=connected[inp[27][7:4]-1]+inp[27][3:0]<<count[inp[27][7:4]-1];
    weights[inp[27][3:0]-1]<=weights[inp[27][3:0]-1]+inp[27][11:8]<<count[inp[27][3:0]-1];
    weights[inp[27][7:4]-1]<=weights[inp[27][7:4]-1]+inp[27][11:8]<<count[inp[27][7:4]-1];
    count[inp[27][3:0]-1]=count[inp[27][3:0]-1]+1;
    count[inp[27][7:4]-1]=count[inp[27][7:4]-1]+1;
end
if (inp[28]!=0)begin
    connected[inp[28][3:0]-1]<=connected[inp[28][3:0]-1]+inp[28][7:4]<<count[inp[28][3:0]-1];
    connected[inp[28][7:4]-1]<=connected[inp[28][7:4]-1]+inp[28][3:0]<<count[inp[28][7:4]-1];
    weights[inp[28][3:0]-1]<=weights[inp[28][3:0]-1]+inp[28][11:8]<<count[inp[28][3:0]-1];
    weights[inp[28][7:4]-1]<=weights[inp[28][7:4]-1]+inp[28][11:8]<<count[inp[28][7:4]-1];
    count[inp[28][3:0]-1]=count[inp[28][3:0]-1]+1;
    count[inp[28][7:4]-1]=count[inp[28][7:4]-1]+1;
end
if (inp[29]!=0)begin
    connected[inp[29][3:0]-1]<=connected[inp[29][3:0]-1]+inp[29][7:4]<<count[inp[29][3:0]-1];
    connected[inp[29][7:4]-1]<=connected[inp[29][7:4]-1]+inp[29][3:0]<<count[inp[29][7:4]-1];
    weights[inp[29][3:0]-1]<=weights[inp[29][3:0]-1]+inp[29][11:8]<<count[inp[29][3:0]-1];
    weights[inp[29][7:4]-1]<=weights[inp[29][7:4]-1]+inp[29][11:8]<<count[inp[29][7:4]-1];
    count[inp[29][3:0]-1]=count[inp[29][3:0]-1]+1;
    count[inp[29][7:4]-1]=count[inp[29][7:4]-1]+1;
end
if (inp[30]!=0)begin
    connected[inp[30][3:0]-1]<=connected[inp[30][3:0]-1]+inp[30][7:4]<<count[inp[30][3:0]-1];
    connected[inp[30][7:4]-1]<=connected[inp[30][7:4]-1]+inp[30][3:0]<<count[inp[30][7:4]-1];
    weights[inp[30][3:0]-1]<=weights[inp[30][3:0]-1]+inp[30][11:8]<<count[inp[30][3:0]-1];
    weights[inp[30][7:4]-1]<=weights[inp[30][7:4]-1]+inp[30][11:8]<<count[inp[30][7:4]-1];
    count[inp[30][3:0]-1]=count[inp[30][3:0]-1]+1;
    count[inp[30][7:4]-1]=count[inp[30][7:4]-1]+1;
end
if (inp[31]!=0)begin
    connected[inp[31][3:0]-1]<=connected[inp[31][3:0]-1]+inp[31][7:4]<<count[inp[31][3:0]-1];
    connected[inp[31][7:4]-1]<=connected[inp[31][7:4]-1]+inp[31][3:0]<<count[inp[31][7:4]-1];
    weights[inp[31][3:0]-1]<=weights[inp[31][3:0]-1]+inp[31][11:8]<<count[inp[31][3:0]-1];
    weights[inp[31][7:4]-1]<=weights[inp[31][7:4]-1]+inp[31][11:8]<<count[inp[31][7:4]-1];
    count[inp[31][3:0]-1]=count[inp[31][3:0]-1]+1;
    count[inp[31][7:4]-1]=count[inp[31][7:4]-1]+1;
end
if (inp[32]!=0)begin
    connected[inp[32][3:0]-1]<=connected[inp[32][3:0]-1]+inp[32][7:4]<<count[inp[32][3:0]-1];
    connected[inp[32][7:4]-1]<=connected[inp[32][7:4]-1]+inp[32][3:0]<<count[inp[32][7:4]-1];
    weights[inp[32][3:0]-1]<=weights[inp[32][3:0]-1]+inp[32][11:8]<<count[inp[32][3:0]-1];
    weights[inp[32][7:4]-1]<=weights[inp[32][7:4]-1]+inp[32][11:8]<<count[inp[32][7:4]-1];
    count[inp[32][3:0]-1]=count[inp[32][3:0]-1]+1;
    count[inp[32][7:4]-1]=count[inp[32][7:4]-1]+1;
end
if (inp[33]!=0)begin
    connected[inp[33][3:0]-1]<=connected[inp[33][3:0]-1]+inp[33][7:4]<<count[inp[33][3:0]-1];
    connected[inp[33][7:4]-1]<=connected[inp[33][7:4]-1]+inp[33][3:0]<<count[inp[33][7:4]-1];
    weights[inp[33][3:0]-1]<=weights[inp[33][3:0]-1]+inp[33][11:8]<<count[inp[33][3:0]-1];
    weights[inp[33][7:4]-1]<=weights[inp[33][7:4]-1]+inp[33][11:8]<<count[inp[33][7:4]-1];
    count[inp[33][3:0]-1]=count[inp[33][3:0]-1]+1;
    count[inp[33][7:4]-1]=count[inp[33][7:4]-1]+1;
end
if (inp[34]!=0)begin
    connected[inp[34][3:0]-1]<=connected[inp[34][3:0]-1]+inp[34][7:4]<<count[inp[34][3:0]-1];
    connected[inp[34][7:4]-1]<=connected[inp[34][7:4]-1]+inp[34][3:0]<<count[inp[34][7:4]-1];
    weights[inp[34][3:0]-1]<=weights[inp[34][3:0]-1]+inp[34][11:8]<<count[inp[34][3:0]-1];
    weights[inp[34][7:4]-1]<=weights[inp[34][7:4]-1]+inp[34][11:8]<<count[inp[34][7:4]-1];
    count[inp[34][3:0]-1]=count[inp[34][3:0]-1]+1;
    count[inp[34][7:4]-1]=count[inp[34][7:4]-1]+1;
end
if (inp[35]!=0)begin
    connected[inp[35][3:0]-1]<=connected[inp[35][3:0]-1]+inp[35][7:4]<<count[inp[35][3:0]-1];
    connected[inp[35][7:4]-1]<=connected[inp[35][7:4]-1]+inp[35][3:0]<<count[inp[35][7:4]-1];
    weights[inp[35][3:0]-1]<=weights[inp[35][3:0]-1]+inp[35][11:8]<<count[inp[35][3:0]-1];
    weights[inp[35][7:4]-1]<=weights[inp[35][7:4]-1]+inp[35][11:8]<<count[inp[35][7:4]-1];
    count[inp[35][3:0]-1]=count[inp[35][3:0]-1]+1;
    count[inp[35][7:4]-1]=count[inp[35][7:4]-1]+1;
end
if (inp[36]!=0)begin
    connected[inp[36][3:0]-1]<=connected[inp[36][3:0]-1]+inp[36][7:4]<<count[inp[36][3:0]-1];
    connected[inp[36][7:4]-1]<=connected[inp[36][7:4]-1]+inp[36][3:0]<<count[inp[36][7:4]-1];
    weights[inp[36][3:0]-1]<=weights[inp[36][3:0]-1]+inp[36][11:8]<<count[inp[36][3:0]-1];
    weights[inp[36][7:4]-1]<=weights[inp[36][7:4]-1]+inp[36][11:8]<<count[inp[36][7:4]-1];
    count[inp[36][3:0]-1]=count[inp[36][3:0]-1]+1;
    count[inp[36][7:4]-1]=count[inp[36][7:4]-1]+1;
end
if (inp[37]!=0)begin
    connected[inp[37][3:0]-1]<=connected[inp[37][3:0]-1]+inp[37][7:4]<<count[inp[37][3:0]-1];
    connected[inp[37][7:4]-1]<=connected[inp[37][7:4]-1]+inp[37][3:0]<<count[inp[37][7:4]-1];
    weights[inp[37][3:0]-1]<=weights[inp[37][3:0]-1]+inp[37][11:8]<<count[inp[37][3:0]-1];
    weights[inp[37][7:4]-1]<=weights[inp[37][7:4]-1]+inp[37][11:8]<<count[inp[37][7:4]-1];
    count[inp[37][3:0]-1]=count[inp[37][3:0]-1]+1;
    count[inp[37][7:4]-1]=count[inp[37][7:4]-1]+1;
end
if (inp[38]!=0)begin
    connected[inp[38][3:0]-1]<=connected[inp[38][3:0]-1]+inp[38][7:4]<<count[inp[38][3:0]-1];
    connected[inp[38][7:4]-1]<=connected[inp[38][7:4]-1]+inp[38][3:0]<<count[inp[38][7:4]-1];
    weights[inp[38][3:0]-1]<=weights[inp[38][3:0]-1]+inp[38][11:8]<<count[inp[38][3:0]-1];
    weights[inp[38][7:4]-1]<=weights[inp[38][7:4]-1]+inp[38][11:8]<<count[inp[38][7:4]-1];
    count[inp[38][3:0]-1]=count[inp[38][3:0]-1]+1;
    count[inp[38][7:4]-1]=count[inp[38][7:4]-1]+1;
end
if (inp[39]!=0)begin
    connected[inp[39][3:0]-1]<=connected[inp[39][3:0]-1]+inp[39][7:4]<<count[inp[39][3:0]-1];
    connected[inp[39][7:4]-1]<=connected[inp[39][7:4]-1]+inp[39][3:0]<<count[inp[39][7:4]-1];
    weights[inp[39][3:0]-1]<=weights[inp[39][3:0]-1]+inp[39][11:8]<<count[inp[39][3:0]-1];
    weights[inp[39][7:4]-1]<=weights[inp[39][7:4]-1]+inp[39][11:8]<<count[inp[39][7:4]-1];
    count[inp[39][3:0]-1]=count[inp[39][3:0]-1]+1;
    count[inp[39][7:4]-1]=count[inp[39][7:4]-1]+1;
end
if (inp[40]!=0)begin
    connected[inp[40][3:0]-1]<=connected[inp[40][3:0]-1]+inp[40][7:4]<<count[inp[40][3:0]-1];
    connected[inp[40][7:4]-1]<=connected[inp[40][7:4]-1]+inp[40][3:0]<<count[inp[40][7:4]-1];
    weights[inp[40][3:0]-1]<=weights[inp[40][3:0]-1]+inp[40][11:8]<<count[inp[40][3:0]-1];
    weights[inp[40][7:4]-1]<=weights[inp[40][7:4]-1]+inp[40][11:8]<<count[inp[40][7:4]-1];
    count[inp[40][3:0]-1]=count[inp[40][3:0]-1]+1;
    count[inp[40][7:4]-1]=count[inp[40][7:4]-1]+1;
end
if (inp[41]!=0)begin
    connected[inp[41][3:0]-1]<=connected[inp[41][3:0]-1]+inp[41][7:4]<<count[inp[41][3:0]-1];
    connected[inp[41][7:4]-1]<=connected[inp[41][7:4]-1]+inp[41][3:0]<<count[inp[41][7:4]-1];
    weights[inp[41][3:0]-1]<=weights[inp[41][3:0]-1]+inp[41][11:8]<<count[inp[41][3:0]-1];
    weights[inp[41][7:4]-1]<=weights[inp[41][7:4]-1]+inp[41][11:8]<<count[inp[41][7:4]-1];
    count[inp[41][3:0]-1]=count[inp[41][3:0]-1]+1;
    count[inp[41][7:4]-1]=count[inp[41][7:4]-1]+1;
end
if (inp[42]!=0)begin
    connected[inp[42][3:0]-1]<=connected[inp[42][3:0]-1]+inp[42][7:4]<<count[inp[42][3:0]-1];
    connected[inp[42][7:4]-1]<=connected[inp[42][7:4]-1]+inp[42][3:0]<<count[inp[42][7:4]-1];
    weights[inp[42][3:0]-1]<=weights[inp[42][3:0]-1]+inp[42][11:8]<<count[inp[42][3:0]-1];
    weights[inp[42][7:4]-1]<=weights[inp[42][7:4]-1]+inp[42][11:8]<<count[inp[42][7:4]-1];
    count[inp[42][3:0]-1]=count[inp[42][3:0]-1]+1;
    count[inp[42][7:4]-1]=count[inp[42][7:4]-1]+1;
end
if (inp[43]!=0)begin
    connected[inp[43][3:0]-1]<=connected[inp[43][3:0]-1]+inp[43][7:4]<<count[inp[43][3:0]-1];
    connected[inp[43][7:4]-1]<=connected[inp[43][7:4]-1]+inp[43][3:0]<<count[inp[43][7:4]-1];
    weights[inp[43][3:0]-1]<=weights[inp[43][3:0]-1]+inp[43][11:8]<<count[inp[43][3:0]-1];
    weights[inp[43][7:4]-1]<=weights[inp[43][7:4]-1]+inp[43][11:8]<<count[inp[43][7:4]-1];
    count[inp[43][3:0]-1]=count[inp[43][3:0]-1]+1;
    count[inp[43][7:4]-1]=count[inp[43][7:4]-1]+1;
end
if (inp[44]!=0)begin
    connected[inp[44][3:0]-1]<=connected[inp[44][3:0]-1]+inp[44][7:4]<<count[inp[44][3:0]-1];
    connected[inp[44][7:4]-1]<=connected[inp[44][7:4]-1]+inp[44][3:0]<<count[inp[44][7:4]-1];
    weights[inp[44][3:0]-1]<=weights[inp[44][3:0]-1]+inp[44][11:8]<<count[inp[44][3:0]-1];
    weights[inp[44][7:4]-1]<=weights[inp[44][7:4]-1]+inp[44][11:8]<<count[inp[44][7:4]-1];
    count[inp[44][3:0]-1]=count[inp[44][3:0]-1]+1;
    count[inp[44][7:4]-1]=count[inp[44][7:4]-1]+1;
end
if (inp[45]!=0)begin
    connected[inp[45][3:0]-1]<=connected[inp[45][3:0]-1]+inp[45][7:4]<<count[inp[45][3:0]-1];
    connected[inp[45][7:4]-1]<=connected[inp[45][7:4]-1]+inp[45][3:0]<<count[inp[45][7:4]-1];
    weights[inp[45][3:0]-1]<=weights[inp[45][3:0]-1]+inp[45][11:8]<<count[inp[45][3:0]-1];
    weights[inp[45][7:4]-1]<=weights[inp[45][7:4]-1]+inp[45][11:8]<<count[inp[45][7:4]-1];
    count[inp[45][3:0]-1]=count[inp[45][3:0]-1]+1;
    count[inp[45][7:4]-1]=count[inp[45][7:4]-1]+1;
end
if (inp[46]!=0)begin
    connected[inp[46][3:0]-1]<=connected[inp[46][3:0]-1]+inp[46][7:4]<<count[inp[46][3:0]-1];
    connected[inp[46][7:4]-1]<=connected[inp[46][7:4]-1]+inp[46][3:0]<<count[inp[46][7:4]-1];
    weights[inp[46][3:0]-1]<=weights[inp[46][3:0]-1]+inp[46][11:8]<<count[inp[46][3:0]-1];
    weights[inp[46][7:4]-1]<=weights[inp[46][7:4]-1]+inp[46][11:8]<<count[inp[46][7:4]-1];
    count[inp[46][3:0]-1]=count[inp[46][3:0]-1]+1;
    count[inp[46][7:4]-1]=count[inp[46][7:4]-1]+1;
end
if (inp[47]!=0)begin
    connected[inp[47][3:0]-1]<=connected[inp[47][3:0]-1]+inp[47][7:4]<<count[inp[47][3:0]-1];
    connected[inp[47][7:4]-1]<=connected[inp[47][7:4]-1]+inp[47][3:0]<<count[inp[47][7:4]-1];
    weights[inp[47][3:0]-1]<=weights[inp[47][3:0]-1]+inp[47][11:8]<<count[inp[47][3:0]-1];
    weights[inp[47][7:4]-1]<=weights[inp[47][7:4]-1]+inp[47][11:8]<<count[inp[47][7:4]-1];
    count[inp[47][3:0]-1]=count[inp[47][3:0]-1]+1;
    count[inp[47][7:4]-1]=count[inp[47][7:4]-1]+1;
end
if (inp[48]!=0)begin
    connected[inp[48][3:0]-1]<=connected[inp[48][3:0]-1]+inp[48][7:4]<<count[inp[48][3:0]-1];
    connected[inp[48][7:4]-1]<=connected[inp[48][7:4]-1]+inp[48][3:0]<<count[inp[48][7:4]-1];
    weights[inp[48][3:0]-1]<=weights[inp[48][3:0]-1]+inp[48][11:8]<<count[inp[48][3:0]-1];
    weights[inp[48][7:4]-1]<=weights[inp[48][7:4]-1]+inp[48][11:8]<<count[inp[48][7:4]-1];
    count[inp[48][3:0]-1]=count[inp[48][3:0]-1]+1;
    count[inp[48][7:4]-1]=count[inp[48][7:4]-1]+1;
end
if (inp[49]!=0)begin
    connected[inp[49][3:0]-1]<=connected[inp[49][3:0]-1]+inp[49][7:4]<<count[inp[49][3:0]-1];
    connected[inp[49][7:4]-1]<=connected[inp[49][7:4]-1]+inp[49][3:0]<<count[inp[49][7:4]-1];
    weights[inp[49][3:0]-1]<=weights[inp[49][3:0]-1]+inp[49][11:8]<<count[inp[49][3:0]-1];
    weights[inp[49][7:4]-1]<=weights[inp[49][7:4]-1]+inp[49][11:8]<<count[inp[49][7:4]-1];
    count[inp[49][3:0]-1]=count[inp[49][3:0]-1]+1;
    count[inp[49][7:4]-1]=count[inp[49][7:4]-1]+1;
end
if (inp[50]!=0)begin
    connected[inp[50][3:0]-1]<=connected[inp[50][3:0]-1]+inp[50][7:4]<<count[inp[50][3:0]-1];
    connected[inp[50][7:4]-1]<=connected[inp[50][7:4]-1]+inp[50][3:0]<<count[inp[50][7:4]-1];
    weights[inp[50][3:0]-1]<=weights[inp[50][3:0]-1]+inp[50][11:8]<<count[inp[50][3:0]-1];
    weights[inp[50][7:4]-1]<=weights[inp[50][7:4]-1]+inp[50][11:8]<<count[inp[50][7:4]-1];
    count[inp[50][3:0]-1]=count[inp[50][3:0]-1]+1;
    count[inp[50][7:4]-1]=count[inp[50][7:4]-1]+1;
end
if (inp[51]!=0)begin
    connected[inp[51][3:0]-1]<=connected[inp[51][3:0]-1]+inp[51][7:4]<<count[inp[51][3:0]-1];
    connected[inp[51][7:4]-1]<=connected[inp[51][7:4]-1]+inp[51][3:0]<<count[inp[51][7:4]-1];
    weights[inp[51][3:0]-1]<=weights[inp[51][3:0]-1]+inp[51][11:8]<<count[inp[51][3:0]-1];
    weights[inp[51][7:4]-1]<=weights[inp[51][7:4]-1]+inp[51][11:8]<<count[inp[51][7:4]-1];
    count[inp[51][3:0]-1]=count[inp[51][3:0]-1]+1;
    count[inp[51][7:4]-1]=count[inp[51][7:4]-1]+1;
end
if (inp[52]!=0)begin
    connected[inp[52][3:0]-1]<=connected[inp[52][3:0]-1]+inp[52][7:4]<<count[inp[52][3:0]-1];
    connected[inp[52][7:4]-1]<=connected[inp[52][7:4]-1]+inp[52][3:0]<<count[inp[52][7:4]-1];
    weights[inp[52][3:0]-1]<=weights[inp[52][3:0]-1]+inp[52][11:8]<<count[inp[52][3:0]-1];
    weights[inp[52][7:4]-1]<=weights[inp[52][7:4]-1]+inp[52][11:8]<<count[inp[52][7:4]-1];
    count[inp[52][3:0]-1]=count[inp[52][3:0]-1]+1;
    count[inp[52][7:4]-1]=count[inp[52][7:4]-1]+1;
end
if (inp[53]!=0)begin
    connected[inp[53][3:0]-1]<=connected[inp[53][3:0]-1]+inp[53][7:4]<<count[inp[53][3:0]-1];
    connected[inp[53][7:4]-1]<=connected[inp[53][7:4]-1]+inp[53][3:0]<<count[inp[53][7:4]-1];
    weights[inp[53][3:0]-1]<=weights[inp[53][3:0]-1]+inp[53][11:8]<<count[inp[53][3:0]-1];
    weights[inp[53][7:4]-1]<=weights[inp[53][7:4]-1]+inp[53][11:8]<<count[inp[53][7:4]-1];
    count[inp[53][3:0]-1]=count[inp[53][3:0]-1]+1;
    count[inp[53][7:4]-1]=count[inp[53][7:4]-1]+1;
end
if (inp[54]!=0)begin
    connected[inp[54][3:0]-1]<=connected[inp[54][3:0]-1]+inp[54][7:4]<<count[inp[54][3:0]-1];
    connected[inp[54][7:4]-1]<=connected[inp[54][7:4]-1]+inp[54][3:0]<<count[inp[54][7:4]-1];
    weights[inp[54][3:0]-1]<=weights[inp[54][3:0]-1]+inp[54][11:8]<<count[inp[54][3:0]-1];
    weights[inp[54][7:4]-1]<=weights[inp[54][7:4]-1]+inp[54][11:8]<<count[inp[54][7:4]-1];
    count[inp[54][3:0]-1]=count[inp[54][3:0]-1]+1;
    count[inp[54][7:4]-1]=count[inp[54][7:4]-1]+1;
end
if (inp[55]!=0)begin
    connected[inp[55][3:0]-1]<=connected[inp[55][3:0]-1]+inp[55][7:4]<<count[inp[55][3:0]-1];
    connected[inp[55][7:4]-1]<=connected[inp[55][7:4]-1]+inp[55][3:0]<<count[inp[55][7:4]-1];
    weights[inp[55][3:0]-1]<=weights[inp[55][3:0]-1]+inp[55][11:8]<<count[inp[55][3:0]-1];
    weights[inp[55][7:4]-1]<=weights[inp[55][7:4]-1]+inp[55][11:8]<<count[inp[55][7:4]-1];
    count[inp[55][3:0]-1]=count[inp[55][3:0]-1]+1;
    count[inp[55][7:4]-1]=count[inp[55][7:4]-1]+1;
end
if (inp[56]!=0)begin
    connected[inp[56][3:0]-1]<=connected[inp[56][3:0]-1]+inp[56][7:4]<<count[inp[56][3:0]-1];
    connected[inp[56][7:4]-1]<=connected[inp[56][7:4]-1]+inp[56][3:0]<<count[inp[56][7:4]-1];
    weights[inp[56][3:0]-1]<=weights[inp[56][3:0]-1]+inp[56][11:8]<<count[inp[56][3:0]-1];
    weights[inp[56][7:4]-1]<=weights[inp[56][7:4]-1]+inp[56][11:8]<<count[inp[56][7:4]-1];
    count[inp[56][3:0]-1]=count[inp[56][3:0]-1]+1;
    count[inp[56][7:4]-1]=count[inp[56][7:4]-1]+1;
end
if (inp[57]!=0)begin
    connected[inp[57][3:0]-1]<=connected[inp[57][3:0]-1]+inp[57][7:4]<<count[inp[57][3:0]-1];
    connected[inp[57][7:4]-1]<=connected[inp[57][7:4]-1]+inp[57][3:0]<<count[inp[57][7:4]-1];
    weights[inp[57][3:0]-1]<=weights[inp[57][3:0]-1]+inp[57][11:8]<<count[inp[57][3:0]-1];
    weights[inp[57][7:4]-1]<=weights[inp[57][7:4]-1]+inp[57][11:8]<<count[inp[57][7:4]-1];
    count[inp[57][3:0]-1]=count[inp[57][3:0]-1]+1;
    count[inp[57][7:4]-1]=count[inp[57][7:4]-1]+1;
end
if (inp[58]!=0)begin
    connected[inp[58][3:0]-1]<=connected[inp[58][3:0]-1]+inp[58][7:4]<<count[inp[58][3:0]-1];
    connected[inp[58][7:4]-1]<=connected[inp[58][7:4]-1]+inp[58][3:0]<<count[inp[58][7:4]-1];
    weights[inp[58][3:0]-1]<=weights[inp[58][3:0]-1]+inp[58][11:8]<<count[inp[58][3:0]-1];
    weights[inp[58][7:4]-1]<=weights[inp[58][7:4]-1]+inp[58][11:8]<<count[inp[58][7:4]-1];
    count[inp[58][3:0]-1]=count[inp[58][3:0]-1]+1;
    count[inp[58][7:4]-1]=count[inp[58][7:4]-1]+1;
end
if (inp[59]!=0)begin
    connected[inp[59][3:0]-1]<=connected[inp[59][3:0]-1]+inp[59][7:4]<<count[inp[59][3:0]-1];
    connected[inp[59][7:4]-1]<=connected[inp[59][7:4]-1]+inp[59][3:0]<<count[inp[59][7:4]-1];
    weights[inp[59][3:0]-1]<=weights[inp[59][3:0]-1]+inp[59][11:8]<<count[inp[59][3:0]-1];
    weights[inp[59][7:4]-1]<=weights[inp[59][7:4]-1]+inp[59][11:8]<<count[inp[59][7:4]-1];
    count[inp[59][3:0]-1]=count[inp[59][3:0]-1]+1;
    count[inp[59][7:4]-1]=count[inp[59][7:4]-1]+1;
end
if (inp[60]!=0)begin
    connected[inp[60][3:0]-1]<=connected[inp[60][3:0]-1]+inp[60][7:4]<<count[inp[60][3:0]-1];
    connected[inp[60][7:4]-1]<=connected[inp[60][7:4]-1]+inp[60][3:0]<<count[inp[60][7:4]-1];
    weights[inp[60][3:0]-1]<=weights[inp[60][3:0]-1]+inp[60][11:8]<<count[inp[60][3:0]-1];
    weights[inp[60][7:4]-1]<=weights[inp[60][7:4]-1]+inp[60][11:8]<<count[inp[60][7:4]-1];
    count[inp[60][3:0]-1]=count[inp[60][3:0]-1]+1;
    count[inp[60][7:4]-1]=count[inp[60][7:4]-1]+1;
end
if (inp[61]!=0)begin
    connected[inp[61][3:0]-1]<=connected[inp[61][3:0]-1]+inp[61][7:4]<<count[inp[61][3:0]-1];
    connected[inp[61][7:4]-1]<=connected[inp[61][7:4]-1]+inp[61][3:0]<<count[inp[61][7:4]-1];
    weights[inp[61][3:0]-1]<=weights[inp[61][3:0]-1]+inp[61][11:8]<<count[inp[61][3:0]-1];
    weights[inp[61][7:4]-1]<=weights[inp[61][7:4]-1]+inp[61][11:8]<<count[inp[61][7:4]-1];
    count[inp[61][3:0]-1]=count[inp[61][3:0]-1]+1;
    count[inp[61][7:4]-1]=count[inp[61][7:4]-1]+1;
end
if (inp[62]!=0)begin
    connected[inp[62][3:0]-1]<=connected[inp[62][3:0]-1]+inp[62][7:4]<<count[inp[62][3:0]-1];
    connected[inp[62][7:4]-1]<=connected[inp[62][7:4]-1]+inp[62][3:0]<<count[inp[62][7:4]-1];
    weights[inp[62][3:0]-1]<=weights[inp[62][3:0]-1]+inp[62][11:8]<<count[inp[62][3:0]-1];
    weights[inp[62][7:4]-1]<=weights[inp[62][7:4]-1]+inp[62][11:8]<<count[inp[62][7:4]-1];
    count[inp[62][3:0]-1]=count[inp[62][3:0]-1]+1;
    count[inp[62][7:4]-1]=count[inp[62][7:4]-1]+1;
end
if (inp[63]!=0)begin
    connected[inp[63][3:0]-1]<=connected[inp[63][3:0]-1]+inp[63][7:4]<<count[inp[63][3:0]-1];
    connected[inp[63][7:4]-1]<=connected[inp[63][7:4]-1]+inp[63][3:0]<<count[inp[63][7:4]-1];
    weights[inp[63][3:0]-1]<=weights[inp[63][3:0]-1]+inp[63][11:8]<<count[inp[63][3:0]-1];
    weights[inp[63][7:4]-1]<=weights[inp[63][7:4]-1]+inp[63][11:8]<<count[inp[63][7:4]-1];
    count[inp[63][3:0]-1]=count[inp[63][3:0]-1]+1;
    count[inp[63][7:4]-1]=count[inp[63][7:4]-1]+1;
end
if (inp[64]!=0)begin
    connected[inp[64][3:0]-1]<=connected[inp[64][3:0]-1]+inp[64][7:4]<<count[inp[64][3:0]-1];
    connected[inp[64][7:4]-1]<=connected[inp[64][7:4]-1]+inp[64][3:0]<<count[inp[64][7:4]-1];
    weights[inp[64][3:0]-1]<=weights[inp[64][3:0]-1]+inp[64][11:8]<<count[inp[64][3:0]-1];
    weights[inp[64][7:4]-1]<=weights[inp[64][7:4]-1]+inp[64][11:8]<<count[inp[64][7:4]-1];
    count[inp[64][3:0]-1]=count[inp[64][3:0]-1]+1;
    count[inp[64][7:4]-1]=count[inp[64][7:4]-1]+1;
end
if (inp[65]!=0)begin
    connected[inp[65][3:0]-1]<=connected[inp[65][3:0]-1]+inp[65][7:4]<<count[inp[65][3:0]-1];
    connected[inp[65][7:4]-1]<=connected[inp[65][7:4]-1]+inp[65][3:0]<<count[inp[65][7:4]-1];
    weights[inp[65][3:0]-1]<=weights[inp[65][3:0]-1]+inp[65][11:8]<<count[inp[65][3:0]-1];
    weights[inp[65][7:4]-1]<=weights[inp[65][7:4]-1]+inp[65][11:8]<<count[inp[65][7:4]-1];
    count[inp[65][3:0]-1]=count[inp[65][3:0]-1]+1;
    count[inp[65][7:4]-1]=count[inp[65][7:4]-1]+1;
end
if (inp[66]!=0)begin
    connected[inp[66][3:0]-1]<=connected[inp[66][3:0]-1]+inp[66][7:4]<<count[inp[66][3:0]-1];
    connected[inp[66][7:4]-1]<=connected[inp[66][7:4]-1]+inp[66][3:0]<<count[inp[66][7:4]-1];
    weights[inp[66][3:0]-1]<=weights[inp[66][3:0]-1]+inp[66][11:8]<<count[inp[66][3:0]-1];
    weights[inp[66][7:4]-1]<=weights[inp[66][7:4]-1]+inp[66][11:8]<<count[inp[66][7:4]-1];
    count[inp[66][3:0]-1]=count[inp[66][3:0]-1]+1;
    count[inp[66][7:4]-1]=count[inp[66][7:4]-1]+1;
end
if (inp[67]!=0)begin
    connected[inp[67][3:0]-1]<=connected[inp[67][3:0]-1]+inp[67][7:4]<<count[inp[67][3:0]-1];
    connected[inp[67][7:4]-1]<=connected[inp[67][7:4]-1]+inp[67][3:0]<<count[inp[67][7:4]-1];
    weights[inp[67][3:0]-1]<=weights[inp[67][3:0]-1]+inp[67][11:8]<<count[inp[67][3:0]-1];
    weights[inp[67][7:4]-1]<=weights[inp[67][7:4]-1]+inp[67][11:8]<<count[inp[67][7:4]-1];
    count[inp[67][3:0]-1]=count[inp[67][3:0]-1]+1;
    count[inp[67][7:4]-1]=count[inp[67][7:4]-1]+1;
end
if (inp[68]!=0)begin
    connected[inp[68][3:0]-1]<=connected[inp[68][3:0]-1]+inp[68][7:4]<<count[inp[68][3:0]-1];
    connected[inp[68][7:4]-1]<=connected[inp[68][7:4]-1]+inp[68][3:0]<<count[inp[68][7:4]-1];
    weights[inp[68][3:0]-1]<=weights[inp[68][3:0]-1]+inp[68][11:8]<<count[inp[68][3:0]-1];
    weights[inp[68][7:4]-1]<=weights[inp[68][7:4]-1]+inp[68][11:8]<<count[inp[68][7:4]-1];
    count[inp[68][3:0]-1]=count[inp[68][3:0]-1]+1;
    count[inp[68][7:4]-1]=count[inp[68][7:4]-1]+1;
end
if (inp[69]!=0)begin
    connected[inp[69][3:0]-1]<=connected[inp[69][3:0]-1]+inp[69][7:4]<<count[inp[69][3:0]-1];
    connected[inp[69][7:4]-1]<=connected[inp[69][7:4]-1]+inp[69][3:0]<<count[inp[69][7:4]-1];
    weights[inp[69][3:0]-1]<=weights[inp[69][3:0]-1]+inp[69][11:8]<<count[inp[69][3:0]-1];
    weights[inp[69][7:4]-1]<=weights[inp[69][7:4]-1]+inp[69][11:8]<<count[inp[69][7:4]-1];
    count[inp[69][3:0]-1]=count[inp[69][3:0]-1]+1;
    count[inp[69][7:4]-1]=count[inp[69][7:4]-1]+1;
end
if (inp[70]!=0)begin
    connected[inp[70][3:0]-1]<=connected[inp[70][3:0]-1]+inp[70][7:4]<<count[inp[70][3:0]-1];
    connected[inp[70][7:4]-1]<=connected[inp[70][7:4]-1]+inp[70][3:0]<<count[inp[70][7:4]-1];
    weights[inp[70][3:0]-1]<=weights[inp[70][3:0]-1]+inp[70][11:8]<<count[inp[70][3:0]-1];
    weights[inp[70][7:4]-1]<=weights[inp[70][7:4]-1]+inp[70][11:8]<<count[inp[70][7:4]-1];
    count[inp[70][3:0]-1]=count[inp[70][3:0]-1]+1;
    count[inp[70][7:4]-1]=count[inp[70][7:4]-1]+1;
end
if (inp[71]!=0)begin
    connected[inp[71][3:0]-1]<=connected[inp[71][3:0]-1]+inp[71][7:4]<<count[inp[71][3:0]-1];
    connected[inp[71][7:4]-1]<=connected[inp[71][7:4]-1]+inp[71][3:0]<<count[inp[71][7:4]-1];
    weights[inp[71][3:0]-1]<=weights[inp[71][3:0]-1]+inp[71][11:8]<<count[inp[71][3:0]-1];
    weights[inp[71][7:4]-1]<=weights[inp[71][7:4]-1]+inp[71][11:8]<<count[inp[71][7:4]-1];
    count[inp[71][3:0]-1]=count[inp[71][3:0]-1]+1;
    count[inp[71][7:4]-1]=count[inp[71][7:4]-1]+1;
end
if (inp[72]!=0)begin
    connected[inp[72][3:0]-1]<=connected[inp[72][3:0]-1]+inp[72][7:4]<<count[inp[72][3:0]-1];
    connected[inp[72][7:4]-1]<=connected[inp[72][7:4]-1]+inp[72][3:0]<<count[inp[72][7:4]-1];
    weights[inp[72][3:0]-1]<=weights[inp[72][3:0]-1]+inp[72][11:8]<<count[inp[72][3:0]-1];
    weights[inp[72][7:4]-1]<=weights[inp[72][7:4]-1]+inp[72][11:8]<<count[inp[72][7:4]-1];
    count[inp[72][3:0]-1]=count[inp[72][3:0]-1]+1;
    count[inp[72][7:4]-1]=count[inp[72][7:4]-1]+1;
end
if (inp[73]!=0)begin
    connected[inp[73][3:0]-1]<=connected[inp[73][3:0]-1]+inp[73][7:4]<<count[inp[73][3:0]-1];
    connected[inp[73][7:4]-1]<=connected[inp[73][7:4]-1]+inp[73][3:0]<<count[inp[73][7:4]-1];
    weights[inp[73][3:0]-1]<=weights[inp[73][3:0]-1]+inp[73][11:8]<<count[inp[73][3:0]-1];
    weights[inp[73][7:4]-1]<=weights[inp[73][7:4]-1]+inp[73][11:8]<<count[inp[73][7:4]-1];
    count[inp[73][3:0]-1]=count[inp[73][3:0]-1]+1;
    count[inp[73][7:4]-1]=count[inp[73][7:4]-1]+1;
end
if (inp[74]!=0)begin
    connected[inp[74][3:0]-1]<=connected[inp[74][3:0]-1]+inp[74][7:4]<<count[inp[74][3:0]-1];
    connected[inp[74][7:4]-1]<=connected[inp[74][7:4]-1]+inp[74][3:0]<<count[inp[74][7:4]-1];
    weights[inp[74][3:0]-1]<=weights[inp[74][3:0]-1]+inp[74][11:8]<<count[inp[74][3:0]-1];
    weights[inp[74][7:4]-1]<=weights[inp[74][7:4]-1]+inp[74][11:8]<<count[inp[74][7:4]-1];
    count[inp[74][3:0]-1]=count[inp[74][3:0]-1]+1;
    count[inp[74][7:4]-1]=count[inp[74][7:4]-1]+1;
end
if (inp[75]!=0)begin
    connected[inp[75][3:0]-1]<=connected[inp[75][3:0]-1]+inp[75][7:4]<<count[inp[75][3:0]-1];
    connected[inp[75][7:4]-1]<=connected[inp[75][7:4]-1]+inp[75][3:0]<<count[inp[75][7:4]-1];
    weights[inp[75][3:0]-1]<=weights[inp[75][3:0]-1]+inp[75][11:8]<<count[inp[75][3:0]-1];
    weights[inp[75][7:4]-1]<=weights[inp[75][7:4]-1]+inp[75][11:8]<<count[inp[75][7:4]-1];
    count[inp[75][3:0]-1]=count[inp[75][3:0]-1]+1;
    count[inp[75][7:4]-1]=count[inp[75][7:4]-1]+1;
end
if (inp[76]!=0)begin
    connected[inp[76][3:0]-1]<=connected[inp[76][3:0]-1]+inp[76][7:4]<<count[inp[76][3:0]-1];
    connected[inp[76][7:4]-1]<=connected[inp[76][7:4]-1]+inp[76][3:0]<<count[inp[76][7:4]-1];
    weights[inp[76][3:0]-1]<=weights[inp[76][3:0]-1]+inp[76][11:8]<<count[inp[76][3:0]-1];
    weights[inp[76][7:4]-1]<=weights[inp[76][7:4]-1]+inp[76][11:8]<<count[inp[76][7:4]-1];
    count[inp[76][3:0]-1]=count[inp[76][3:0]-1]+1;
    count[inp[76][7:4]-1]=count[inp[76][7:4]-1]+1;
end
if (inp[77]!=0)begin
    connected[inp[77][3:0]-1]<=connected[inp[77][3:0]-1]+inp[77][7:4]<<count[inp[77][3:0]-1];
    connected[inp[77][7:4]-1]<=connected[inp[77][7:4]-1]+inp[77][3:0]<<count[inp[77][7:4]-1];
    weights[inp[77][3:0]-1]<=weights[inp[77][3:0]-1]+inp[77][11:8]<<count[inp[77][3:0]-1];
    weights[inp[77][7:4]-1]<=weights[inp[77][7:4]-1]+inp[77][11:8]<<count[inp[77][7:4]-1];
    count[inp[77][3:0]-1]=count[inp[77][3:0]-1]+1;
    count[inp[77][7:4]-1]=count[inp[77][7:4]-1]+1;
end
if (inp[78]!=0)begin
    connected[inp[78][3:0]-1]<=connected[inp[78][3:0]-1]+inp[78][7:4]<<count[inp[78][3:0]-1];
    connected[inp[78][7:4]-1]<=connected[inp[78][7:4]-1]+inp[78][3:0]<<count[inp[78][7:4]-1];
    weights[inp[78][3:0]-1]<=weights[inp[78][3:0]-1]+inp[78][11:8]<<count[inp[78][3:0]-1];
    weights[inp[78][7:4]-1]<=weights[inp[78][7:4]-1]+inp[78][11:8]<<count[inp[78][7:4]-1];
    count[inp[78][3:0]-1]=count[inp[78][3:0]-1]+1;
    count[inp[78][7:4]-1]=count[inp[78][7:4]-1]+1;
end
if (inp[79]!=0)begin
    connected[inp[79][3:0]-1]<=connected[inp[79][3:0]-1]+inp[79][7:4]<<count[inp[79][3:0]-1];
    connected[inp[79][7:4]-1]<=connected[inp[79][7:4]-1]+inp[79][3:0]<<count[inp[79][7:4]-1];
    weights[inp[79][3:0]-1]<=weights[inp[79][3:0]-1]+inp[79][11:8]<<count[inp[79][3:0]-1];
    weights[inp[79][7:4]-1]<=weights[inp[79][7:4]-1]+inp[79][11:8]<<count[inp[79][7:4]-1];
    count[inp[79][3:0]-1]=count[inp[79][3:0]-1]+1;
    count[inp[79][7:4]-1]=count[inp[79][7:4]-1]+1;
end
if (inp[80]!=0)begin
    connected[inp[80][3:0]-1]<=connected[inp[80][3:0]-1]+inp[80][7:4]<<count[inp[80][3:0]-1];
    connected[inp[80][7:4]-1]<=connected[inp[80][7:4]-1]+inp[80][3:0]<<count[inp[80][7:4]-1];
    weights[inp[80][3:0]-1]<=weights[inp[80][3:0]-1]+inp[80][11:8]<<count[inp[80][3:0]-1];
    weights[inp[80][7:4]-1]<=weights[inp[80][7:4]-1]+inp[80][11:8]<<count[inp[80][7:4]-1];
    count[inp[80][3:0]-1]=count[inp[80][3:0]-1]+1;
    count[inp[80][7:4]-1]=count[inp[80][7:4]-1]+1;
end
if (inp[81]!=0)begin
    connected[inp[81][3:0]-1]<=connected[inp[81][3:0]-1]+inp[81][7:4]<<count[inp[81][3:0]-1];
    connected[inp[81][7:4]-1]<=connected[inp[81][7:4]-1]+inp[81][3:0]<<count[inp[81][7:4]-1];
    weights[inp[81][3:0]-1]<=weights[inp[81][3:0]-1]+inp[81][11:8]<<count[inp[81][3:0]-1];
    weights[inp[81][7:4]-1]<=weights[inp[81][7:4]-1]+inp[81][11:8]<<count[inp[81][7:4]-1];
    count[inp[81][3:0]-1]=count[inp[81][3:0]-1]+1;
    count[inp[81][7:4]-1]=count[inp[81][7:4]-1]+1;
end
if (inp[82]!=0)begin
    connected[inp[82][3:0]-1]<=connected[inp[82][3:0]-1]+inp[82][7:4]<<count[inp[82][3:0]-1];
    connected[inp[82][7:4]-1]<=connected[inp[82][7:4]-1]+inp[82][3:0]<<count[inp[82][7:4]-1];
    weights[inp[82][3:0]-1]<=weights[inp[82][3:0]-1]+inp[82][11:8]<<count[inp[82][3:0]-1];
    weights[inp[82][7:4]-1]<=weights[inp[82][7:4]-1]+inp[82][11:8]<<count[inp[82][7:4]-1];
    count[inp[82][3:0]-1]=count[inp[82][3:0]-1]+1;
    count[inp[82][7:4]-1]=count[inp[82][7:4]-1]+1;
end
if (inp[83]!=0)begin
    connected[inp[83][3:0]-1]<=connected[inp[83][3:0]-1]+inp[83][7:4]<<count[inp[83][3:0]-1];
    connected[inp[83][7:4]-1]<=connected[inp[83][7:4]-1]+inp[83][3:0]<<count[inp[83][7:4]-1];
    weights[inp[83][3:0]-1]<=weights[inp[83][3:0]-1]+inp[83][11:8]<<count[inp[83][3:0]-1];
    weights[inp[83][7:4]-1]<=weights[inp[83][7:4]-1]+inp[83][11:8]<<count[inp[83][7:4]-1];
    count[inp[83][3:0]-1]=count[inp[83][3:0]-1]+1;
    count[inp[83][7:4]-1]=count[inp[83][7:4]-1]+1;
end
if (inp[84]!=0)begin
    connected[inp[84][3:0]-1]<=connected[inp[84][3:0]-1]+inp[84][7:4]<<count[inp[84][3:0]-1];
    connected[inp[84][7:4]-1]<=connected[inp[84][7:4]-1]+inp[84][3:0]<<count[inp[84][7:4]-1];
    weights[inp[84][3:0]-1]<=weights[inp[84][3:0]-1]+inp[84][11:8]<<count[inp[84][3:0]-1];
    weights[inp[84][7:4]-1]<=weights[inp[84][7:4]-1]+inp[84][11:8]<<count[inp[84][7:4]-1];
    count[inp[84][3:0]-1]=count[inp[84][3:0]-1]+1;
    count[inp[84][7:4]-1]=count[inp[84][7:4]-1]+1;
end
if (inp[85]!=0)begin
    connected[inp[85][3:0]-1]<=connected[inp[85][3:0]-1]+inp[85][7:4]<<count[inp[85][3:0]-1];
    connected[inp[85][7:4]-1]<=connected[inp[85][7:4]-1]+inp[85][3:0]<<count[inp[85][7:4]-1];
    weights[inp[85][3:0]-1]<=weights[inp[85][3:0]-1]+inp[85][11:8]<<count[inp[85][3:0]-1];
    weights[inp[85][7:4]-1]<=weights[inp[85][7:4]-1]+inp[85][11:8]<<count[inp[85][7:4]-1];
    count[inp[85][3:0]-1]=count[inp[85][3:0]-1]+1;
    count[inp[85][7:4]-1]=count[inp[85][7:4]-1]+1;
end
if (inp[86]!=0)begin
    connected[inp[86][3:0]-1]<=connected[inp[86][3:0]-1]+inp[86][7:4]<<count[inp[86][3:0]-1];
    connected[inp[86][7:4]-1]<=connected[inp[86][7:4]-1]+inp[86][3:0]<<count[inp[86][7:4]-1];
    weights[inp[86][3:0]-1]<=weights[inp[86][3:0]-1]+inp[86][11:8]<<count[inp[86][3:0]-1];
    weights[inp[86][7:4]-1]<=weights[inp[86][7:4]-1]+inp[86][11:8]<<count[inp[86][7:4]-1];
    count[inp[86][3:0]-1]=count[inp[86][3:0]-1]+1;
    count[inp[86][7:4]-1]=count[inp[86][7:4]-1]+1;
end
if (inp[87]!=0)begin
    connected[inp[87][3:0]-1]<=connected[inp[87][3:0]-1]+inp[87][7:4]<<count[inp[87][3:0]-1];
    connected[inp[87][7:4]-1]<=connected[inp[87][7:4]-1]+inp[87][3:0]<<count[inp[87][7:4]-1];
    weights[inp[87][3:0]-1]<=weights[inp[87][3:0]-1]+inp[87][11:8]<<count[inp[87][3:0]-1];
    weights[inp[87][7:4]-1]<=weights[inp[87][7:4]-1]+inp[87][11:8]<<count[inp[87][7:4]-1];
    count[inp[87][3:0]-1]=count[inp[87][3:0]-1]+1;
    count[inp[87][7:4]-1]=count[inp[87][7:4]-1]+1;
end
if (inp[88]!=0)begin
    connected[inp[88][3:0]-1]<=connected[inp[88][3:0]-1]+inp[88][7:4]<<count[inp[88][3:0]-1];
    connected[inp[88][7:4]-1]<=connected[inp[88][7:4]-1]+inp[88][3:0]<<count[inp[88][7:4]-1];
    weights[inp[88][3:0]-1]<=weights[inp[88][3:0]-1]+inp[88][11:8]<<count[inp[88][3:0]-1];
    weights[inp[88][7:4]-1]<=weights[inp[88][7:4]-1]+inp[88][11:8]<<count[inp[88][7:4]-1];
    count[inp[88][3:0]-1]=count[inp[88][3:0]-1]+1;
    count[inp[88][7:4]-1]=count[inp[88][7:4]-1]+1;
end
if (inp[89]!=0)begin
    connected[inp[89][3:0]-1]<=connected[inp[89][3:0]-1]+inp[89][7:4]<<count[inp[89][3:0]-1];
    connected[inp[89][7:4]-1]<=connected[inp[89][7:4]-1]+inp[89][3:0]<<count[inp[89][7:4]-1];
    weights[inp[89][3:0]-1]<=weights[inp[89][3:0]-1]+inp[89][11:8]<<count[inp[89][3:0]-1];
    weights[inp[89][7:4]-1]<=weights[inp[89][7:4]-1]+inp[89][11:8]<<count[inp[89][7:4]-1];
    count[inp[89][3:0]-1]=count[inp[89][3:0]-1]+1;
    count[inp[89][7:4]-1]=count[inp[89][7:4]-1]+1;
end
if (inp[90]!=0)begin
    connected[inp[90][3:0]-1]<=connected[inp[90][3:0]-1]+inp[90][7:4]<<count[inp[90][3:0]-1];
    connected[inp[90][7:4]-1]<=connected[inp[90][7:4]-1]+inp[90][3:0]<<count[inp[90][7:4]-1];
    weights[inp[90][3:0]-1]<=weights[inp[90][3:0]-1]+inp[90][11:8]<<count[inp[90][3:0]-1];
    weights[inp[90][7:4]-1]<=weights[inp[90][7:4]-1]+inp[90][11:8]<<count[inp[90][7:4]-1];
    count[inp[90][3:0]-1]=count[inp[90][3:0]-1]+1;
    count[inp[90][7:4]-1]=count[inp[90][7:4]-1]+1;
end
if (inp[91]!=0)begin
    connected[inp[91][3:0]-1]<=connected[inp[91][3:0]-1]+inp[91][7:4]<<count[inp[91][3:0]-1];
    connected[inp[91][7:4]-1]<=connected[inp[91][7:4]-1]+inp[91][3:0]<<count[inp[91][7:4]-1];
    weights[inp[91][3:0]-1]<=weights[inp[91][3:0]-1]+inp[91][11:8]<<count[inp[91][3:0]-1];
    weights[inp[91][7:4]-1]<=weights[inp[91][7:4]-1]+inp[91][11:8]<<count[inp[91][7:4]-1];
    count[inp[91][3:0]-1]=count[inp[91][3:0]-1]+1;
    count[inp[91][7:4]-1]=count[inp[91][7:4]-1]+1;
end
if (inp[92]!=0)begin
    connected[inp[92][3:0]-1]<=connected[inp[92][3:0]-1]+inp[92][7:4]<<count[inp[92][3:0]-1];
    connected[inp[92][7:4]-1]<=connected[inp[92][7:4]-1]+inp[92][3:0]<<count[inp[92][7:4]-1];
    weights[inp[92][3:0]-1]<=weights[inp[92][3:0]-1]+inp[92][11:8]<<count[inp[92][3:0]-1];
    weights[inp[92][7:4]-1]<=weights[inp[92][7:4]-1]+inp[92][11:8]<<count[inp[92][7:4]-1];
    count[inp[92][3:0]-1]=count[inp[92][3:0]-1]+1;
    count[inp[92][7:4]-1]=count[inp[92][7:4]-1]+1;
end
if (inp[93]!=0)begin
    connected[inp[93][3:0]-1]<=connected[inp[93][3:0]-1]+inp[93][7:4]<<count[inp[93][3:0]-1];
    connected[inp[93][7:4]-1]<=connected[inp[93][7:4]-1]+inp[93][3:0]<<count[inp[93][7:4]-1];
    weights[inp[93][3:0]-1]<=weights[inp[93][3:0]-1]+inp[93][11:8]<<count[inp[93][3:0]-1];
    weights[inp[93][7:4]-1]<=weights[inp[93][7:4]-1]+inp[93][11:8]<<count[inp[93][7:4]-1];
    count[inp[93][3:0]-1]=count[inp[93][3:0]-1]+1;
    count[inp[93][7:4]-1]=count[inp[93][7:4]-1]+1;
end
if (inp[94]!=0)begin
    connected[inp[94][3:0]-1]<=connected[inp[94][3:0]-1]+inp[94][7:4]<<count[inp[94][3:0]-1];
    connected[inp[94][7:4]-1]<=connected[inp[94][7:4]-1]+inp[94][3:0]<<count[inp[94][7:4]-1];
    weights[inp[94][3:0]-1]<=weights[inp[94][3:0]-1]+inp[94][11:8]<<count[inp[94][3:0]-1];
    weights[inp[94][7:4]-1]<=weights[inp[94][7:4]-1]+inp[94][11:8]<<count[inp[94][7:4]-1];
    count[inp[94][3:0]-1]=count[inp[94][3:0]-1]+1;
    count[inp[94][7:4]-1]=count[inp[94][7:4]-1]+1;
end
if (inp[95]!=0)begin
    connected[inp[95][3:0]-1]<=connected[inp[95][3:0]-1]+inp[95][7:4]<<count[inp[95][3:0]-1];
    connected[inp[95][7:4]-1]<=connected[inp[95][7:4]-1]+inp[95][3:0]<<count[inp[95][7:4]-1];
    weights[inp[95][3:0]-1]<=weights[inp[95][3:0]-1]+inp[95][11:8]<<count[inp[95][3:0]-1];
    weights[inp[95][7:4]-1]<=weights[inp[95][7:4]-1]+inp[95][11:8]<<count[inp[95][7:4]-1];
    count[inp[95][3:0]-1]=count[inp[95][3:0]-1]+1;
    count[inp[95][7:4]-1]=count[inp[95][7:4]-1]+1;
end
if (inp[96]!=0)begin
    connected[inp[96][3:0]-1]<=connected[inp[96][3:0]-1]+inp[96][7:4]<<count[inp[96][3:0]-1];
    connected[inp[96][7:4]-1]<=connected[inp[96][7:4]-1]+inp[96][3:0]<<count[inp[96][7:4]-1];
    weights[inp[96][3:0]-1]<=weights[inp[96][3:0]-1]+inp[96][11:8]<<count[inp[96][3:0]-1];
    weights[inp[96][7:4]-1]<=weights[inp[96][7:4]-1]+inp[96][11:8]<<count[inp[96][7:4]-1];
    count[inp[96][3:0]-1]=count[inp[96][3:0]-1]+1;
    count[inp[96][7:4]-1]=count[inp[96][7:4]-1]+1;
end
if (inp[97]!=0)begin
    connected[inp[97][3:0]-1]<=connected[inp[97][3:0]-1]+inp[97][7:4]<<count[inp[97][3:0]-1];
    connected[inp[97][7:4]-1]<=connected[inp[97][7:4]-1]+inp[97][3:0]<<count[inp[97][7:4]-1];
    weights[inp[97][3:0]-1]<=weights[inp[97][3:0]-1]+inp[97][11:8]<<count[inp[97][3:0]-1];
    weights[inp[97][7:4]-1]<=weights[inp[97][7:4]-1]+inp[97][11:8]<<count[inp[97][7:4]-1];
    count[inp[97][3:0]-1]=count[inp[97][3:0]-1]+1;
    count[inp[97][7:4]-1]=count[inp[97][7:4]-1]+1;
end
if (inp[98]!=0)begin
    connected[inp[98][3:0]-1]<=connected[inp[98][3:0]-1]+inp[98][7:4]<<count[inp[98][3:0]-1];
    connected[inp[98][7:4]-1]<=connected[inp[98][7:4]-1]+inp[98][3:0]<<count[inp[98][7:4]-1];
    weights[inp[98][3:0]-1]<=weights[inp[98][3:0]-1]+inp[98][11:8]<<count[inp[98][3:0]-1];
    weights[inp[98][7:4]-1]<=weights[inp[98][7:4]-1]+inp[98][11:8]<<count[inp[98][7:4]-1];
    count[inp[98][3:0]-1]=count[inp[98][3:0]-1]+1;
    count[inp[98][7:4]-1]=count[inp[98][7:4]-1]+1;
end
if (inp[99]!=0)begin
    connected[inp[99][3:0]-1]<=connected[inp[99][3:0]-1]+inp[99][7:4]<<count[inp[99][3:0]-1];
    connected[inp[99][7:4]-1]<=connected[inp[99][7:4]-1]+inp[99][3:0]<<count[inp[99][7:4]-1];
    weights[inp[99][3:0]-1]<=weights[inp[99][3:0]-1]+inp[99][11:8]<<count[inp[99][3:0]-1];
    weights[inp[99][7:4]-1]<=weights[inp[99][7:4]-1]+inp[99][11:8]<<count[inp[99][7:4]-1];
    count[inp[99][3:0]-1]=count[inp[99][3:0]-1]+1;
    count[inp[99][7:4]-1]=count[inp[99][7:4]-1]+1;
end
if (inp[100]!=0)begin
    connected[inp[100][3:0]-1]<=connected[inp[100][3:0]-1]+inp[100][7:4]<<count[inp[100][3:0]-1];
    connected[inp[100][7:4]-1]<=connected[inp[100][7:4]-1]+inp[100][3:0]<<count[inp[100][7:4]-1];
    weights[inp[100][3:0]-1]<=weights[inp[100][3:0]-1]+inp[100][11:8]<<count[inp[100][3:0]-1];
    weights[inp[100][7:4]-1]<=weights[inp[100][7:4]-1]+inp[100][11:8]<<count[inp[100][7:4]-1];
    count[inp[100][3:0]-1]=count[inp[100][3:0]-1]+1;
    count[inp[100][7:4]-1]=count[inp[100][7:4]-1]+1;
end
if (inp[101]!=0)begin
    connected[inp[101][3:0]-1]<=connected[inp[101][3:0]-1]+inp[101][7:4]<<count[inp[101][3:0]-1];
    connected[inp[101][7:4]-1]<=connected[inp[101][7:4]-1]+inp[101][3:0]<<count[inp[101][7:4]-1];
    weights[inp[101][3:0]-1]<=weights[inp[101][3:0]-1]+inp[101][11:8]<<count[inp[101][3:0]-1];
    weights[inp[101][7:4]-1]<=weights[inp[101][7:4]-1]+inp[101][11:8]<<count[inp[101][7:4]-1];
    count[inp[101][3:0]-1]=count[inp[101][3:0]-1]+1;
    count[inp[101][7:4]-1]=count[inp[101][7:4]-1]+1;
end
if (inp[102]!=0)begin
    connected[inp[102][3:0]-1]<=connected[inp[102][3:0]-1]+inp[102][7:4]<<count[inp[102][3:0]-1];
    connected[inp[102][7:4]-1]<=connected[inp[102][7:4]-1]+inp[102][3:0]<<count[inp[102][7:4]-1];
    weights[inp[102][3:0]-1]<=weights[inp[102][3:0]-1]+inp[102][11:8]<<count[inp[102][3:0]-1];
    weights[inp[102][7:4]-1]<=weights[inp[102][7:4]-1]+inp[102][11:8]<<count[inp[102][7:4]-1];
    count[inp[102][3:0]-1]=count[inp[102][3:0]-1]+1;
    count[inp[102][7:4]-1]=count[inp[102][7:4]-1]+1;
end
if (inp[103]!=0)begin
    connected[inp[103][3:0]-1]<=connected[inp[103][3:0]-1]+inp[103][7:4]<<count[inp[103][3:0]-1];
    connected[inp[103][7:4]-1]<=connected[inp[103][7:4]-1]+inp[103][3:0]<<count[inp[103][7:4]-1];
    weights[inp[103][3:0]-1]<=weights[inp[103][3:0]-1]+inp[103][11:8]<<count[inp[103][3:0]-1];
    weights[inp[103][7:4]-1]<=weights[inp[103][7:4]-1]+inp[103][11:8]<<count[inp[103][7:4]-1];
    count[inp[103][3:0]-1]=count[inp[103][3:0]-1]+1;
    count[inp[103][7:4]-1]=count[inp[103][7:4]-1]+1;
end
if (inp[104]!=0)begin
    connected[inp[104][3:0]-1]<=connected[inp[104][3:0]-1]+inp[104][7:4]<<count[inp[104][3:0]-1];
    connected[inp[104][7:4]-1]<=connected[inp[104][7:4]-1]+inp[104][3:0]<<count[inp[104][7:4]-1];
    weights[inp[104][3:0]-1]<=weights[inp[104][3:0]-1]+inp[104][11:8]<<count[inp[104][3:0]-1];
    weights[inp[104][7:4]-1]<=weights[inp[104][7:4]-1]+inp[104][11:8]<<count[inp[104][7:4]-1];
    count[inp[104][3:0]-1]=count[inp[104][3:0]-1]+1;
    count[inp[104][7:4]-1]=count[inp[104][7:4]-1]+1;
end
if (inp[105]!=0)begin
    connected[inp[105][3:0]-1]<=connected[inp[105][3:0]-1]+inp[105][7:4]<<count[inp[105][3:0]-1];
    connected[inp[105][7:4]-1]<=connected[inp[105][7:4]-1]+inp[105][3:0]<<count[inp[105][7:4]-1];
    weights[inp[105][3:0]-1]<=weights[inp[105][3:0]-1]+inp[105][11:8]<<count[inp[105][3:0]-1];
    weights[inp[105][7:4]-1]<=weights[inp[105][7:4]-1]+inp[105][11:8]<<count[inp[105][7:4]-1];
    count[inp[105][3:0]-1]=count[inp[105][3:0]-1]+1;
    count[inp[105][7:4]-1]=count[inp[105][7:4]-1]+1;
end
if (inp[106]!=0)begin
    connected[inp[106][3:0]-1]<=connected[inp[106][3:0]-1]+inp[106][7:4]<<count[inp[106][3:0]-1];
    connected[inp[106][7:4]-1]<=connected[inp[106][7:4]-1]+inp[106][3:0]<<count[inp[106][7:4]-1];
    weights[inp[106][3:0]-1]<=weights[inp[106][3:0]-1]+inp[106][11:8]<<count[inp[106][3:0]-1];
    weights[inp[106][7:4]-1]<=weights[inp[106][7:4]-1]+inp[106][11:8]<<count[inp[106][7:4]-1];
    count[inp[106][3:0]-1]=count[inp[106][3:0]-1]+1;
    count[inp[106][7:4]-1]=count[inp[106][7:4]-1]+1;
end
if (inp[107]!=0)begin
    connected[inp[107][3:0]-1]<=connected[inp[107][3:0]-1]+inp[107][7:4]<<count[inp[107][3:0]-1];
    connected[inp[107][7:4]-1]<=connected[inp[107][7:4]-1]+inp[107][3:0]<<count[inp[107][7:4]-1];
    weights[inp[107][3:0]-1]<=weights[inp[107][3:0]-1]+inp[107][11:8]<<count[inp[107][3:0]-1];
    weights[inp[107][7:4]-1]<=weights[inp[107][7:4]-1]+inp[107][11:8]<<count[inp[107][7:4]-1];
    count[inp[107][3:0]-1]=count[inp[107][3:0]-1]+1;
    count[inp[107][7:4]-1]=count[inp[107][7:4]-1]+1;
end
if (inp[108]!=0)begin
    connected[inp[108][3:0]-1]<=connected[inp[108][3:0]-1]+inp[108][7:4]<<count[inp[108][3:0]-1];
    connected[inp[108][7:4]-1]<=connected[inp[108][7:4]-1]+inp[108][3:0]<<count[inp[108][7:4]-1];
    weights[inp[108][3:0]-1]<=weights[inp[108][3:0]-1]+inp[108][11:8]<<count[inp[108][3:0]-1];
    weights[inp[108][7:4]-1]<=weights[inp[108][7:4]-1]+inp[108][11:8]<<count[inp[108][7:4]-1];
    count[inp[108][3:0]-1]=count[inp[108][3:0]-1]+1;
    count[inp[108][7:4]-1]=count[inp[108][7:4]-1]+1;
end
if (inp[109]!=0)begin
    connected[inp[109][3:0]-1]<=connected[inp[109][3:0]-1]+inp[109][7:4]<<count[inp[109][3:0]-1];
    connected[inp[109][7:4]-1]<=connected[inp[109][7:4]-1]+inp[109][3:0]<<count[inp[109][7:4]-1];
    weights[inp[109][3:0]-1]<=weights[inp[109][3:0]-1]+inp[109][11:8]<<count[inp[109][3:0]-1];
    weights[inp[109][7:4]-1]<=weights[inp[109][7:4]-1]+inp[109][11:8]<<count[inp[109][7:4]-1];
    count[inp[109][3:0]-1]=count[inp[109][3:0]-1]+1;
    count[inp[109][7:4]-1]=count[inp[109][7:4]-1]+1;
end
if (inp[110]!=0)begin
    connected[inp[110][3:0]-1]<=connected[inp[110][3:0]-1]+inp[110][7:4]<<count[inp[110][3:0]-1];
    connected[inp[110][7:4]-1]<=connected[inp[110][7:4]-1]+inp[110][3:0]<<count[inp[110][7:4]-1];
    weights[inp[110][3:0]-1]<=weights[inp[110][3:0]-1]+inp[110][11:8]<<count[inp[110][3:0]-1];
    weights[inp[110][7:4]-1]<=weights[inp[110][7:4]-1]+inp[110][11:8]<<count[inp[110][7:4]-1];
    count[inp[110][3:0]-1]=count[inp[110][3:0]-1]+1;
    count[inp[110][7:4]-1]=count[inp[110][7:4]-1]+1;
end
if (inp[111]!=0)begin
    connected[inp[111][3:0]-1]<=connected[inp[111][3:0]-1]+inp[111][7:4]<<count[inp[111][3:0]-1];
    connected[inp[111][7:4]-1]<=connected[inp[111][7:4]-1]+inp[111][3:0]<<count[inp[111][7:4]-1];
    weights[inp[111][3:0]-1]<=weights[inp[111][3:0]-1]+inp[111][11:8]<<count[inp[111][3:0]-1];
    weights[inp[111][7:4]-1]<=weights[inp[111][7:4]-1]+inp[111][11:8]<<count[inp[111][7:4]-1];
    count[inp[111][3:0]-1]=count[inp[111][3:0]-1]+1;
    count[inp[111][7:4]-1]=count[inp[111][7:4]-1]+1;
end
if (inp[112]!=0)begin
    connected[inp[112][3:0]-1]<=connected[inp[112][3:0]-1]+inp[112][7:4]<<count[inp[112][3:0]-1];
    connected[inp[112][7:4]-1]<=connected[inp[112][7:4]-1]+inp[112][3:0]<<count[inp[112][7:4]-1];
    weights[inp[112][3:0]-1]<=weights[inp[112][3:0]-1]+inp[112][11:8]<<count[inp[112][3:0]-1];
    weights[inp[112][7:4]-1]<=weights[inp[112][7:4]-1]+inp[112][11:8]<<count[inp[112][7:4]-1];
    count[inp[112][3:0]-1]=count[inp[112][3:0]-1]+1;
    count[inp[112][7:4]-1]=count[inp[112][7:4]-1]+1;
end
if (inp[113]!=0)begin
    connected[inp[113][3:0]-1]<=connected[inp[113][3:0]-1]+inp[113][7:4]<<count[inp[113][3:0]-1];
    connected[inp[113][7:4]-1]<=connected[inp[113][7:4]-1]+inp[113][3:0]<<count[inp[113][7:4]-1];
    weights[inp[113][3:0]-1]<=weights[inp[113][3:0]-1]+inp[113][11:8]<<count[inp[113][3:0]-1];
    weights[inp[113][7:4]-1]<=weights[inp[113][7:4]-1]+inp[113][11:8]<<count[inp[113][7:4]-1];
    count[inp[113][3:0]-1]=count[inp[113][3:0]-1]+1;
    count[inp[113][7:4]-1]=count[inp[113][7:4]-1]+1;
end
if (inp[114]!=0)begin
    connected[inp[114][3:0]-1]<=connected[inp[114][3:0]-1]+inp[114][7:4]<<count[inp[114][3:0]-1];
    connected[inp[114][7:4]-1]<=connected[inp[114][7:4]-1]+inp[114][3:0]<<count[inp[114][7:4]-1];
    weights[inp[114][3:0]-1]<=weights[inp[114][3:0]-1]+inp[114][11:8]<<count[inp[114][3:0]-1];
    weights[inp[114][7:4]-1]<=weights[inp[114][7:4]-1]+inp[114][11:8]<<count[inp[114][7:4]-1];
    count[inp[114][3:0]-1]=count[inp[114][3:0]-1]+1;
    count[inp[114][7:4]-1]=count[inp[114][7:4]-1]+1;
end
if (inp[115]!=0)begin
    connected[inp[115][3:0]-1]<=connected[inp[115][3:0]-1]+inp[115][7:4]<<count[inp[115][3:0]-1];
    connected[inp[115][7:4]-1]<=connected[inp[115][7:4]-1]+inp[115][3:0]<<count[inp[115][7:4]-1];
    weights[inp[115][3:0]-1]<=weights[inp[115][3:0]-1]+inp[115][11:8]<<count[inp[115][3:0]-1];
    weights[inp[115][7:4]-1]<=weights[inp[115][7:4]-1]+inp[115][11:8]<<count[inp[115][7:4]-1];
    count[inp[115][3:0]-1]=count[inp[115][3:0]-1]+1;
    count[inp[115][7:4]-1]=count[inp[115][7:4]-1]+1;
end
if (inp[116]!=0)begin
    connected[inp[116][3:0]-1]<=connected[inp[116][3:0]-1]+inp[116][7:4]<<count[inp[116][3:0]-1];
    connected[inp[116][7:4]-1]<=connected[inp[116][7:4]-1]+inp[116][3:0]<<count[inp[116][7:4]-1];
    weights[inp[116][3:0]-1]<=weights[inp[116][3:0]-1]+inp[116][11:8]<<count[inp[116][3:0]-1];
    weights[inp[116][7:4]-1]<=weights[inp[116][7:4]-1]+inp[116][11:8]<<count[inp[116][7:4]-1];
    count[inp[116][3:0]-1]=count[inp[116][3:0]-1]+1;
    count[inp[116][7:4]-1]=count[inp[116][7:4]-1]+1;
end
if (inp[117]!=0)begin
    connected[inp[117][3:0]-1]<=connected[inp[117][3:0]-1]+inp[117][7:4]<<count[inp[117][3:0]-1];
    connected[inp[117][7:4]-1]<=connected[inp[117][7:4]-1]+inp[117][3:0]<<count[inp[117][7:4]-1];
    weights[inp[117][3:0]-1]<=weights[inp[117][3:0]-1]+inp[117][11:8]<<count[inp[117][3:0]-1];
    weights[inp[117][7:4]-1]<=weights[inp[117][7:4]-1]+inp[117][11:8]<<count[inp[117][7:4]-1];
    count[inp[117][3:0]-1]=count[inp[117][3:0]-1]+1;
    count[inp[117][7:4]-1]=count[inp[117][7:4]-1]+1;
end
if (inp[118]!=0)begin
    connected[inp[118][3:0]-1]<=connected[inp[118][3:0]-1]+inp[118][7:4]<<count[inp[118][3:0]-1];
    connected[inp[118][7:4]-1]<=connected[inp[118][7:4]-1]+inp[118][3:0]<<count[inp[118][7:4]-1];
    weights[inp[118][3:0]-1]<=weights[inp[118][3:0]-1]+inp[118][11:8]<<count[inp[118][3:0]-1];
    weights[inp[118][7:4]-1]<=weights[inp[118][7:4]-1]+inp[118][11:8]<<count[inp[118][7:4]-1];
    count[inp[118][3:0]-1]=count[inp[118][3:0]-1]+1;
    count[inp[118][7:4]-1]=count[inp[118][7:4]-1]+1;
end
if (inp[119]!=0)begin
    connected[inp[119][3:0]-1]<=connected[inp[119][3:0]-1]+inp[119][7:4]<<count[inp[119][3:0]-1];
    connected[inp[119][7:4]-1]<=connected[inp[119][7:4]-1]+inp[119][3:0]<<count[inp[119][7:4]-1];
    weights[inp[119][3:0]-1]<=weights[inp[119][3:0]-1]+inp[119][11:8]<<count[inp[119][3:0]-1];
    weights[inp[119][7:4]-1]<=weights[inp[119][7:4]-1]+inp[119][11:8]<<count[inp[119][7:4]-1];
    count[inp[119][3:0]-1]=count[inp[119][3:0]-1]+1;
    count[inp[119][7:4]-1]=count[inp[119][7:4]-1]+1;
end
if (inp[120]!=0)begin
    connected[inp[120][3:0]-1]<=connected[inp[120][3:0]-1]+inp[120][7:4]<<count[inp[120][3:0]-1];
    connected[inp[120][7:4]-1]<=connected[inp[120][7:4]-1]+inp[120][3:0]<<count[inp[120][7:4]-1];
    weights[inp[120][3:0]-1]<=weights[inp[120][3:0]-1]+inp[120][11:8]<<count[inp[120][3:0]-1];
    weights[inp[120][7:4]-1]<=weights[inp[120][7:4]-1]+inp[120][11:8]<<count[inp[120][7:4]-1];
    count[inp[120][3:0]-1]=count[inp[120][3:0]-1]+1;
    count[inp[120][7:4]-1]=count[inp[120][7:4]-1]+1;
end
if (inp[121]!=0)begin
    connected[inp[121][3:0]-1]<=connected[inp[121][3:0]-1]+inp[121][7:4]<<count[inp[121][3:0]-1];
    connected[inp[121][7:4]-1]<=connected[inp[121][7:4]-1]+inp[121][3:0]<<count[inp[121][7:4]-1];
    weights[inp[121][3:0]-1]<=weights[inp[121][3:0]-1]+inp[121][11:8]<<count[inp[121][3:0]-1];
    weights[inp[121][7:4]-1]<=weights[inp[121][7:4]-1]+inp[121][11:8]<<count[inp[121][7:4]-1];
    count[inp[121][3:0]-1]=count[inp[121][3:0]-1]+1;
    count[inp[121][7:4]-1]=count[inp[121][7:4]-1]+1;
end
if (inp[122]!=0)begin
    connected[inp[122][3:0]-1]<=connected[inp[122][3:0]-1]+inp[122][7:4]<<count[inp[122][3:0]-1];
    connected[inp[122][7:4]-1]<=connected[inp[122][7:4]-1]+inp[122][3:0]<<count[inp[122][7:4]-1];
    weights[inp[122][3:0]-1]<=weights[inp[122][3:0]-1]+inp[122][11:8]<<count[inp[122][3:0]-1];
    weights[inp[122][7:4]-1]<=weights[inp[122][7:4]-1]+inp[122][11:8]<<count[inp[122][7:4]-1];
    count[inp[122][3:0]-1]=count[inp[122][3:0]-1]+1;
    count[inp[122][7:4]-1]=count[inp[122][7:4]-1]+1;
end
if (inp[123]!=0)begin
    connected[inp[123][3:0]-1]<=connected[inp[123][3:0]-1]+inp[123][7:4]<<count[inp[123][3:0]-1];
    connected[inp[123][7:4]-1]<=connected[inp[123][7:4]-1]+inp[123][3:0]<<count[inp[123][7:4]-1];
    weights[inp[123][3:0]-1]<=weights[inp[123][3:0]-1]+inp[123][11:8]<<count[inp[123][3:0]-1];
    weights[inp[123][7:4]-1]<=weights[inp[123][7:4]-1]+inp[123][11:8]<<count[inp[123][7:4]-1];
    count[inp[123][3:0]-1]=count[inp[123][3:0]-1]+1;
    count[inp[123][7:4]-1]=count[inp[123][7:4]-1]+1;
end
if (inp[124]!=0)begin
    connected[inp[124][3:0]-1]<=connected[inp[124][3:0]-1]+inp[124][7:4]<<count[inp[124][3:0]-1];
    connected[inp[124][7:4]-1]<=connected[inp[124][7:4]-1]+inp[124][3:0]<<count[inp[124][7:4]-1];
    weights[inp[124][3:0]-1]<=weights[inp[124][3:0]-1]+inp[124][11:8]<<count[inp[124][3:0]-1];
    weights[inp[124][7:4]-1]<=weights[inp[124][7:4]-1]+inp[124][11:8]<<count[inp[124][7:4]-1];
    count[inp[124][3:0]-1]=count[inp[124][3:0]-1]+1;
    count[inp[124][7:4]-1]=count[inp[124][7:4]-1]+1;
end
if (inp[125]!=0)begin
    connected[inp[125][3:0]-1]<=connected[inp[125][3:0]-1]+inp[125][7:4]<<count[inp[125][3:0]-1];
    connected[inp[125][7:4]-1]<=connected[inp[125][7:4]-1]+inp[125][3:0]<<count[inp[125][7:4]-1];
    weights[inp[125][3:0]-1]<=weights[inp[125][3:0]-1]+inp[125][11:8]<<count[inp[125][3:0]-1];
    weights[inp[125][7:4]-1]<=weights[inp[125][7:4]-1]+inp[125][11:8]<<count[inp[125][7:4]-1];
    count[inp[125][3:0]-1]=count[inp[125][3:0]-1]+1;
    count[inp[125][7:4]-1]=count[inp[125][7:4]-1]+1;
end
if (inp[126]!=0)begin
    connected[inp[126][3:0]-1]<=connected[inp[126][3:0]-1]+inp[126][7:4]<<count[inp[126][3:0]-1];
    connected[inp[126][7:4]-1]<=connected[inp[126][7:4]-1]+inp[126][3:0]<<count[inp[126][7:4]-1];
    weights[inp[126][3:0]-1]<=weights[inp[126][3:0]-1]+inp[126][11:8]<<count[inp[126][3:0]-1];
    weights[inp[126][7:4]-1]<=weights[inp[126][7:4]-1]+inp[126][11:8]<<count[inp[126][7:4]-1];
    count[inp[126][3:0]-1]=count[inp[126][3:0]-1]+1;
    count[inp[126][7:4]-1]=count[inp[126][7:4]-1]+1;
end
if (inp[127]!=0)begin
    connected[inp[127][3:0]-1]<=connected[inp[127][3:0]-1]+inp[127][7:4]<<count[inp[127][3:0]-1];
    connected[inp[127][7:4]-1]<=connected[inp[127][7:4]-1]+inp[127][3:0]<<count[inp[127][7:4]-1];
    weights[inp[127][3:0]-1]<=weights[inp[127][3:0]-1]+inp[127][11:8]<<count[inp[127][3:0]-1];
    weights[inp[127][7:4]-1]<=weights[inp[127][7:4]-1]+inp[127][11:8]<<count[inp[127][7:4]-1];
    count[inp[127][3:0]-1]=count[inp[127][3:0]-1]+1;
    count[inp[127][7:4]-1]=count[inp[127][7:4]-1]+1;
end
if (inp[128]!=0)begin
    connected[inp[128][3:0]-1]<=connected[inp[128][3:0]-1]+inp[128][7:4]<<count[inp[128][3:0]-1];
    connected[inp[128][7:4]-1]<=connected[inp[128][7:4]-1]+inp[128][3:0]<<count[inp[128][7:4]-1];
    weights[inp[128][3:0]-1]<=weights[inp[128][3:0]-1]+inp[128][11:8]<<count[inp[128][3:0]-1];
    weights[inp[128][7:4]-1]<=weights[inp[128][7:4]-1]+inp[128][11:8]<<count[inp[128][7:4]-1];
    count[inp[128][3:0]-1]=count[inp[128][3:0]-1]+1;
    count[inp[128][7:4]-1]=count[inp[128][7:4]-1]+1;
end
if (inp[129]!=0)begin
    connected[inp[129][3:0]-1]<=connected[inp[129][3:0]-1]+inp[129][7:4]<<count[inp[129][3:0]-1];
    connected[inp[129][7:4]-1]<=connected[inp[129][7:4]-1]+inp[129][3:0]<<count[inp[129][7:4]-1];
    weights[inp[129][3:0]-1]<=weights[inp[129][3:0]-1]+inp[129][11:8]<<count[inp[129][3:0]-1];
    weights[inp[129][7:4]-1]<=weights[inp[129][7:4]-1]+inp[129][11:8]<<count[inp[129][7:4]-1];
    count[inp[129][3:0]-1]=count[inp[129][3:0]-1]+1;
    count[inp[129][7:4]-1]=count[inp[129][7:4]-1]+1;
end
if (inp[130]!=0)begin
    connected[inp[130][3:0]-1]<=connected[inp[130][3:0]-1]+inp[130][7:4]<<count[inp[130][3:0]-1];
    connected[inp[130][7:4]-1]<=connected[inp[130][7:4]-1]+inp[130][3:0]<<count[inp[130][7:4]-1];
    weights[inp[130][3:0]-1]<=weights[inp[130][3:0]-1]+inp[130][11:8]<<count[inp[130][3:0]-1];
    weights[inp[130][7:4]-1]<=weights[inp[130][7:4]-1]+inp[130][11:8]<<count[inp[130][7:4]-1];
    count[inp[130][3:0]-1]=count[inp[130][3:0]-1]+1;
    count[inp[130][7:4]-1]=count[inp[130][7:4]-1]+1;
end
if (inp[131]!=0)begin
    connected[inp[131][3:0]-1]<=connected[inp[131][3:0]-1]+inp[131][7:4]<<count[inp[131][3:0]-1];
    connected[inp[131][7:4]-1]<=connected[inp[131][7:4]-1]+inp[131][3:0]<<count[inp[131][7:4]-1];
    weights[inp[131][3:0]-1]<=weights[inp[131][3:0]-1]+inp[131][11:8]<<count[inp[131][3:0]-1];
    weights[inp[131][7:4]-1]<=weights[inp[131][7:4]-1]+inp[131][11:8]<<count[inp[131][7:4]-1];
    count[inp[131][3:0]-1]=count[inp[131][3:0]-1]+1;
    count[inp[131][7:4]-1]=count[inp[131][7:4]-1]+1;
end
if (inp[132]!=0)begin
    connected[inp[132][3:0]-1]<=connected[inp[132][3:0]-1]+inp[132][7:4]<<count[inp[132][3:0]-1];
    connected[inp[132][7:4]-1]<=connected[inp[132][7:4]-1]+inp[132][3:0]<<count[inp[132][7:4]-1];
    weights[inp[132][3:0]-1]<=weights[inp[132][3:0]-1]+inp[132][11:8]<<count[inp[132][3:0]-1];
    weights[inp[132][7:4]-1]<=weights[inp[132][7:4]-1]+inp[132][11:8]<<count[inp[132][7:4]-1];
    count[inp[132][3:0]-1]=count[inp[132][3:0]-1]+1;
    count[inp[132][7:4]-1]=count[inp[132][7:4]-1]+1;
end
if (inp[133]!=0)begin
    connected[inp[133][3:0]-1]<=connected[inp[133][3:0]-1]+inp[133][7:4]<<count[inp[133][3:0]-1];
    connected[inp[133][7:4]-1]<=connected[inp[133][7:4]-1]+inp[133][3:0]<<count[inp[133][7:4]-1];
    weights[inp[133][3:0]-1]<=weights[inp[133][3:0]-1]+inp[133][11:8]<<count[inp[133][3:0]-1];
    weights[inp[133][7:4]-1]<=weights[inp[133][7:4]-1]+inp[133][11:8]<<count[inp[133][7:4]-1];
    count[inp[133][3:0]-1]=count[inp[133][3:0]-1]+1;
    count[inp[133][7:4]-1]=count[inp[133][7:4]-1]+1;
end
if (inp[134]!=0)begin
    connected[inp[134][3:0]-1]<=connected[inp[134][3:0]-1]+inp[134][7:4]<<count[inp[134][3:0]-1];
    connected[inp[134][7:4]-1]<=connected[inp[134][7:4]-1]+inp[134][3:0]<<count[inp[134][7:4]-1];
    weights[inp[134][3:0]-1]<=weights[inp[134][3:0]-1]+inp[134][11:8]<<count[inp[134][3:0]-1];
    weights[inp[134][7:4]-1]<=weights[inp[134][7:4]-1]+inp[134][11:8]<<count[inp[134][7:4]-1];
    count[inp[134][3:0]-1]=count[inp[134][3:0]-1]+1;
    count[inp[134][7:4]-1]=count[inp[134][7:4]-1]+1;
end
if (inp[135]!=0)begin
    connected[inp[135][3:0]-1]<=connected[inp[135][3:0]-1]+inp[135][7:4]<<count[inp[135][3:0]-1];
    connected[inp[135][7:4]-1]<=connected[inp[135][7:4]-1]+inp[135][3:0]<<count[inp[135][7:4]-1];
    weights[inp[135][3:0]-1]<=weights[inp[135][3:0]-1]+inp[135][11:8]<<count[inp[135][3:0]-1];
    weights[inp[135][7:4]-1]<=weights[inp[135][7:4]-1]+inp[135][11:8]<<count[inp[135][7:4]-1];
    count[inp[135][3:0]-1]=count[inp[135][3:0]-1]+1;
    count[inp[135][7:4]-1]=count[inp[135][7:4]-1]+1;
end
if (inp[136]!=0)begin
    connected[inp[136][3:0]-1]<=connected[inp[136][3:0]-1]+inp[136][7:4]<<count[inp[136][3:0]-1];
    connected[inp[136][7:4]-1]<=connected[inp[136][7:4]-1]+inp[136][3:0]<<count[inp[136][7:4]-1];
    weights[inp[136][3:0]-1]<=weights[inp[136][3:0]-1]+inp[136][11:8]<<count[inp[136][3:0]-1];
    weights[inp[136][7:4]-1]<=weights[inp[136][7:4]-1]+inp[136][11:8]<<count[inp[136][7:4]-1];
    count[inp[136][3:0]-1]=count[inp[136][3:0]-1]+1;
    count[inp[136][7:4]-1]=count[inp[136][7:4]-1]+1;
end
if (inp[137]!=0)begin
    connected[inp[137][3:0]-1]<=connected[inp[137][3:0]-1]+inp[137][7:4]<<count[inp[137][3:0]-1];
    connected[inp[137][7:4]-1]<=connected[inp[137][7:4]-1]+inp[137][3:0]<<count[inp[137][7:4]-1];
    weights[inp[137][3:0]-1]<=weights[inp[137][3:0]-1]+inp[137][11:8]<<count[inp[137][3:0]-1];
    weights[inp[137][7:4]-1]<=weights[inp[137][7:4]-1]+inp[137][11:8]<<count[inp[137][7:4]-1];
    count[inp[137][3:0]-1]=count[inp[137][3:0]-1]+1;
    count[inp[137][7:4]-1]=count[inp[137][7:4]-1]+1;
end
if (inp[138]!=0)begin
    connected[inp[138][3:0]-1]<=connected[inp[138][3:0]-1]+inp[138][7:4]<<count[inp[138][3:0]-1];
    connected[inp[138][7:4]-1]<=connected[inp[138][7:4]-1]+inp[138][3:0]<<count[inp[138][7:4]-1];
    weights[inp[138][3:0]-1]<=weights[inp[138][3:0]-1]+inp[138][11:8]<<count[inp[138][3:0]-1];
    weights[inp[138][7:4]-1]<=weights[inp[138][7:4]-1]+inp[138][11:8]<<count[inp[138][7:4]-1];
    count[inp[138][3:0]-1]=count[inp[138][3:0]-1]+1;
    count[inp[138][7:4]-1]=count[inp[138][7:4]-1]+1;
end
if (inp[139]!=0)begin
    connected[inp[139][3:0]-1]<=connected[inp[139][3:0]-1]+inp[139][7:4]<<count[inp[139][3:0]-1];
    connected[inp[139][7:4]-1]<=connected[inp[139][7:4]-1]+inp[139][3:0]<<count[inp[139][7:4]-1];
    weights[inp[139][3:0]-1]<=weights[inp[139][3:0]-1]+inp[139][11:8]<<count[inp[139][3:0]-1];
    weights[inp[139][7:4]-1]<=weights[inp[139][7:4]-1]+inp[139][11:8]<<count[inp[139][7:4]-1];
    count[inp[139][3:0]-1]=count[inp[139][3:0]-1]+1;
    count[inp[139][7:4]-1]=count[inp[139][7:4]-1]+1;
end
if (inp[140]!=0)begin
    connected[inp[140][3:0]-1]<=connected[inp[140][3:0]-1]+inp[140][7:4]<<count[inp[140][3:0]-1];
    connected[inp[140][7:4]-1]<=connected[inp[140][7:4]-1]+inp[140][3:0]<<count[inp[140][7:4]-1];
    weights[inp[140][3:0]-1]<=weights[inp[140][3:0]-1]+inp[140][11:8]<<count[inp[140][3:0]-1];
    weights[inp[140][7:4]-1]<=weights[inp[140][7:4]-1]+inp[140][11:8]<<count[inp[140][7:4]-1];
    count[inp[140][3:0]-1]=count[inp[140][3:0]-1]+1;
    count[inp[140][7:4]-1]=count[inp[140][7:4]-1]+1;
end
if (inp[141]!=0)begin
    connected[inp[141][3:0]-1]<=connected[inp[141][3:0]-1]+inp[141][7:4]<<count[inp[141][3:0]-1];
    connected[inp[141][7:4]-1]<=connected[inp[141][7:4]-1]+inp[141][3:0]<<count[inp[141][7:4]-1];
    weights[inp[141][3:0]-1]<=weights[inp[141][3:0]-1]+inp[141][11:8]<<count[inp[141][3:0]-1];
    weights[inp[141][7:4]-1]<=weights[inp[141][7:4]-1]+inp[141][11:8]<<count[inp[141][7:4]-1];
    count[inp[141][3:0]-1]=count[inp[141][3:0]-1]+1;
    count[inp[141][7:4]-1]=count[inp[141][7:4]-1]+1;
end
if (inp[142]!=0)begin
    connected[inp[142][3:0]-1]<=connected[inp[142][3:0]-1]+inp[142][7:4]<<count[inp[142][3:0]-1];
    connected[inp[142][7:4]-1]<=connected[inp[142][7:4]-1]+inp[142][3:0]<<count[inp[142][7:4]-1];
    weights[inp[142][3:0]-1]<=weights[inp[142][3:0]-1]+inp[142][11:8]<<count[inp[142][3:0]-1];
    weights[inp[142][7:4]-1]<=weights[inp[142][7:4]-1]+inp[142][11:8]<<count[inp[142][7:4]-1];
    count[inp[142][3:0]-1]=count[inp[142][3:0]-1]+1;
    count[inp[142][7:4]-1]=count[inp[142][7:4]-1]+1;
end
if (inp[143]!=0)begin
    connected[inp[143][3:0]-1]<=connected[inp[143][3:0]-1]+inp[143][7:4]<<count[inp[143][3:0]-1];
    connected[inp[143][7:4]-1]<=connected[inp[143][7:4]-1]+inp[143][3:0]<<count[inp[143][7:4]-1];
    weights[inp[143][3:0]-1]<=weights[inp[143][3:0]-1]+inp[143][11:8]<<count[inp[143][3:0]-1];
    weights[inp[143][7:4]-1]<=weights[inp[143][7:4]-1]+inp[143][11:8]<<count[inp[143][7:4]-1];
    count[inp[143][3:0]-1]=count[inp[143][3:0]-1]+1;
    count[inp[143][7:4]-1]=count[inp[143][7:4]-1]+1;
end
if (inp[144]!=0)begin
    connected[inp[144][3:0]-1]<=connected[inp[144][3:0]-1]+inp[144][7:4]<<count[inp[144][3:0]-1];
    connected[inp[144][7:4]-1]<=connected[inp[144][7:4]-1]+inp[144][3:0]<<count[inp[144][7:4]-1];
    weights[inp[144][3:0]-1]<=weights[inp[144][3:0]-1]+inp[144][11:8]<<count[inp[144][3:0]-1];
    weights[inp[144][7:4]-1]<=weights[inp[144][7:4]-1]+inp[144][11:8]<<count[inp[144][7:4]-1];
    count[inp[144][3:0]-1]=count[inp[144][3:0]-1]+1;
    count[inp[144][7:4]-1]=count[inp[144][7:4]-1]+1;
end
if (inp[145]!=0)begin
    connected[inp[145][3:0]-1]<=connected[inp[145][3:0]-1]+inp[145][7:4]<<count[inp[145][3:0]-1];
    connected[inp[145][7:4]-1]<=connected[inp[145][7:4]-1]+inp[145][3:0]<<count[inp[145][7:4]-1];
    weights[inp[145][3:0]-1]<=weights[inp[145][3:0]-1]+inp[145][11:8]<<count[inp[145][3:0]-1];
    weights[inp[145][7:4]-1]<=weights[inp[145][7:4]-1]+inp[145][11:8]<<count[inp[145][7:4]-1];
    count[inp[145][3:0]-1]=count[inp[145][3:0]-1]+1;
    count[inp[145][7:4]-1]=count[inp[145][7:4]-1]+1;
end
if (inp[146]!=0)begin
    connected[inp[146][3:0]-1]<=connected[inp[146][3:0]-1]+inp[146][7:4]<<count[inp[146][3:0]-1];
    connected[inp[146][7:4]-1]<=connected[inp[146][7:4]-1]+inp[146][3:0]<<count[inp[146][7:4]-1];
    weights[inp[146][3:0]-1]<=weights[inp[146][3:0]-1]+inp[146][11:8]<<count[inp[146][3:0]-1];
    weights[inp[146][7:4]-1]<=weights[inp[146][7:4]-1]+inp[146][11:8]<<count[inp[146][7:4]-1];
    count[inp[146][3:0]-1]=count[inp[146][3:0]-1]+1;
    count[inp[146][7:4]-1]=count[inp[146][7:4]-1]+1;
end
if (inp[147]!=0)begin
    connected[inp[147][3:0]-1]<=connected[inp[147][3:0]-1]+inp[147][7:4]<<count[inp[147][3:0]-1];
    connected[inp[147][7:4]-1]<=connected[inp[147][7:4]-1]+inp[147][3:0]<<count[inp[147][7:4]-1];
    weights[inp[147][3:0]-1]<=weights[inp[147][3:0]-1]+inp[147][11:8]<<count[inp[147][3:0]-1];
    weights[inp[147][7:4]-1]<=weights[inp[147][7:4]-1]+inp[147][11:8]<<count[inp[147][7:4]-1];
    count[inp[147][3:0]-1]=count[inp[147][3:0]-1]+1;
    count[inp[147][7:4]-1]=count[inp[147][7:4]-1]+1;
end
if (inp[148]!=0)begin
    connected[inp[148][3:0]-1]<=connected[inp[148][3:0]-1]+inp[148][7:4]<<count[inp[148][3:0]-1];
    connected[inp[148][7:4]-1]<=connected[inp[148][7:4]-1]+inp[148][3:0]<<count[inp[148][7:4]-1];
    weights[inp[148][3:0]-1]<=weights[inp[148][3:0]-1]+inp[148][11:8]<<count[inp[148][3:0]-1];
    weights[inp[148][7:4]-1]<=weights[inp[148][7:4]-1]+inp[148][11:8]<<count[inp[148][7:4]-1];
    count[inp[148][3:0]-1]=count[inp[148][3:0]-1]+1;
    count[inp[148][7:4]-1]=count[inp[148][7:4]-1]+1;
end
if (inp[149]!=0)begin
    connected[inp[149][3:0]-1]<=connected[inp[149][3:0]-1]+inp[149][7:4]<<count[inp[149][3:0]-1];
    connected[inp[149][7:4]-1]<=connected[inp[149][7:4]-1]+inp[149][3:0]<<count[inp[149][7:4]-1];
    weights[inp[149][3:0]-1]<=weights[inp[149][3:0]-1]+inp[149][11:8]<<count[inp[149][3:0]-1];
    weights[inp[149][7:4]-1]<=weights[inp[149][7:4]-1]+inp[149][11:8]<<count[inp[149][7:4]-1];
    count[inp[149][3:0]-1]=count[inp[149][3:0]-1]+1;
    count[inp[149][7:4]-1]=count[inp[149][7:4]-1]+1;
end
if (inp[150]!=0)begin
    connected[inp[150][3:0]-1]<=connected[inp[150][3:0]-1]+inp[150][7:4]<<count[inp[150][3:0]-1];
    connected[inp[150][7:4]-1]<=connected[inp[150][7:4]-1]+inp[150][3:0]<<count[inp[150][7:4]-1];
    weights[inp[150][3:0]-1]<=weights[inp[150][3:0]-1]+inp[150][11:8]<<count[inp[150][3:0]-1];
    weights[inp[150][7:4]-1]<=weights[inp[150][7:4]-1]+inp[150][11:8]<<count[inp[150][7:4]-1];
    count[inp[150][3:0]-1]=count[inp[150][3:0]-1]+1;
    count[inp[150][7:4]-1]=count[inp[150][7:4]-1]+1;
end
if (inp[151]!=0)begin
    connected[inp[151][3:0]-1]<=connected[inp[151][3:0]-1]+inp[151][7:4]<<count[inp[151][3:0]-1];
    connected[inp[151][7:4]-1]<=connected[inp[151][7:4]-1]+inp[151][3:0]<<count[inp[151][7:4]-1];
    weights[inp[151][3:0]-1]<=weights[inp[151][3:0]-1]+inp[151][11:8]<<count[inp[151][3:0]-1];
    weights[inp[151][7:4]-1]<=weights[inp[151][7:4]-1]+inp[151][11:8]<<count[inp[151][7:4]-1];
    count[inp[151][3:0]-1]=count[inp[151][3:0]-1]+1;
    count[inp[151][7:4]-1]=count[inp[151][7:4]-1]+1;
end
if (inp[152]!=0)begin
    connected[inp[152][3:0]-1]<=connected[inp[152][3:0]-1]+inp[152][7:4]<<count[inp[152][3:0]-1];
    connected[inp[152][7:4]-1]<=connected[inp[152][7:4]-1]+inp[152][3:0]<<count[inp[152][7:4]-1];
    weights[inp[152][3:0]-1]<=weights[inp[152][3:0]-1]+inp[152][11:8]<<count[inp[152][3:0]-1];
    weights[inp[152][7:4]-1]<=weights[inp[152][7:4]-1]+inp[152][11:8]<<count[inp[152][7:4]-1];
    count[inp[152][3:0]-1]=count[inp[152][3:0]-1]+1;
    count[inp[152][7:4]-1]=count[inp[152][7:4]-1]+1;
end
if (inp[153]!=0)begin
    connected[inp[153][3:0]-1]<=connected[inp[153][3:0]-1]+inp[153][7:4]<<count[inp[153][3:0]-1];
    connected[inp[153][7:4]-1]<=connected[inp[153][7:4]-1]+inp[153][3:0]<<count[inp[153][7:4]-1];
    weights[inp[153][3:0]-1]<=weights[inp[153][3:0]-1]+inp[153][11:8]<<count[inp[153][3:0]-1];
    weights[inp[153][7:4]-1]<=weights[inp[153][7:4]-1]+inp[153][11:8]<<count[inp[153][7:4]-1];
    count[inp[153][3:0]-1]=count[inp[153][3:0]-1]+1;
    count[inp[153][7:4]-1]=count[inp[153][7:4]-1]+1;
end
if (inp[154]!=0)begin
    connected[inp[154][3:0]-1]<=connected[inp[154][3:0]-1]+inp[154][7:4]<<count[inp[154][3:0]-1];
    connected[inp[154][7:4]-1]<=connected[inp[154][7:4]-1]+inp[154][3:0]<<count[inp[154][7:4]-1];
    weights[inp[154][3:0]-1]<=weights[inp[154][3:0]-1]+inp[154][11:8]<<count[inp[154][3:0]-1];
    weights[inp[154][7:4]-1]<=weights[inp[154][7:4]-1]+inp[154][11:8]<<count[inp[154][7:4]-1];
    count[inp[154][3:0]-1]=count[inp[154][3:0]-1]+1;
    count[inp[154][7:4]-1]=count[inp[154][7:4]-1]+1;
end
if (inp[155]!=0)begin
    connected[inp[155][3:0]-1]<=connected[inp[155][3:0]-1]+inp[155][7:4]<<count[inp[155][3:0]-1];
    connected[inp[155][7:4]-1]<=connected[inp[155][7:4]-1]+inp[155][3:0]<<count[inp[155][7:4]-1];
    weights[inp[155][3:0]-1]<=weights[inp[155][3:0]-1]+inp[155][11:8]<<count[inp[155][3:0]-1];
    weights[inp[155][7:4]-1]<=weights[inp[155][7:4]-1]+inp[155][11:8]<<count[inp[155][7:4]-1];
    count[inp[155][3:0]-1]=count[inp[155][3:0]-1]+1;
    count[inp[155][7:4]-1]=count[inp[155][7:4]-1]+1;
end
if (inp[156]!=0)begin
    connected[inp[156][3:0]-1]<=connected[inp[156][3:0]-1]+inp[156][7:4]<<count[inp[156][3:0]-1];
    connected[inp[156][7:4]-1]<=connected[inp[156][7:4]-1]+inp[156][3:0]<<count[inp[156][7:4]-1];
    weights[inp[156][3:0]-1]<=weights[inp[156][3:0]-1]+inp[156][11:8]<<count[inp[156][3:0]-1];
    weights[inp[156][7:4]-1]<=weights[inp[156][7:4]-1]+inp[156][11:8]<<count[inp[156][7:4]-1];
    count[inp[156][3:0]-1]=count[inp[156][3:0]-1]+1;
    count[inp[156][7:4]-1]=count[inp[156][7:4]-1]+1;
end
if (inp[157]!=0)begin
    connected[inp[157][3:0]-1]<=connected[inp[157][3:0]-1]+inp[157][7:4]<<count[inp[157][3:0]-1];
    connected[inp[157][7:4]-1]<=connected[inp[157][7:4]-1]+inp[157][3:0]<<count[inp[157][7:4]-1];
    weights[inp[157][3:0]-1]<=weights[inp[157][3:0]-1]+inp[157][11:8]<<count[inp[157][3:0]-1];
    weights[inp[157][7:4]-1]<=weights[inp[157][7:4]-1]+inp[157][11:8]<<count[inp[157][7:4]-1];
    count[inp[157][3:0]-1]=count[inp[157][3:0]-1]+1;
    count[inp[157][7:4]-1]=count[inp[157][7:4]-1]+1;
end
if (inp[158]!=0)begin
    connected[inp[158][3:0]-1]<=connected[inp[158][3:0]-1]+inp[158][7:4]<<count[inp[158][3:0]-1];
    connected[inp[158][7:4]-1]<=connected[inp[158][7:4]-1]+inp[158][3:0]<<count[inp[158][7:4]-1];
    weights[inp[158][3:0]-1]<=weights[inp[158][3:0]-1]+inp[158][11:8]<<count[inp[158][3:0]-1];
    weights[inp[158][7:4]-1]<=weights[inp[158][7:4]-1]+inp[158][11:8]<<count[inp[158][7:4]-1];
    count[inp[158][3:0]-1]=count[inp[158][3:0]-1]+1;
    count[inp[158][7:4]-1]=count[inp[158][7:4]-1]+1;
end
if (inp[159]!=0)begin
    connected[inp[159][3:0]-1]<=connected[inp[159][3:0]-1]+inp[159][7:4]<<count[inp[159][3:0]-1];
    connected[inp[159][7:4]-1]<=connected[inp[159][7:4]-1]+inp[159][3:0]<<count[inp[159][7:4]-1];
    weights[inp[159][3:0]-1]<=weights[inp[159][3:0]-1]+inp[159][11:8]<<count[inp[159][3:0]-1];
    weights[inp[159][7:4]-1]<=weights[inp[159][7:4]-1]+inp[159][11:8]<<count[inp[159][7:4]-1];
    count[inp[159][3:0]-1]=count[inp[159][3:0]-1]+1;
    count[inp[159][7:4]-1]=count[inp[159][7:4]-1]+1;
end
if (inp[160]!=0)begin
    connected[inp[160][3:0]-1]<=connected[inp[160][3:0]-1]+inp[160][7:4]<<count[inp[160][3:0]-1];
    connected[inp[160][7:4]-1]<=connected[inp[160][7:4]-1]+inp[160][3:0]<<count[inp[160][7:4]-1];
    weights[inp[160][3:0]-1]<=weights[inp[160][3:0]-1]+inp[160][11:8]<<count[inp[160][3:0]-1];
    weights[inp[160][7:4]-1]<=weights[inp[160][7:4]-1]+inp[160][11:8]<<count[inp[160][7:4]-1];
    count[inp[160][3:0]-1]=count[inp[160][3:0]-1]+1;
    count[inp[160][7:4]-1]=count[inp[160][7:4]-1]+1;
end
if (inp[161]!=0)begin
    connected[inp[161][3:0]-1]<=connected[inp[161][3:0]-1]+inp[161][7:4]<<count[inp[161][3:0]-1];
    connected[inp[161][7:4]-1]<=connected[inp[161][7:4]-1]+inp[161][3:0]<<count[inp[161][7:4]-1];
    weights[inp[161][3:0]-1]<=weights[inp[161][3:0]-1]+inp[161][11:8]<<count[inp[161][3:0]-1];
    weights[inp[161][7:4]-1]<=weights[inp[161][7:4]-1]+inp[161][11:8]<<count[inp[161][7:4]-1];
    count[inp[161][3:0]-1]=count[inp[161][3:0]-1]+1;
    count[inp[161][7:4]-1]=count[inp[161][7:4]-1]+1;
end
if (inp[162]!=0)begin
    connected[inp[162][3:0]-1]<=connected[inp[162][3:0]-1]+inp[162][7:4]<<count[inp[162][3:0]-1];
    connected[inp[162][7:4]-1]<=connected[inp[162][7:4]-1]+inp[162][3:0]<<count[inp[162][7:4]-1];
    weights[inp[162][3:0]-1]<=weights[inp[162][3:0]-1]+inp[162][11:8]<<count[inp[162][3:0]-1];
    weights[inp[162][7:4]-1]<=weights[inp[162][7:4]-1]+inp[162][11:8]<<count[inp[162][7:4]-1];
    count[inp[162][3:0]-1]=count[inp[162][3:0]-1]+1;
    count[inp[162][7:4]-1]=count[inp[162][7:4]-1]+1;
end
if (inp[163]!=0)begin
    connected[inp[163][3:0]-1]<=connected[inp[163][3:0]-1]+inp[163][7:4]<<count[inp[163][3:0]-1];
    connected[inp[163][7:4]-1]<=connected[inp[163][7:4]-1]+inp[163][3:0]<<count[inp[163][7:4]-1];
    weights[inp[163][3:0]-1]<=weights[inp[163][3:0]-1]+inp[163][11:8]<<count[inp[163][3:0]-1];
    weights[inp[163][7:4]-1]<=weights[inp[163][7:4]-1]+inp[163][11:8]<<count[inp[163][7:4]-1];
    count[inp[163][3:0]-1]=count[inp[163][3:0]-1]+1;
    count[inp[163][7:4]-1]=count[inp[163][7:4]-1]+1;
end
if (inp[164]!=0)begin
    connected[inp[164][3:0]-1]<=connected[inp[164][3:0]-1]+inp[164][7:4]<<count[inp[164][3:0]-1];
    connected[inp[164][7:4]-1]<=connected[inp[164][7:4]-1]+inp[164][3:0]<<count[inp[164][7:4]-1];
    weights[inp[164][3:0]-1]<=weights[inp[164][3:0]-1]+inp[164][11:8]<<count[inp[164][3:0]-1];
    weights[inp[164][7:4]-1]<=weights[inp[164][7:4]-1]+inp[164][11:8]<<count[inp[164][7:4]-1];
    count[inp[164][3:0]-1]=count[inp[164][3:0]-1]+1;
    count[inp[164][7:4]-1]=count[inp[164][7:4]-1]+1;
end
if (inp[165]!=0)begin
    connected[inp[165][3:0]-1]<=connected[inp[165][3:0]-1]+inp[165][7:4]<<count[inp[165][3:0]-1];
    connected[inp[165][7:4]-1]<=connected[inp[165][7:4]-1]+inp[165][3:0]<<count[inp[165][7:4]-1];
    weights[inp[165][3:0]-1]<=weights[inp[165][3:0]-1]+inp[165][11:8]<<count[inp[165][3:0]-1];
    weights[inp[165][7:4]-1]<=weights[inp[165][7:4]-1]+inp[165][11:8]<<count[inp[165][7:4]-1];
    count[inp[165][3:0]-1]=count[inp[165][3:0]-1]+1;
    count[inp[165][7:4]-1]=count[inp[165][7:4]-1]+1;
end
if (inp[166]!=0)begin
    connected[inp[166][3:0]-1]<=connected[inp[166][3:0]-1]+inp[166][7:4]<<count[inp[166][3:0]-1];
    connected[inp[166][7:4]-1]<=connected[inp[166][7:4]-1]+inp[166][3:0]<<count[inp[166][7:4]-1];
    weights[inp[166][3:0]-1]<=weights[inp[166][3:0]-1]+inp[166][11:8]<<count[inp[166][3:0]-1];
    weights[inp[166][7:4]-1]<=weights[inp[166][7:4]-1]+inp[166][11:8]<<count[inp[166][7:4]-1];
    count[inp[166][3:0]-1]=count[inp[166][3:0]-1]+1;
    count[inp[166][7:4]-1]=count[inp[166][7:4]-1]+1;
end
if (inp[167]!=0)begin
    connected[inp[167][3:0]-1]<=connected[inp[167][3:0]-1]+inp[167][7:4]<<count[inp[167][3:0]-1];
    connected[inp[167][7:4]-1]<=connected[inp[167][7:4]-1]+inp[167][3:0]<<count[inp[167][7:4]-1];
    weights[inp[167][3:0]-1]<=weights[inp[167][3:0]-1]+inp[167][11:8]<<count[inp[167][3:0]-1];
    weights[inp[167][7:4]-1]<=weights[inp[167][7:4]-1]+inp[167][11:8]<<count[inp[167][7:4]-1];
    count[inp[167][3:0]-1]=count[inp[167][3:0]-1]+1;
    count[inp[167][7:4]-1]=count[inp[167][7:4]-1]+1;
end
if (inp[168]!=0)begin
    connected[inp[168][3:0]-1]<=connected[inp[168][3:0]-1]+inp[168][7:4]<<count[inp[168][3:0]-1];
    connected[inp[168][7:4]-1]<=connected[inp[168][7:4]-1]+inp[168][3:0]<<count[inp[168][7:4]-1];
    weights[inp[168][3:0]-1]<=weights[inp[168][3:0]-1]+inp[168][11:8]<<count[inp[168][3:0]-1];
    weights[inp[168][7:4]-1]<=weights[inp[168][7:4]-1]+inp[168][11:8]<<count[inp[168][7:4]-1];
    count[inp[168][3:0]-1]=count[inp[168][3:0]-1]+1;
    count[inp[168][7:4]-1]=count[inp[168][7:4]-1]+1;
end
if (inp[169]!=0)begin
    connected[inp[169][3:0]-1]<=connected[inp[169][3:0]-1]+inp[169][7:4]<<count[inp[169][3:0]-1];
    connected[inp[169][7:4]-1]<=connected[inp[169][7:4]-1]+inp[169][3:0]<<count[inp[169][7:4]-1];
    weights[inp[169][3:0]-1]<=weights[inp[169][3:0]-1]+inp[169][11:8]<<count[inp[169][3:0]-1];
    weights[inp[169][7:4]-1]<=weights[inp[169][7:4]-1]+inp[169][11:8]<<count[inp[169][7:4]-1];
    count[inp[169][3:0]-1]=count[inp[169][3:0]-1]+1;
    count[inp[169][7:4]-1]=count[inp[169][7:4]-1]+1;
end
if (inp[170]!=0)begin
    connected[inp[170][3:0]-1]<=connected[inp[170][3:0]-1]+inp[170][7:4]<<count[inp[170][3:0]-1];
    connected[inp[170][7:4]-1]<=connected[inp[170][7:4]-1]+inp[170][3:0]<<count[inp[170][7:4]-1];
    weights[inp[170][3:0]-1]<=weights[inp[170][3:0]-1]+inp[170][11:8]<<count[inp[170][3:0]-1];
    weights[inp[170][7:4]-1]<=weights[inp[170][7:4]-1]+inp[170][11:8]<<count[inp[170][7:4]-1];
    count[inp[170][3:0]-1]=count[inp[170][3:0]-1]+1;
    count[inp[170][7:4]-1]=count[inp[170][7:4]-1]+1;
end
if (inp[171]!=0)begin
    connected[inp[171][3:0]-1]<=connected[inp[171][3:0]-1]+inp[171][7:4]<<count[inp[171][3:0]-1];
    connected[inp[171][7:4]-1]<=connected[inp[171][7:4]-1]+inp[171][3:0]<<count[inp[171][7:4]-1];
    weights[inp[171][3:0]-1]<=weights[inp[171][3:0]-1]+inp[171][11:8]<<count[inp[171][3:0]-1];
    weights[inp[171][7:4]-1]<=weights[inp[171][7:4]-1]+inp[171][11:8]<<count[inp[171][7:4]-1];
    count[inp[171][3:0]-1]=count[inp[171][3:0]-1]+1;
    count[inp[171][7:4]-1]=count[inp[171][7:4]-1]+1;
end
if (inp[172]!=0)begin
    connected[inp[172][3:0]-1]<=connected[inp[172][3:0]-1]+inp[172][7:4]<<count[inp[172][3:0]-1];
    connected[inp[172][7:4]-1]<=connected[inp[172][7:4]-1]+inp[172][3:0]<<count[inp[172][7:4]-1];
    weights[inp[172][3:0]-1]<=weights[inp[172][3:0]-1]+inp[172][11:8]<<count[inp[172][3:0]-1];
    weights[inp[172][7:4]-1]<=weights[inp[172][7:4]-1]+inp[172][11:8]<<count[inp[172][7:4]-1];
    count[inp[172][3:0]-1]=count[inp[172][3:0]-1]+1;
    count[inp[172][7:4]-1]=count[inp[172][7:4]-1]+1;
end
if (inp[173]!=0)begin
    connected[inp[173][3:0]-1]<=connected[inp[173][3:0]-1]+inp[173][7:4]<<count[inp[173][3:0]-1];
    connected[inp[173][7:4]-1]<=connected[inp[173][7:4]-1]+inp[173][3:0]<<count[inp[173][7:4]-1];
    weights[inp[173][3:0]-1]<=weights[inp[173][3:0]-1]+inp[173][11:8]<<count[inp[173][3:0]-1];
    weights[inp[173][7:4]-1]<=weights[inp[173][7:4]-1]+inp[173][11:8]<<count[inp[173][7:4]-1];
    count[inp[173][3:0]-1]=count[inp[173][3:0]-1]+1;
    count[inp[173][7:4]-1]=count[inp[173][7:4]-1]+1;
end
if (inp[174]!=0)begin
    connected[inp[174][3:0]-1]<=connected[inp[174][3:0]-1]+inp[174][7:4]<<count[inp[174][3:0]-1];
    connected[inp[174][7:4]-1]<=connected[inp[174][7:4]-1]+inp[174][3:0]<<count[inp[174][7:4]-1];
    weights[inp[174][3:0]-1]<=weights[inp[174][3:0]-1]+inp[174][11:8]<<count[inp[174][3:0]-1];
    weights[inp[174][7:4]-1]<=weights[inp[174][7:4]-1]+inp[174][11:8]<<count[inp[174][7:4]-1];
    count[inp[174][3:0]-1]=count[inp[174][3:0]-1]+1;
    count[inp[174][7:4]-1]=count[inp[174][7:4]-1]+1;
end
if (inp[175]!=0)begin
    connected[inp[175][3:0]-1]<=connected[inp[175][3:0]-1]+inp[175][7:4]<<count[inp[175][3:0]-1];
    connected[inp[175][7:4]-1]<=connected[inp[175][7:4]-1]+inp[175][3:0]<<count[inp[175][7:4]-1];
    weights[inp[175][3:0]-1]<=weights[inp[175][3:0]-1]+inp[175][11:8]<<count[inp[175][3:0]-1];
    weights[inp[175][7:4]-1]<=weights[inp[175][7:4]-1]+inp[175][11:8]<<count[inp[175][7:4]-1];
    count[inp[175][3:0]-1]=count[inp[175][3:0]-1]+1;
    count[inp[175][7:4]-1]=count[inp[175][7:4]-1]+1;
end
if (inp[176]!=0)begin
    connected[inp[176][3:0]-1]<=connected[inp[176][3:0]-1]+inp[176][7:4]<<count[inp[176][3:0]-1];
    connected[inp[176][7:4]-1]<=connected[inp[176][7:4]-1]+inp[176][3:0]<<count[inp[176][7:4]-1];
    weights[inp[176][3:0]-1]<=weights[inp[176][3:0]-1]+inp[176][11:8]<<count[inp[176][3:0]-1];
    weights[inp[176][7:4]-1]<=weights[inp[176][7:4]-1]+inp[176][11:8]<<count[inp[176][7:4]-1];
    count[inp[176][3:0]-1]=count[inp[176][3:0]-1]+1;
    count[inp[176][7:4]-1]=count[inp[176][7:4]-1]+1;
end
if (inp[177]!=0)begin
    connected[inp[177][3:0]-1]<=connected[inp[177][3:0]-1]+inp[177][7:4]<<count[inp[177][3:0]-1];
    connected[inp[177][7:4]-1]<=connected[inp[177][7:4]-1]+inp[177][3:0]<<count[inp[177][7:4]-1];
    weights[inp[177][3:0]-1]<=weights[inp[177][3:0]-1]+inp[177][11:8]<<count[inp[177][3:0]-1];
    weights[inp[177][7:4]-1]<=weights[inp[177][7:4]-1]+inp[177][11:8]<<count[inp[177][7:4]-1];
    count[inp[177][3:0]-1]=count[inp[177][3:0]-1]+1;
    count[inp[177][7:4]-1]=count[inp[177][7:4]-1]+1;
end
if (inp[178]!=0)begin
    connected[inp[178][3:0]-1]<=connected[inp[178][3:0]-1]+inp[178][7:4]<<count[inp[178][3:0]-1];
    connected[inp[178][7:4]-1]<=connected[inp[178][7:4]-1]+inp[178][3:0]<<count[inp[178][7:4]-1];
    weights[inp[178][3:0]-1]<=weights[inp[178][3:0]-1]+inp[178][11:8]<<count[inp[178][3:0]-1];
    weights[inp[178][7:4]-1]<=weights[inp[178][7:4]-1]+inp[178][11:8]<<count[inp[178][7:4]-1];
    count[inp[178][3:0]-1]=count[inp[178][3:0]-1]+1;
    count[inp[178][7:4]-1]=count[inp[178][7:4]-1]+1;
end
if (inp[179]!=0)begin
    connected[inp[179][3:0]-1]<=connected[inp[179][3:0]-1]+inp[179][7:4]<<count[inp[179][3:0]-1];
    connected[inp[179][7:4]-1]<=connected[inp[179][7:4]-1]+inp[179][3:0]<<count[inp[179][7:4]-1];
    weights[inp[179][3:0]-1]<=weights[inp[179][3:0]-1]+inp[179][11:8]<<count[inp[179][3:0]-1];
    weights[inp[179][7:4]-1]<=weights[inp[179][7:4]-1]+inp[179][11:8]<<count[inp[179][7:4]-1];
    count[inp[179][3:0]-1]=count[inp[179][3:0]-1]+1;
    count[inp[179][7:4]-1]=count[inp[179][7:4]-1]+1;
end
if (inp[180]!=0)begin
    connected[inp[180][3:0]-1]<=connected[inp[180][3:0]-1]+inp[180][7:4]<<count[inp[180][3:0]-1];
    connected[inp[180][7:4]-1]<=connected[inp[180][7:4]-1]+inp[180][3:0]<<count[inp[180][7:4]-1];
    weights[inp[180][3:0]-1]<=weights[inp[180][3:0]-1]+inp[180][11:8]<<count[inp[180][3:0]-1];
    weights[inp[180][7:4]-1]<=weights[inp[180][7:4]-1]+inp[180][11:8]<<count[inp[180][7:4]-1];
    count[inp[180][3:0]-1]=count[inp[180][3:0]-1]+1;
    count[inp[180][7:4]-1]=count[inp[180][7:4]-1]+1;
end
if (inp[181]!=0)begin
    connected[inp[181][3:0]-1]<=connected[inp[181][3:0]-1]+inp[181][7:4]<<count[inp[181][3:0]-1];
    connected[inp[181][7:4]-1]<=connected[inp[181][7:4]-1]+inp[181][3:0]<<count[inp[181][7:4]-1];
    weights[inp[181][3:0]-1]<=weights[inp[181][3:0]-1]+inp[181][11:8]<<count[inp[181][3:0]-1];
    weights[inp[181][7:4]-1]<=weights[inp[181][7:4]-1]+inp[181][11:8]<<count[inp[181][7:4]-1];
    count[inp[181][3:0]-1]=count[inp[181][3:0]-1]+1;
    count[inp[181][7:4]-1]=count[inp[181][7:4]-1]+1;
end
if (inp[182]!=0)begin
    connected[inp[182][3:0]-1]<=connected[inp[182][3:0]-1]+inp[182][7:4]<<count[inp[182][3:0]-1];
    connected[inp[182][7:4]-1]<=connected[inp[182][7:4]-1]+inp[182][3:0]<<count[inp[182][7:4]-1];
    weights[inp[182][3:0]-1]<=weights[inp[182][3:0]-1]+inp[182][11:8]<<count[inp[182][3:0]-1];
    weights[inp[182][7:4]-1]<=weights[inp[182][7:4]-1]+inp[182][11:8]<<count[inp[182][7:4]-1];
    count[inp[182][3:0]-1]=count[inp[182][3:0]-1]+1;
    count[inp[182][7:4]-1]=count[inp[182][7:4]-1]+1;
end
if (inp[183]!=0)begin
    connected[inp[183][3:0]-1]<=connected[inp[183][3:0]-1]+inp[183][7:4]<<count[inp[183][3:0]-1];
    connected[inp[183][7:4]-1]<=connected[inp[183][7:4]-1]+inp[183][3:0]<<count[inp[183][7:4]-1];
    weights[inp[183][3:0]-1]<=weights[inp[183][3:0]-1]+inp[183][11:8]<<count[inp[183][3:0]-1];
    weights[inp[183][7:4]-1]<=weights[inp[183][7:4]-1]+inp[183][11:8]<<count[inp[183][7:4]-1];
    count[inp[183][3:0]-1]=count[inp[183][3:0]-1]+1;
    count[inp[183][7:4]-1]=count[inp[183][7:4]-1]+1;
end
if (inp[184]!=0)begin
    connected[inp[184][3:0]-1]<=connected[inp[184][3:0]-1]+inp[184][7:4]<<count[inp[184][3:0]-1];
    connected[inp[184][7:4]-1]<=connected[inp[184][7:4]-1]+inp[184][3:0]<<count[inp[184][7:4]-1];
    weights[inp[184][3:0]-1]<=weights[inp[184][3:0]-1]+inp[184][11:8]<<count[inp[184][3:0]-1];
    weights[inp[184][7:4]-1]<=weights[inp[184][7:4]-1]+inp[184][11:8]<<count[inp[184][7:4]-1];
    count[inp[184][3:0]-1]=count[inp[184][3:0]-1]+1;
    count[inp[184][7:4]-1]=count[inp[184][7:4]-1]+1;
end
if (inp[185]!=0)begin
    connected[inp[185][3:0]-1]<=connected[inp[185][3:0]-1]+inp[185][7:4]<<count[inp[185][3:0]-1];
    connected[inp[185][7:4]-1]<=connected[inp[185][7:4]-1]+inp[185][3:0]<<count[inp[185][7:4]-1];
    weights[inp[185][3:0]-1]<=weights[inp[185][3:0]-1]+inp[185][11:8]<<count[inp[185][3:0]-1];
    weights[inp[185][7:4]-1]<=weights[inp[185][7:4]-1]+inp[185][11:8]<<count[inp[185][7:4]-1];
    count[inp[185][3:0]-1]=count[inp[185][3:0]-1]+1;
    count[inp[185][7:4]-1]=count[inp[185][7:4]-1]+1;
end
if (inp[186]!=0)begin
    connected[inp[186][3:0]-1]<=connected[inp[186][3:0]-1]+inp[186][7:4]<<count[inp[186][3:0]-1];
    connected[inp[186][7:4]-1]<=connected[inp[186][7:4]-1]+inp[186][3:0]<<count[inp[186][7:4]-1];
    weights[inp[186][3:0]-1]<=weights[inp[186][3:0]-1]+inp[186][11:8]<<count[inp[186][3:0]-1];
    weights[inp[186][7:4]-1]<=weights[inp[186][7:4]-1]+inp[186][11:8]<<count[inp[186][7:4]-1];
    count[inp[186][3:0]-1]=count[inp[186][3:0]-1]+1;
    count[inp[186][7:4]-1]=count[inp[186][7:4]-1]+1;
end
if (inp[187]!=0)begin
    connected[inp[187][3:0]-1]<=connected[inp[187][3:0]-1]+inp[187][7:4]<<count[inp[187][3:0]-1];
    connected[inp[187][7:4]-1]<=connected[inp[187][7:4]-1]+inp[187][3:0]<<count[inp[187][7:4]-1];
    weights[inp[187][3:0]-1]<=weights[inp[187][3:0]-1]+inp[187][11:8]<<count[inp[187][3:0]-1];
    weights[inp[187][7:4]-1]<=weights[inp[187][7:4]-1]+inp[187][11:8]<<count[inp[187][7:4]-1];
    count[inp[187][3:0]-1]=count[inp[187][3:0]-1]+1;
    count[inp[187][7:4]-1]=count[inp[187][7:4]-1]+1;
end
if (inp[188]!=0)begin
    connected[inp[188][3:0]-1]<=connected[inp[188][3:0]-1]+inp[188][7:4]<<count[inp[188][3:0]-1];
    connected[inp[188][7:4]-1]<=connected[inp[188][7:4]-1]+inp[188][3:0]<<count[inp[188][7:4]-1];
    weights[inp[188][3:0]-1]<=weights[inp[188][3:0]-1]+inp[188][11:8]<<count[inp[188][3:0]-1];
    weights[inp[188][7:4]-1]<=weights[inp[188][7:4]-1]+inp[188][11:8]<<count[inp[188][7:4]-1];
    count[inp[188][3:0]-1]=count[inp[188][3:0]-1]+1;
    count[inp[188][7:4]-1]=count[inp[188][7:4]-1]+1;
end
if (inp[189]!=0)begin
    connected[inp[189][3:0]-1]<=connected[inp[189][3:0]-1]+inp[189][7:4]<<count[inp[189][3:0]-1];
    connected[inp[189][7:4]-1]<=connected[inp[189][7:4]-1]+inp[189][3:0]<<count[inp[189][7:4]-1];
    weights[inp[189][3:0]-1]<=weights[inp[189][3:0]-1]+inp[189][11:8]<<count[inp[189][3:0]-1];
    weights[inp[189][7:4]-1]<=weights[inp[189][7:4]-1]+inp[189][11:8]<<count[inp[189][7:4]-1];
    count[inp[189][3:0]-1]=count[inp[189][3:0]-1]+1;
    count[inp[189][7:4]-1]=count[inp[189][7:4]-1]+1;
end
if (inp[190]!=0)begin
    connected[inp[190][3:0]-1]<=connected[inp[190][3:0]-1]+inp[190][7:4]<<count[inp[190][3:0]-1];
    connected[inp[190][7:4]-1]<=connected[inp[190][7:4]-1]+inp[190][3:0]<<count[inp[190][7:4]-1];
    weights[inp[190][3:0]-1]<=weights[inp[190][3:0]-1]+inp[190][11:8]<<count[inp[190][3:0]-1];
    weights[inp[190][7:4]-1]<=weights[inp[190][7:4]-1]+inp[190][11:8]<<count[inp[190][7:4]-1];
    count[inp[190][3:0]-1]=count[inp[190][3:0]-1]+1;
    count[inp[190][7:4]-1]=count[inp[190][7:4]-1]+1;
end
if (inp[191]!=0)begin
    connected[inp[191][3:0]-1]<=connected[inp[191][3:0]-1]+inp[191][7:4]<<count[inp[191][3:0]-1];
    connected[inp[191][7:4]-1]<=connected[inp[191][7:4]-1]+inp[191][3:0]<<count[inp[191][7:4]-1];
    weights[inp[191][3:0]-1]<=weights[inp[191][3:0]-1]+inp[191][11:8]<<count[inp[191][3:0]-1];
    weights[inp[191][7:4]-1]<=weights[inp[191][7:4]-1]+inp[191][11:8]<<count[inp[191][7:4]-1];
    count[inp[191][3:0]-1]=count[inp[191][3:0]-1]+1;
    count[inp[191][7:4]-1]=count[inp[191][7:4]-1]+1;
end
if (inp[192]!=0)begin
    connected[inp[192][3:0]-1]<=connected[inp[192][3:0]-1]+inp[192][7:4]<<count[inp[192][3:0]-1];
    connected[inp[192][7:4]-1]<=connected[inp[192][7:4]-1]+inp[192][3:0]<<count[inp[192][7:4]-1];
    weights[inp[192][3:0]-1]<=weights[inp[192][3:0]-1]+inp[192][11:8]<<count[inp[192][3:0]-1];
    weights[inp[192][7:4]-1]<=weights[inp[192][7:4]-1]+inp[192][11:8]<<count[inp[192][7:4]-1];
    count[inp[192][3:0]-1]=count[inp[192][3:0]-1]+1;
    count[inp[192][7:4]-1]=count[inp[192][7:4]-1]+1;
end
if (inp[193]!=0)begin
    connected[inp[193][3:0]-1]<=connected[inp[193][3:0]-1]+inp[193][7:4]<<count[inp[193][3:0]-1];
    connected[inp[193][7:4]-1]<=connected[inp[193][7:4]-1]+inp[193][3:0]<<count[inp[193][7:4]-1];
    weights[inp[193][3:0]-1]<=weights[inp[193][3:0]-1]+inp[193][11:8]<<count[inp[193][3:0]-1];
    weights[inp[193][7:4]-1]<=weights[inp[193][7:4]-1]+inp[193][11:8]<<count[inp[193][7:4]-1];
    count[inp[193][3:0]-1]=count[inp[193][3:0]-1]+1;
    count[inp[193][7:4]-1]=count[inp[193][7:4]-1]+1;
end
if (inp[194]!=0)begin
    connected[inp[194][3:0]-1]<=connected[inp[194][3:0]-1]+inp[194][7:4]<<count[inp[194][3:0]-1];
    connected[inp[194][7:4]-1]<=connected[inp[194][7:4]-1]+inp[194][3:0]<<count[inp[194][7:4]-1];
    weights[inp[194][3:0]-1]<=weights[inp[194][3:0]-1]+inp[194][11:8]<<count[inp[194][3:0]-1];
    weights[inp[194][7:4]-1]<=weights[inp[194][7:4]-1]+inp[194][11:8]<<count[inp[194][7:4]-1];
    count[inp[194][3:0]-1]=count[inp[194][3:0]-1]+1;
    count[inp[194][7:4]-1]=count[inp[194][7:4]-1]+1;
end
if (inp[195]!=0)begin
    connected[inp[195][3:0]-1]<=connected[inp[195][3:0]-1]+inp[195][7:4]<<count[inp[195][3:0]-1];
    connected[inp[195][7:4]-1]<=connected[inp[195][7:4]-1]+inp[195][3:0]<<count[inp[195][7:4]-1];
    weights[inp[195][3:0]-1]<=weights[inp[195][3:0]-1]+inp[195][11:8]<<count[inp[195][3:0]-1];
    weights[inp[195][7:4]-1]<=weights[inp[195][7:4]-1]+inp[195][11:8]<<count[inp[195][7:4]-1];
    count[inp[195][3:0]-1]=count[inp[195][3:0]-1]+1;
    count[inp[195][7:4]-1]=count[inp[195][7:4]-1]+1;
end
if (inp[196]!=0)begin
    connected[inp[196][3:0]-1]<=connected[inp[196][3:0]-1]+inp[196][7:4]<<count[inp[196][3:0]-1];
    connected[inp[196][7:4]-1]<=connected[inp[196][7:4]-1]+inp[196][3:0]<<count[inp[196][7:4]-1];
    weights[inp[196][3:0]-1]<=weights[inp[196][3:0]-1]+inp[196][11:8]<<count[inp[196][3:0]-1];
    weights[inp[196][7:4]-1]<=weights[inp[196][7:4]-1]+inp[196][11:8]<<count[inp[196][7:4]-1];
    count[inp[196][3:0]-1]=count[inp[196][3:0]-1]+1;
    count[inp[196][7:4]-1]=count[inp[196][7:4]-1]+1;
end
if (inp[197]!=0)begin
    connected[inp[197][3:0]-1]<=connected[inp[197][3:0]-1]+inp[197][7:4]<<count[inp[197][3:0]-1];
    connected[inp[197][7:4]-1]<=connected[inp[197][7:4]-1]+inp[197][3:0]<<count[inp[197][7:4]-1];
    weights[inp[197][3:0]-1]<=weights[inp[197][3:0]-1]+inp[197][11:8]<<count[inp[197][3:0]-1];
    weights[inp[197][7:4]-1]<=weights[inp[197][7:4]-1]+inp[197][11:8]<<count[inp[197][7:4]-1];
    count[inp[197][3:0]-1]=count[inp[197][3:0]-1]+1;
    count[inp[197][7:4]-1]=count[inp[197][7:4]-1]+1;
end
if (inp[198]!=0)begin
    connected[inp[198][3:0]-1]<=connected[inp[198][3:0]-1]+inp[198][7:4]<<count[inp[198][3:0]-1];
    connected[inp[198][7:4]-1]<=connected[inp[198][7:4]-1]+inp[198][3:0]<<count[inp[198][7:4]-1];
    weights[inp[198][3:0]-1]<=weights[inp[198][3:0]-1]+inp[198][11:8]<<count[inp[198][3:0]-1];
    weights[inp[198][7:4]-1]<=weights[inp[198][7:4]-1]+inp[198][11:8]<<count[inp[198][7:4]-1];
    count[inp[198][3:0]-1]=count[inp[198][3:0]-1]+1;
    count[inp[198][7:4]-1]=count[inp[198][7:4]-1]+1;
end
if (inp[199]!=0)begin
    connected[inp[199][3:0]-1]<=connected[inp[199][3:0]-1]+inp[199][7:4]<<count[inp[199][3:0]-1];
    connected[inp[199][7:4]-1]<=connected[inp[199][7:4]-1]+inp[199][3:0]<<count[inp[199][7:4]-1];
    weights[inp[199][3:0]-1]<=weights[inp[199][3:0]-1]+inp[199][11:8]<<count[inp[199][3:0]-1];
    weights[inp[199][7:4]-1]<=weights[inp[199][7:4]-1]+inp[199][11:8]<<count[inp[199][7:4]-1];
    count[inp[199][3:0]-1]=count[inp[199][3:0]-1]+1;
    count[inp[199][7:4]-1]=count[inp[199][7:4]-1]+1;
end
if (inp[200]!=0)begin
    connected[inp[200][3:0]-1]<=connected[inp[200][3:0]-1]+inp[200][7:4]<<count[inp[200][3:0]-1];
    connected[inp[200][7:4]-1]<=connected[inp[200][7:4]-1]+inp[200][3:0]<<count[inp[200][7:4]-1];
    weights[inp[200][3:0]-1]<=weights[inp[200][3:0]-1]+inp[200][11:8]<<count[inp[200][3:0]-1];
    weights[inp[200][7:4]-1]<=weights[inp[200][7:4]-1]+inp[200][11:8]<<count[inp[200][7:4]-1];
    count[inp[200][3:0]-1]=count[inp[200][3:0]-1]+1;
    count[inp[200][7:4]-1]=count[inp[200][7:4]-1]+1;
end
if (inp[201]!=0)begin
    connected[inp[201][3:0]-1]<=connected[inp[201][3:0]-1]+inp[201][7:4]<<count[inp[201][3:0]-1];
    connected[inp[201][7:4]-1]<=connected[inp[201][7:4]-1]+inp[201][3:0]<<count[inp[201][7:4]-1];
    weights[inp[201][3:0]-1]<=weights[inp[201][3:0]-1]+inp[201][11:8]<<count[inp[201][3:0]-1];
    weights[inp[201][7:4]-1]<=weights[inp[201][7:4]-1]+inp[201][11:8]<<count[inp[201][7:4]-1];
    count[inp[201][3:0]-1]=count[inp[201][3:0]-1]+1;
    count[inp[201][7:4]-1]=count[inp[201][7:4]-1]+1;
end
if (inp[202]!=0)begin
    connected[inp[202][3:0]-1]<=connected[inp[202][3:0]-1]+inp[202][7:4]<<count[inp[202][3:0]-1];
    connected[inp[202][7:4]-1]<=connected[inp[202][7:4]-1]+inp[202][3:0]<<count[inp[202][7:4]-1];
    weights[inp[202][3:0]-1]<=weights[inp[202][3:0]-1]+inp[202][11:8]<<count[inp[202][3:0]-1];
    weights[inp[202][7:4]-1]<=weights[inp[202][7:4]-1]+inp[202][11:8]<<count[inp[202][7:4]-1];
    count[inp[202][3:0]-1]=count[inp[202][3:0]-1]+1;
    count[inp[202][7:4]-1]=count[inp[202][7:4]-1]+1;
end
if (inp[203]!=0)begin
    connected[inp[203][3:0]-1]<=connected[inp[203][3:0]-1]+inp[203][7:4]<<count[inp[203][3:0]-1];
    connected[inp[203][7:4]-1]<=connected[inp[203][7:4]-1]+inp[203][3:0]<<count[inp[203][7:4]-1];
    weights[inp[203][3:0]-1]<=weights[inp[203][3:0]-1]+inp[203][11:8]<<count[inp[203][3:0]-1];
    weights[inp[203][7:4]-1]<=weights[inp[203][7:4]-1]+inp[203][11:8]<<count[inp[203][7:4]-1];
    count[inp[203][3:0]-1]=count[inp[203][3:0]-1]+1;
    count[inp[203][7:4]-1]=count[inp[203][7:4]-1]+1;
end
if (inp[204]!=0)begin
    connected[inp[204][3:0]-1]<=connected[inp[204][3:0]-1]+inp[204][7:4]<<count[inp[204][3:0]-1];
    connected[inp[204][7:4]-1]<=connected[inp[204][7:4]-1]+inp[204][3:0]<<count[inp[204][7:4]-1];
    weights[inp[204][3:0]-1]<=weights[inp[204][3:0]-1]+inp[204][11:8]<<count[inp[204][3:0]-1];
    weights[inp[204][7:4]-1]<=weights[inp[204][7:4]-1]+inp[204][11:8]<<count[inp[204][7:4]-1];
    count[inp[204][3:0]-1]=count[inp[204][3:0]-1]+1;
    count[inp[204][7:4]-1]=count[inp[204][7:4]-1]+1;
end
if (inp[205]!=0)begin
    connected[inp[205][3:0]-1]<=connected[inp[205][3:0]-1]+inp[205][7:4]<<count[inp[205][3:0]-1];
    connected[inp[205][7:4]-1]<=connected[inp[205][7:4]-1]+inp[205][3:0]<<count[inp[205][7:4]-1];
    weights[inp[205][3:0]-1]<=weights[inp[205][3:0]-1]+inp[205][11:8]<<count[inp[205][3:0]-1];
    weights[inp[205][7:4]-1]<=weights[inp[205][7:4]-1]+inp[205][11:8]<<count[inp[205][7:4]-1];
    count[inp[205][3:0]-1]=count[inp[205][3:0]-1]+1;
    count[inp[205][7:4]-1]=count[inp[205][7:4]-1]+1;
end
if (inp[206]!=0)begin
    connected[inp[206][3:0]-1]<=connected[inp[206][3:0]-1]+inp[206][7:4]<<count[inp[206][3:0]-1];
    connected[inp[206][7:4]-1]<=connected[inp[206][7:4]-1]+inp[206][3:0]<<count[inp[206][7:4]-1];
    weights[inp[206][3:0]-1]<=weights[inp[206][3:0]-1]+inp[206][11:8]<<count[inp[206][3:0]-1];
    weights[inp[206][7:4]-1]<=weights[inp[206][7:4]-1]+inp[206][11:8]<<count[inp[206][7:4]-1];
    count[inp[206][3:0]-1]=count[inp[206][3:0]-1]+1;
    count[inp[206][7:4]-1]=count[inp[206][7:4]-1]+1;
end
if (inp[207]!=0)begin
    connected[inp[207][3:0]-1]<=connected[inp[207][3:0]-1]+inp[207][7:4]<<count[inp[207][3:0]-1];
    connected[inp[207][7:4]-1]<=connected[inp[207][7:4]-1]+inp[207][3:0]<<count[inp[207][7:4]-1];
    weights[inp[207][3:0]-1]<=weights[inp[207][3:0]-1]+inp[207][11:8]<<count[inp[207][3:0]-1];
    weights[inp[207][7:4]-1]<=weights[inp[207][7:4]-1]+inp[207][11:8]<<count[inp[207][7:4]-1];
    count[inp[207][3:0]-1]=count[inp[207][3:0]-1]+1;
    count[inp[207][7:4]-1]=count[inp[207][7:4]-1]+1;
end
if (inp[208]!=0)begin
    connected[inp[208][3:0]-1]<=connected[inp[208][3:0]-1]+inp[208][7:4]<<count[inp[208][3:0]-1];
    connected[inp[208][7:4]-1]<=connected[inp[208][7:4]-1]+inp[208][3:0]<<count[inp[208][7:4]-1];
    weights[inp[208][3:0]-1]<=weights[inp[208][3:0]-1]+inp[208][11:8]<<count[inp[208][3:0]-1];
    weights[inp[208][7:4]-1]<=weights[inp[208][7:4]-1]+inp[208][11:8]<<count[inp[208][7:4]-1];
    count[inp[208][3:0]-1]=count[inp[208][3:0]-1]+1;
    count[inp[208][7:4]-1]=count[inp[208][7:4]-1]+1;
end
if (inp[209]!=0)begin
    connected[inp[209][3:0]-1]<=connected[inp[209][3:0]-1]+inp[209][7:4]<<count[inp[209][3:0]-1];
    connected[inp[209][7:4]-1]<=connected[inp[209][7:4]-1]+inp[209][3:0]<<count[inp[209][7:4]-1];
    weights[inp[209][3:0]-1]<=weights[inp[209][3:0]-1]+inp[209][11:8]<<count[inp[209][3:0]-1];
    weights[inp[209][7:4]-1]<=weights[inp[209][7:4]-1]+inp[209][11:8]<<count[inp[209][7:4]-1];
    count[inp[209][3:0]-1]=count[inp[209][3:0]-1]+1;
    count[inp[209][7:4]-1]=count[inp[209][7:4]-1]+1;
end
if (inp[210]!=0)begin
    connected[inp[210][3:0]-1]<=connected[inp[210][3:0]-1]+inp[210][7:4]<<count[inp[210][3:0]-1];
    connected[inp[210][7:4]-1]<=connected[inp[210][7:4]-1]+inp[210][3:0]<<count[inp[210][7:4]-1];
    weights[inp[210][3:0]-1]<=weights[inp[210][3:0]-1]+inp[210][11:8]<<count[inp[210][3:0]-1];
    weights[inp[210][7:4]-1]<=weights[inp[210][7:4]-1]+inp[210][11:8]<<count[inp[210][7:4]-1];
    count[inp[210][3:0]-1]=count[inp[210][3:0]-1]+1;
    count[inp[210][7:4]-1]=count[inp[210][7:4]-1]+1;
end
if (inp[211]!=0)begin
    connected[inp[211][3:0]-1]<=connected[inp[211][3:0]-1]+inp[211][7:4]<<count[inp[211][3:0]-1];
    connected[inp[211][7:4]-1]<=connected[inp[211][7:4]-1]+inp[211][3:0]<<count[inp[211][7:4]-1];
    weights[inp[211][3:0]-1]<=weights[inp[211][3:0]-1]+inp[211][11:8]<<count[inp[211][3:0]-1];
    weights[inp[211][7:4]-1]<=weights[inp[211][7:4]-1]+inp[211][11:8]<<count[inp[211][7:4]-1];
    count[inp[211][3:0]-1]=count[inp[211][3:0]-1]+1;
    count[inp[211][7:4]-1]=count[inp[211][7:4]-1]+1;
end
if (inp[212]!=0)begin
    connected[inp[212][3:0]-1]<=connected[inp[212][3:0]-1]+inp[212][7:4]<<count[inp[212][3:0]-1];
    connected[inp[212][7:4]-1]<=connected[inp[212][7:4]-1]+inp[212][3:0]<<count[inp[212][7:4]-1];
    weights[inp[212][3:0]-1]<=weights[inp[212][3:0]-1]+inp[212][11:8]<<count[inp[212][3:0]-1];
    weights[inp[212][7:4]-1]<=weights[inp[212][7:4]-1]+inp[212][11:8]<<count[inp[212][7:4]-1];
    count[inp[212][3:0]-1]=count[inp[212][3:0]-1]+1;
    count[inp[212][7:4]-1]=count[inp[212][7:4]-1]+1;
end
if (inp[213]!=0)begin
    connected[inp[213][3:0]-1]<=connected[inp[213][3:0]-1]+inp[213][7:4]<<count[inp[213][3:0]-1];
    connected[inp[213][7:4]-1]<=connected[inp[213][7:4]-1]+inp[213][3:0]<<count[inp[213][7:4]-1];
    weights[inp[213][3:0]-1]<=weights[inp[213][3:0]-1]+inp[213][11:8]<<count[inp[213][3:0]-1];
    weights[inp[213][7:4]-1]<=weights[inp[213][7:4]-1]+inp[213][11:8]<<count[inp[213][7:4]-1];
    count[inp[213][3:0]-1]=count[inp[213][3:0]-1]+1;
    count[inp[213][7:4]-1]=count[inp[213][7:4]-1]+1;
end
if (inp[214]!=0)begin
    connected[inp[214][3:0]-1]<=connected[inp[214][3:0]-1]+inp[214][7:4]<<count[inp[214][3:0]-1];
    connected[inp[214][7:4]-1]<=connected[inp[214][7:4]-1]+inp[214][3:0]<<count[inp[214][7:4]-1];
    weights[inp[214][3:0]-1]<=weights[inp[214][3:0]-1]+inp[214][11:8]<<count[inp[214][3:0]-1];
    weights[inp[214][7:4]-1]<=weights[inp[214][7:4]-1]+inp[214][11:8]<<count[inp[214][7:4]-1];
    count[inp[214][3:0]-1]=count[inp[214][3:0]-1]+1;
    count[inp[214][7:4]-1]=count[inp[214][7:4]-1]+1;
end
if (inp[215]!=0)begin
    connected[inp[215][3:0]-1]<=connected[inp[215][3:0]-1]+inp[215][7:4]<<count[inp[215][3:0]-1];
    connected[inp[215][7:4]-1]<=connected[inp[215][7:4]-1]+inp[215][3:0]<<count[inp[215][7:4]-1];
    weights[inp[215][3:0]-1]<=weights[inp[215][3:0]-1]+inp[215][11:8]<<count[inp[215][3:0]-1];
    weights[inp[215][7:4]-1]<=weights[inp[215][7:4]-1]+inp[215][11:8]<<count[inp[215][7:4]-1];
    count[inp[215][3:0]-1]=count[inp[215][3:0]-1]+1;
    count[inp[215][7:4]-1]=count[inp[215][7:4]-1]+1;
end
if (inp[216]!=0)begin
    connected[inp[216][3:0]-1]<=connected[inp[216][3:0]-1]+inp[216][7:4]<<count[inp[216][3:0]-1];
    connected[inp[216][7:4]-1]<=connected[inp[216][7:4]-1]+inp[216][3:0]<<count[inp[216][7:4]-1];
    weights[inp[216][3:0]-1]<=weights[inp[216][3:0]-1]+inp[216][11:8]<<count[inp[216][3:0]-1];
    weights[inp[216][7:4]-1]<=weights[inp[216][7:4]-1]+inp[216][11:8]<<count[inp[216][7:4]-1];
    count[inp[216][3:0]-1]=count[inp[216][3:0]-1]+1;
    count[inp[216][7:4]-1]=count[inp[216][7:4]-1]+1;
end
if (inp[217]!=0)begin
    connected[inp[217][3:0]-1]<=connected[inp[217][3:0]-1]+inp[217][7:4]<<count[inp[217][3:0]-1];
    connected[inp[217][7:4]-1]<=connected[inp[217][7:4]-1]+inp[217][3:0]<<count[inp[217][7:4]-1];
    weights[inp[217][3:0]-1]<=weights[inp[217][3:0]-1]+inp[217][11:8]<<count[inp[217][3:0]-1];
    weights[inp[217][7:4]-1]<=weights[inp[217][7:4]-1]+inp[217][11:8]<<count[inp[217][7:4]-1];
    count[inp[217][3:0]-1]=count[inp[217][3:0]-1]+1;
    count[inp[217][7:4]-1]=count[inp[217][7:4]-1]+1;
end
if (inp[218]!=0)begin
    connected[inp[218][3:0]-1]<=connected[inp[218][3:0]-1]+inp[218][7:4]<<count[inp[218][3:0]-1];
    connected[inp[218][7:4]-1]<=connected[inp[218][7:4]-1]+inp[218][3:0]<<count[inp[218][7:4]-1];
    weights[inp[218][3:0]-1]<=weights[inp[218][3:0]-1]+inp[218][11:8]<<count[inp[218][3:0]-1];
    weights[inp[218][7:4]-1]<=weights[inp[218][7:4]-1]+inp[218][11:8]<<count[inp[218][7:4]-1];
    count[inp[218][3:0]-1]=count[inp[218][3:0]-1]+1;
    count[inp[218][7:4]-1]=count[inp[218][7:4]-1]+1;
end
if (inp[219]!=0)begin
    connected[inp[219][3:0]-1]<=connected[inp[219][3:0]-1]+inp[219][7:4]<<count[inp[219][3:0]-1];
    connected[inp[219][7:4]-1]<=connected[inp[219][7:4]-1]+inp[219][3:0]<<count[inp[219][7:4]-1];
    weights[inp[219][3:0]-1]<=weights[inp[219][3:0]-1]+inp[219][11:8]<<count[inp[219][3:0]-1];
    weights[inp[219][7:4]-1]<=weights[inp[219][7:4]-1]+inp[219][11:8]<<count[inp[219][7:4]-1];
    count[inp[219][3:0]-1]=count[inp[219][3:0]-1]+1;
    count[inp[219][7:4]-1]=count[inp[219][7:4]-1]+1;
end
if (inp[220]!=0)begin
    connected[inp[220][3:0]-1]<=connected[inp[220][3:0]-1]+inp[220][7:4]<<count[inp[220][3:0]-1];
    connected[inp[220][7:4]-1]<=connected[inp[220][7:4]-1]+inp[220][3:0]<<count[inp[220][7:4]-1];
    weights[inp[220][3:0]-1]<=weights[inp[220][3:0]-1]+inp[220][11:8]<<count[inp[220][3:0]-1];
    weights[inp[220][7:4]-1]<=weights[inp[220][7:4]-1]+inp[220][11:8]<<count[inp[220][7:4]-1];
    count[inp[220][3:0]-1]=count[inp[220][3:0]-1]+1;
    count[inp[220][7:4]-1]=count[inp[220][7:4]-1]+1;
end
if (inp[221]!=0)begin
    connected[inp[221][3:0]-1]<=connected[inp[221][3:0]-1]+inp[221][7:4]<<count[inp[221][3:0]-1];
    connected[inp[221][7:4]-1]<=connected[inp[221][7:4]-1]+inp[221][3:0]<<count[inp[221][7:4]-1];
    weights[inp[221][3:0]-1]<=weights[inp[221][3:0]-1]+inp[221][11:8]<<count[inp[221][3:0]-1];
    weights[inp[221][7:4]-1]<=weights[inp[221][7:4]-1]+inp[221][11:8]<<count[inp[221][7:4]-1];
    count[inp[221][3:0]-1]=count[inp[221][3:0]-1]+1;
    count[inp[221][7:4]-1]=count[inp[221][7:4]-1]+1;
end
if (inp[222]!=0)begin
    connected[inp[222][3:0]-1]<=connected[inp[222][3:0]-1]+inp[222][7:4]<<count[inp[222][3:0]-1];
    connected[inp[222][7:4]-1]<=connected[inp[222][7:4]-1]+inp[222][3:0]<<count[inp[222][7:4]-1];
    weights[inp[222][3:0]-1]<=weights[inp[222][3:0]-1]+inp[222][11:8]<<count[inp[222][3:0]-1];
    weights[inp[222][7:4]-1]<=weights[inp[222][7:4]-1]+inp[222][11:8]<<count[inp[222][7:4]-1];
    count[inp[222][3:0]-1]=count[inp[222][3:0]-1]+1;
    count[inp[222][7:4]-1]=count[inp[222][7:4]-1]+1;
end
if (inp[223]!=0)begin
    connected[inp[223][3:0]-1]<=connected[inp[223][3:0]-1]+inp[223][7:4]<<count[inp[223][3:0]-1];
    connected[inp[223][7:4]-1]<=connected[inp[223][7:4]-1]+inp[223][3:0]<<count[inp[223][7:4]-1];
    weights[inp[223][3:0]-1]<=weights[inp[223][3:0]-1]+inp[223][11:8]<<count[inp[223][3:0]-1];
    weights[inp[223][7:4]-1]<=weights[inp[223][7:4]-1]+inp[223][11:8]<<count[inp[223][7:4]-1];
    count[inp[223][3:0]-1]=count[inp[223][3:0]-1]+1;
    count[inp[223][7:4]-1]=count[inp[223][7:4]-1]+1;
end
if (inp[224]!=0)begin
    connected[inp[224][3:0]-1]<=connected[inp[224][3:0]-1]+inp[224][7:4]<<count[inp[224][3:0]-1];
    connected[inp[224][7:4]-1]<=connected[inp[224][7:4]-1]+inp[224][3:0]<<count[inp[224][7:4]-1];
    weights[inp[224][3:0]-1]<=weights[inp[224][3:0]-1]+inp[224][11:8]<<count[inp[224][3:0]-1];
    weights[inp[224][7:4]-1]<=weights[inp[224][7:4]-1]+inp[224][11:8]<<count[inp[224][7:4]-1];
    count[inp[224][3:0]-1]=count[inp[224][3:0]-1]+1;
    count[inp[224][7:4]-1]=count[inp[224][7:4]-1]+1;
end
if (inp[225]!=0)begin
    connected[inp[225][3:0]-1]<=connected[inp[225][3:0]-1]+inp[225][7:4]<<count[inp[225][3:0]-1];
    connected[inp[225][7:4]-1]<=connected[inp[225][7:4]-1]+inp[225][3:0]<<count[inp[225][7:4]-1];
    weights[inp[225][3:0]-1]<=weights[inp[225][3:0]-1]+inp[225][11:8]<<count[inp[225][3:0]-1];
    weights[inp[225][7:4]-1]<=weights[inp[225][7:4]-1]+inp[225][11:8]<<count[inp[225][7:4]-1];
    count[inp[225][3:0]-1]=count[inp[225][3:0]-1]+1;
    count[inp[225][7:4]-1]=count[inp[225][7:4]-1]+1;
end
if (inp[226]!=0)begin
    connected[inp[226][3:0]-1]<=connected[inp[226][3:0]-1]+inp[226][7:4]<<count[inp[226][3:0]-1];
    connected[inp[226][7:4]-1]<=connected[inp[226][7:4]-1]+inp[226][3:0]<<count[inp[226][7:4]-1];
    weights[inp[226][3:0]-1]<=weights[inp[226][3:0]-1]+inp[226][11:8]<<count[inp[226][3:0]-1];
    weights[inp[226][7:4]-1]<=weights[inp[226][7:4]-1]+inp[226][11:8]<<count[inp[226][7:4]-1];
    count[inp[226][3:0]-1]=count[inp[226][3:0]-1]+1;
    count[inp[226][7:4]-1]=count[inp[226][7:4]-1]+1;
end
if (inp[227]!=0)begin
    connected[inp[227][3:0]-1]<=connected[inp[227][3:0]-1]+inp[227][7:4]<<count[inp[227][3:0]-1];
    connected[inp[227][7:4]-1]<=connected[inp[227][7:4]-1]+inp[227][3:0]<<count[inp[227][7:4]-1];
    weights[inp[227][3:0]-1]<=weights[inp[227][3:0]-1]+inp[227][11:8]<<count[inp[227][3:0]-1];
    weights[inp[227][7:4]-1]<=weights[inp[227][7:4]-1]+inp[227][11:8]<<count[inp[227][7:4]-1];
    count[inp[227][3:0]-1]=count[inp[227][3:0]-1]+1;
    count[inp[227][7:4]-1]=count[inp[227][7:4]-1]+1;
end
if (inp[228]!=0)begin
    connected[inp[228][3:0]-1]<=connected[inp[228][3:0]-1]+inp[228][7:4]<<count[inp[228][3:0]-1];
    connected[inp[228][7:4]-1]<=connected[inp[228][7:4]-1]+inp[228][3:0]<<count[inp[228][7:4]-1];
    weights[inp[228][3:0]-1]<=weights[inp[228][3:0]-1]+inp[228][11:8]<<count[inp[228][3:0]-1];
    weights[inp[228][7:4]-1]<=weights[inp[228][7:4]-1]+inp[228][11:8]<<count[inp[228][7:4]-1];
    count[inp[228][3:0]-1]=count[inp[228][3:0]-1]+1;
    count[inp[228][7:4]-1]=count[inp[228][7:4]-1]+1;
end
if (inp[229]!=0)begin
    connected[inp[229][3:0]-1]<=connected[inp[229][3:0]-1]+inp[229][7:4]<<count[inp[229][3:0]-1];
    connected[inp[229][7:4]-1]<=connected[inp[229][7:4]-1]+inp[229][3:0]<<count[inp[229][7:4]-1];
    weights[inp[229][3:0]-1]<=weights[inp[229][3:0]-1]+inp[229][11:8]<<count[inp[229][3:0]-1];
    weights[inp[229][7:4]-1]<=weights[inp[229][7:4]-1]+inp[229][11:8]<<count[inp[229][7:4]-1];
    count[inp[229][3:0]-1]=count[inp[229][3:0]-1]+1;
    count[inp[229][7:4]-1]=count[inp[229][7:4]-1]+1;
end
if (inp[230]!=0)begin
    connected[inp[230][3:0]-1]<=connected[inp[230][3:0]-1]+inp[230][7:4]<<count[inp[230][3:0]-1];
    connected[inp[230][7:4]-1]<=connected[inp[230][7:4]-1]+inp[230][3:0]<<count[inp[230][7:4]-1];
    weights[inp[230][3:0]-1]<=weights[inp[230][3:0]-1]+inp[230][11:8]<<count[inp[230][3:0]-1];
    weights[inp[230][7:4]-1]<=weights[inp[230][7:4]-1]+inp[230][11:8]<<count[inp[230][7:4]-1];
    count[inp[230][3:0]-1]=count[inp[230][3:0]-1]+1;
    count[inp[230][7:4]-1]=count[inp[230][7:4]-1]+1;
end
if (inp[231]!=0)begin
    connected[inp[231][3:0]-1]<=connected[inp[231][3:0]-1]+inp[231][7:4]<<count[inp[231][3:0]-1];
    connected[inp[231][7:4]-1]<=connected[inp[231][7:4]-1]+inp[231][3:0]<<count[inp[231][7:4]-1];
    weights[inp[231][3:0]-1]<=weights[inp[231][3:0]-1]+inp[231][11:8]<<count[inp[231][3:0]-1];
    weights[inp[231][7:4]-1]<=weights[inp[231][7:4]-1]+inp[231][11:8]<<count[inp[231][7:4]-1];
    count[inp[231][3:0]-1]=count[inp[231][3:0]-1]+1;
    count[inp[231][7:4]-1]=count[inp[231][7:4]-1]+1;
end
if (inp[232]!=0)begin
    connected[inp[232][3:0]-1]<=connected[inp[232][3:0]-1]+inp[232][7:4]<<count[inp[232][3:0]-1];
    connected[inp[232][7:4]-1]<=connected[inp[232][7:4]-1]+inp[232][3:0]<<count[inp[232][7:4]-1];
    weights[inp[232][3:0]-1]<=weights[inp[232][3:0]-1]+inp[232][11:8]<<count[inp[232][3:0]-1];
    weights[inp[232][7:4]-1]<=weights[inp[232][7:4]-1]+inp[232][11:8]<<count[inp[232][7:4]-1];
    count[inp[232][3:0]-1]=count[inp[232][3:0]-1]+1;
    count[inp[232][7:4]-1]=count[inp[232][7:4]-1]+1;
end
if (inp[233]!=0)begin
    connected[inp[233][3:0]-1]<=connected[inp[233][3:0]-1]+inp[233][7:4]<<count[inp[233][3:0]-1];
    connected[inp[233][7:4]-1]<=connected[inp[233][7:4]-1]+inp[233][3:0]<<count[inp[233][7:4]-1];
    weights[inp[233][3:0]-1]<=weights[inp[233][3:0]-1]+inp[233][11:8]<<count[inp[233][3:0]-1];
    weights[inp[233][7:4]-1]<=weights[inp[233][7:4]-1]+inp[233][11:8]<<count[inp[233][7:4]-1];
    count[inp[233][3:0]-1]=count[inp[233][3:0]-1]+1;
    count[inp[233][7:4]-1]=count[inp[233][7:4]-1]+1;
end
if (inp[234]!=0)begin
    connected[inp[234][3:0]-1]<=connected[inp[234][3:0]-1]+inp[234][7:4]<<count[inp[234][3:0]-1];
    connected[inp[234][7:4]-1]<=connected[inp[234][7:4]-1]+inp[234][3:0]<<count[inp[234][7:4]-1];
    weights[inp[234][3:0]-1]<=weights[inp[234][3:0]-1]+inp[234][11:8]<<count[inp[234][3:0]-1];
    weights[inp[234][7:4]-1]<=weights[inp[234][7:4]-1]+inp[234][11:8]<<count[inp[234][7:4]-1];
    count[inp[234][3:0]-1]=count[inp[234][3:0]-1]+1;
    count[inp[234][7:4]-1]=count[inp[234][7:4]-1]+1;
end
if (inp[235]!=0)begin
    connected[inp[235][3:0]-1]<=connected[inp[235][3:0]-1]+inp[235][7:4]<<count[inp[235][3:0]-1];
    connected[inp[235][7:4]-1]<=connected[inp[235][7:4]-1]+inp[235][3:0]<<count[inp[235][7:4]-1];
    weights[inp[235][3:0]-1]<=weights[inp[235][3:0]-1]+inp[235][11:8]<<count[inp[235][3:0]-1];
    weights[inp[235][7:4]-1]<=weights[inp[235][7:4]-1]+inp[235][11:8]<<count[inp[235][7:4]-1];
    count[inp[235][3:0]-1]=count[inp[235][3:0]-1]+1;
    count[inp[235][7:4]-1]=count[inp[235][7:4]-1]+1;
end
if (inp[236]!=0)begin
    connected[inp[236][3:0]-1]<=connected[inp[236][3:0]-1]+inp[236][7:4]<<count[inp[236][3:0]-1];
    connected[inp[236][7:4]-1]<=connected[inp[236][7:4]-1]+inp[236][3:0]<<count[inp[236][7:4]-1];
    weights[inp[236][3:0]-1]<=weights[inp[236][3:0]-1]+inp[236][11:8]<<count[inp[236][3:0]-1];
    weights[inp[236][7:4]-1]<=weights[inp[236][7:4]-1]+inp[236][11:8]<<count[inp[236][7:4]-1];
    count[inp[236][3:0]-1]=count[inp[236][3:0]-1]+1;
    count[inp[236][7:4]-1]=count[inp[236][7:4]-1]+1;
end
if (inp[237]!=0)begin
    connected[inp[237][3:0]-1]<=connected[inp[237][3:0]-1]+inp[237][7:4]<<count[inp[237][3:0]-1];
    connected[inp[237][7:4]-1]<=connected[inp[237][7:4]-1]+inp[237][3:0]<<count[inp[237][7:4]-1];
    weights[inp[237][3:0]-1]<=weights[inp[237][3:0]-1]+inp[237][11:8]<<count[inp[237][3:0]-1];
    weights[inp[237][7:4]-1]<=weights[inp[237][7:4]-1]+inp[237][11:8]<<count[inp[237][7:4]-1];
    count[inp[237][3:0]-1]=count[inp[237][3:0]-1]+1;
    count[inp[237][7:4]-1]=count[inp[237][7:4]-1]+1;
end
if (inp[238]!=0)begin
    connected[inp[238][3:0]-1]<=connected[inp[238][3:0]-1]+inp[238][7:4]<<count[inp[238][3:0]-1];
    connected[inp[238][7:4]-1]<=connected[inp[238][7:4]-1]+inp[238][3:0]<<count[inp[238][7:4]-1];
    weights[inp[238][3:0]-1]<=weights[inp[238][3:0]-1]+inp[238][11:8]<<count[inp[238][3:0]-1];
    weights[inp[238][7:4]-1]<=weights[inp[238][7:4]-1]+inp[238][11:8]<<count[inp[238][7:4]-1];
    count[inp[238][3:0]-1]=count[inp[238][3:0]-1]+1;
    count[inp[238][7:4]-1]=count[inp[238][7:4]-1]+1;
end
if (inp[239]!=0)begin
    connected[inp[239][3:0]-1]<=connected[inp[239][3:0]-1]+inp[239][7:4]<<count[inp[239][3:0]-1];
    connected[inp[239][7:4]-1]<=connected[inp[239][7:4]-1]+inp[239][3:0]<<count[inp[239][7:4]-1];
    weights[inp[239][3:0]-1]<=weights[inp[239][3:0]-1]+inp[239][11:8]<<count[inp[239][3:0]-1];
    weights[inp[239][7:4]-1]<=weights[inp[239][7:4]-1]+inp[239][11:8]<<count[inp[239][7:4]-1];
    count[inp[239][3:0]-1]=count[inp[239][3:0]-1]+1;
    count[inp[239][7:4]-1]=count[inp[239][7:4]-1]+1;
end
if (inp[240]!=0)begin
    connected[inp[240][3:0]-1]<=connected[inp[240][3:0]-1]+inp[240][7:4]<<count[inp[240][3:0]-1];
    connected[inp[240][7:4]-1]<=connected[inp[240][7:4]-1]+inp[240][3:0]<<count[inp[240][7:4]-1];
    weights[inp[240][3:0]-1]<=weights[inp[240][3:0]-1]+inp[240][11:8]<<count[inp[240][3:0]-1];
    weights[inp[240][7:4]-1]<=weights[inp[240][7:4]-1]+inp[240][11:8]<<count[inp[240][7:4]-1];
    count[inp[240][3:0]-1]=count[inp[240][3:0]-1]+1;
    count[inp[240][7:4]-1]=count[inp[240][7:4]-1]+1;
end
if (inp[241]!=0)begin
    connected[inp[241][3:0]-1]<=connected[inp[241][3:0]-1]+inp[241][7:4]<<count[inp[241][3:0]-1];
    connected[inp[241][7:4]-1]<=connected[inp[241][7:4]-1]+inp[241][3:0]<<count[inp[241][7:4]-1];
    weights[inp[241][3:0]-1]<=weights[inp[241][3:0]-1]+inp[241][11:8]<<count[inp[241][3:0]-1];
    weights[inp[241][7:4]-1]<=weights[inp[241][7:4]-1]+inp[241][11:8]<<count[inp[241][7:4]-1];
    count[inp[241][3:0]-1]=count[inp[241][3:0]-1]+1;
    count[inp[241][7:4]-1]=count[inp[241][7:4]-1]+1;
end
if (inp[242]!=0)begin
    connected[inp[242][3:0]-1]<=connected[inp[242][3:0]-1]+inp[242][7:4]<<count[inp[242][3:0]-1];
    connected[inp[242][7:4]-1]<=connected[inp[242][7:4]-1]+inp[242][3:0]<<count[inp[242][7:4]-1];
    weights[inp[242][3:0]-1]<=weights[inp[242][3:0]-1]+inp[242][11:8]<<count[inp[242][3:0]-1];
    weights[inp[242][7:4]-1]<=weights[inp[242][7:4]-1]+inp[242][11:8]<<count[inp[242][7:4]-1];
    count[inp[242][3:0]-1]=count[inp[242][3:0]-1]+1;
    count[inp[242][7:4]-1]=count[inp[242][7:4]-1]+1;
end
if (inp[243]!=0)begin
    connected[inp[243][3:0]-1]<=connected[inp[243][3:0]-1]+inp[243][7:4]<<count[inp[243][3:0]-1];
    connected[inp[243][7:4]-1]<=connected[inp[243][7:4]-1]+inp[243][3:0]<<count[inp[243][7:4]-1];
    weights[inp[243][3:0]-1]<=weights[inp[243][3:0]-1]+inp[243][11:8]<<count[inp[243][3:0]-1];
    weights[inp[243][7:4]-1]<=weights[inp[243][7:4]-1]+inp[243][11:8]<<count[inp[243][7:4]-1];
    count[inp[243][3:0]-1]=count[inp[243][3:0]-1]+1;
    count[inp[243][7:4]-1]=count[inp[243][7:4]-1]+1;
end
if (inp[244]!=0)begin
    connected[inp[244][3:0]-1]<=connected[inp[244][3:0]-1]+inp[244][7:4]<<count[inp[244][3:0]-1];
    connected[inp[244][7:4]-1]<=connected[inp[244][7:4]-1]+inp[244][3:0]<<count[inp[244][7:4]-1];
    weights[inp[244][3:0]-1]<=weights[inp[244][3:0]-1]+inp[244][11:8]<<count[inp[244][3:0]-1];
    weights[inp[244][7:4]-1]<=weights[inp[244][7:4]-1]+inp[244][11:8]<<count[inp[244][7:4]-1];
    count[inp[244][3:0]-1]=count[inp[244][3:0]-1]+1;
    count[inp[244][7:4]-1]=count[inp[244][7:4]-1]+1;
end
if (inp[245]!=0)begin
    connected[inp[245][3:0]-1]<=connected[inp[245][3:0]-1]+inp[245][7:4]<<count[inp[245][3:0]-1];
    connected[inp[245][7:4]-1]<=connected[inp[245][7:4]-1]+inp[245][3:0]<<count[inp[245][7:4]-1];
    weights[inp[245][3:0]-1]<=weights[inp[245][3:0]-1]+inp[245][11:8]<<count[inp[245][3:0]-1];
    weights[inp[245][7:4]-1]<=weights[inp[245][7:4]-1]+inp[245][11:8]<<count[inp[245][7:4]-1];
    count[inp[245][3:0]-1]=count[inp[245][3:0]-1]+1;
    count[inp[245][7:4]-1]=count[inp[245][7:4]-1]+1;
end
if (inp[246]!=0)begin
    connected[inp[246][3:0]-1]<=connected[inp[246][3:0]-1]+inp[246][7:4]<<count[inp[246][3:0]-1];
    connected[inp[246][7:4]-1]<=connected[inp[246][7:4]-1]+inp[246][3:0]<<count[inp[246][7:4]-1];
    weights[inp[246][3:0]-1]<=weights[inp[246][3:0]-1]+inp[246][11:8]<<count[inp[246][3:0]-1];
    weights[inp[246][7:4]-1]<=weights[inp[246][7:4]-1]+inp[246][11:8]<<count[inp[246][7:4]-1];
    count[inp[246][3:0]-1]=count[inp[246][3:0]-1]+1;
    count[inp[246][7:4]-1]=count[inp[246][7:4]-1]+1;
end
if (inp[247]!=0)begin
    connected[inp[247][3:0]-1]<=connected[inp[247][3:0]-1]+inp[247][7:4]<<count[inp[247][3:0]-1];
    connected[inp[247][7:4]-1]<=connected[inp[247][7:4]-1]+inp[247][3:0]<<count[inp[247][7:4]-1];
    weights[inp[247][3:0]-1]<=weights[inp[247][3:0]-1]+inp[247][11:8]<<count[inp[247][3:0]-1];
    weights[inp[247][7:4]-1]<=weights[inp[247][7:4]-1]+inp[247][11:8]<<count[inp[247][7:4]-1];
    count[inp[247][3:0]-1]=count[inp[247][3:0]-1]+1;
    count[inp[247][7:4]-1]=count[inp[247][7:4]-1]+1;
end
if (inp[248]!=0)begin
    connected[inp[248][3:0]-1]<=connected[inp[248][3:0]-1]+inp[248][7:4]<<count[inp[248][3:0]-1];
    connected[inp[248][7:4]-1]<=connected[inp[248][7:4]-1]+inp[248][3:0]<<count[inp[248][7:4]-1];
    weights[inp[248][3:0]-1]<=weights[inp[248][3:0]-1]+inp[248][11:8]<<count[inp[248][3:0]-1];
    weights[inp[248][7:4]-1]<=weights[inp[248][7:4]-1]+inp[248][11:8]<<count[inp[248][7:4]-1];
    count[inp[248][3:0]-1]=count[inp[248][3:0]-1]+1;
    count[inp[248][7:4]-1]=count[inp[248][7:4]-1]+1;
end
if (inp[249]!=0)begin
    connected[inp[249][3:0]-1]<=connected[inp[249][3:0]-1]+inp[249][7:4]<<count[inp[249][3:0]-1];
    connected[inp[249][7:4]-1]<=connected[inp[249][7:4]-1]+inp[249][3:0]<<count[inp[249][7:4]-1];
    weights[inp[249][3:0]-1]<=weights[inp[249][3:0]-1]+inp[249][11:8]<<count[inp[249][3:0]-1];
    weights[inp[249][7:4]-1]<=weights[inp[249][7:4]-1]+inp[249][11:8]<<count[inp[249][7:4]-1];
    count[inp[249][3:0]-1]=count[inp[249][3:0]-1]+1;
    count[inp[249][7:4]-1]=count[inp[249][7:4]-1]+1;
end
if (inp[250]!=0)begin
    connected[inp[250][3:0]-1]<=connected[inp[250][3:0]-1]+inp[250][7:4]<<count[inp[250][3:0]-1];
    connected[inp[250][7:4]-1]<=connected[inp[250][7:4]-1]+inp[250][3:0]<<count[inp[250][7:4]-1];
    weights[inp[250][3:0]-1]<=weights[inp[250][3:0]-1]+inp[250][11:8]<<count[inp[250][3:0]-1];
    weights[inp[250][7:4]-1]<=weights[inp[250][7:4]-1]+inp[250][11:8]<<count[inp[250][7:4]-1];
    count[inp[250][3:0]-1]=count[inp[250][3:0]-1]+1;
    count[inp[250][7:4]-1]=count[inp[250][7:4]-1]+1;
end
if (inp[251]!=0)begin
    connected[inp[251][3:0]-1]<=connected[inp[251][3:0]-1]+inp[251][7:4]<<count[inp[251][3:0]-1];
    connected[inp[251][7:4]-1]<=connected[inp[251][7:4]-1]+inp[251][3:0]<<count[inp[251][7:4]-1];
    weights[inp[251][3:0]-1]<=weights[inp[251][3:0]-1]+inp[251][11:8]<<count[inp[251][3:0]-1];
    weights[inp[251][7:4]-1]<=weights[inp[251][7:4]-1]+inp[251][11:8]<<count[inp[251][7:4]-1];
    count[inp[251][3:0]-1]=count[inp[251][3:0]-1]+1;
    count[inp[251][7:4]-1]=count[inp[251][7:4]-1]+1;
end
if (inp[252]!=0)begin
    connected[inp[252][3:0]-1]<=connected[inp[252][3:0]-1]+inp[252][7:4]<<count[inp[252][3:0]-1];
    connected[inp[252][7:4]-1]<=connected[inp[252][7:4]-1]+inp[252][3:0]<<count[inp[252][7:4]-1];
    weights[inp[252][3:0]-1]<=weights[inp[252][3:0]-1]+inp[252][11:8]<<count[inp[252][3:0]-1];
    weights[inp[252][7:4]-1]<=weights[inp[252][7:4]-1]+inp[252][11:8]<<count[inp[252][7:4]-1];
    count[inp[252][3:0]-1]=count[inp[252][3:0]-1]+1;
    count[inp[252][7:4]-1]=count[inp[252][7:4]-1]+1;
end
if (inp[253]!=0)begin
    connected[inp[253][3:0]-1]<=connected[inp[253][3:0]-1]+inp[253][7:4]<<count[inp[253][3:0]-1];
    connected[inp[253][7:4]-1]<=connected[inp[253][7:4]-1]+inp[253][3:0]<<count[inp[253][7:4]-1];
    weights[inp[253][3:0]-1]<=weights[inp[253][3:0]-1]+inp[253][11:8]<<count[inp[253][3:0]-1];
    weights[inp[253][7:4]-1]<=weights[inp[253][7:4]-1]+inp[253][11:8]<<count[inp[253][7:4]-1];
    count[inp[253][3:0]-1]=count[inp[253][3:0]-1]+1;
    count[inp[253][7:4]-1]=count[inp[253][7:4]-1]+1;
end
if (inp[254]!=0)begin
    connected[inp[254][3:0]-1]<=connected[inp[254][3:0]-1]+inp[254][7:4]<<count[inp[254][3:0]-1];
    connected[inp[254][7:4]-1]<=connected[inp[254][7:4]-1]+inp[254][3:0]<<count[inp[254][7:4]-1];
    weights[inp[254][3:0]-1]<=weights[inp[254][3:0]-1]+inp[254][11:8]<<count[inp[254][3:0]-1];
    weights[inp[254][7:4]-1]<=weights[inp[254][7:4]-1]+inp[254][11:8]<<count[inp[254][7:4]-1];
    count[inp[254][3:0]-1]=count[inp[254][3:0]-1]+1;
    count[inp[254][7:4]-1]=count[inp[254][7:4]-1]+1;
end

            end
        end 
    end  
endmodule