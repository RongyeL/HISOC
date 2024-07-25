debImport "-f" "../tb/tb.f"
wvCreateWindow
wvSetPosition -win $_nWave2 {("G1" 0)}
wvOpenFile -win $_nWave2 \
           {/home/myeda/project/hisoc/verification/tb_hisoc/sim/sim_out.fsdb}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk" -line 18 -pos 1 -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED" -delim "."
srcHBSelect "TB_HISOC.U_RVSEED" -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM" -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_INST_MEM" -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk" -line 16 -pos 1 -win $_nTrace1
srcSelect -signal "rst_n" -line 17 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvZoom -win $_nWave2 628104.240688 785130.300860
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_arid" -line 19 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_araddr" -line 20 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_arvalid" -line 29 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_arready" -line 30 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rdata" -line 33 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_rvalid" -line 36 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_rready" -line 37 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_rlast" -line 35 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvScrollDown -win $_nWave2 1
wvSelectSignal -win $_nWave2 {( "G1" 7 )} 
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rdata" -line 33 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rdata" -line 33 -pos 1 -win $_nTrace1
srcAction -pos 32 18 10 -win $_nTrace1 -name "axi_slv_rdata" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rdata" -line 33 -pos 1 -win $_nTrace1
srcSearchString "axi_slv_rdata" -win $_nTrace1 -prev -case
srcSelect -win $_nTrace1 -range {77 77 6 7 1 1}
nsMsgSwitchTab -tab general
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM.U_AXI_SLV_CTRL_RD" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_INST_MEM.U_AXI_SLV_CTRL_RD" \
           -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM.U_AXI_SLV_CTRL_RD" -win $_nTrace1
srcSearchString "axi_slv_rdata" -win $_nTrace1 -next -case
srcSearchString "axi_slv_rdata" -win $_nTrace1 -next -case
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rdata_r" -line 61 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rdata_r" -line 61 -pos 1 -win $_nTrace1
srcAction -pos 60 15 10 -win $_nTrace1 -name "axi_slv_rdata_r" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_result_data" -line 172 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_result_data" -line 172 -pos 1 -win $_nTrace1
srcAction -pos 171 8 6 -win $_nTrace1 -name "rd_result_data" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_data_out" -line 102 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_address" -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_address" -win $_nTrace1
srcAction -pos 95 5 10 -win $_nTrace1 -name "mem_data\[mem_address\]" -ctrlKey \
          off
srcDeselectAll -win $_nTrace1
srcSelect -signal "burst_read_active" -line 85 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_base_addr\[ADDR_LSB+:MEM_ADDR_WIDTH\]" -line 85 -pos 1 -win \
          $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_base_addr\[ADDR_LSB+:MEM_ADDR_WIDTH\]" -line 85 -pos 1 -win \
          $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_base_addr\[ADDR_LSB+:MEM_ADDR_WIDTH\]" -line 85 -pos 1 -win \
          $_nTrace1
srcAction -pos 84 19 7 -win $_nTrace1 -name \
          "rd_base_addr\[ADDR_LSB+:MEM_ADDR_WIDTH\]" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_base_addr\[ADDR_LSB+:MEM_ADDR_WIDTH\]" -line 85 -pos 1 -win \
          $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_base_addr" -line 58 -pos 2 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_base_addr" -line 58 -pos 2 -win $_nTrace1
srcAction -pos 57 5 7 -win $_nTrace1 -name "rd_base_addr" -ctrlKey off
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM.U_AXI_SLV_CTRL_RD" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_INST_MEM.U_AXI_SLV_CTRL_RD" \
           -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM.U_AXI_SLV_CTRL_RD" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_base_addr" -line 22 -pos 1 -win $_nTrace1
srcAction -pos 21 18 9 -win $_nTrace1 -name "rd_base_addr" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_base_addr" -line 22 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_arlen" -line 30 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_arvalid" -line 26 -pos 1 -win $_nTrace1
debReload
wvSetCursor -win $_nWave2 128732.303396 -snap {("G1" 12)}
wvSetCursor -win $_nWave2 153938.628537 -snap {("G1" 11)}
wvSetCursor -win $_nWave2 247562.121916 -snap {("G1" 12)}
wvSetCursor -win $_nWave2 365491.714538 -snap {("G1" 12)}
wvSetCursor -win $_nWave2 485221.758955 -snap {("G1" 12)}
wvSetCursor -win $_nWave2 610353.158760 -snap {("G1" 12)}
wvSetCursor -win $_nWave2 238559.862937 -snap {("G1" 12)}
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_INST_MEM" -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM" -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM.U_AXI_SLV_CTRL_RD" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_INST_MEM.U_AXI_SLV_CTRL_RD" \
           -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM.U_AXI_SLV_CTRL_RD" -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_INST_MEM" -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_address" -line 85 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_data" -line 88 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 18 )} 
wvExpandBus -win $_nWave2 {("G1" 18)}
wvSelectSignal -win $_nWave2 {( "G1" 2066 )} 
wvScrollUp -win $_nWave2 1924
wvScrollDown -win $_nWave2 40
wvScrollDown -win $_nWave2 48
wvScrollDown -win $_nWave2 46
wvScrollDown -win $_nWave2 97
wvSelectSignal -win $_nWave2 \
           {( "G1" 373 374 375 376 377 378 379 380 381 382 383 \
           384 385 386 387 388 389 390 391 392 393 394 395 396 397 398 399 400 \
           401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 \
           418 419 420 421 422 423 424 425 426 427 428 429 430 431 432 433 434 \
           435 436 437 438 439 440 441 442 443 444 445 446 447 448 449 450 451 \
           452 453 454 455 456 457 458 459 460 461 462 463 464 465 466 467 468 \
           469 470 471 472 473 474 475 476 477 478 479 480 481 482 483 484 485 \
           486 487 488 489 490 491 492 493 494 495 496 497 498 499 500 501 502 \
           503 504 505 506 507 508 509 510 511 512 513 514 515 516 517 518 519 \
           520 521 522 523 524 525 526 527 528 529 530 531 532 533 534 535 536 \
           537 538 539 540 541 542 543 544 545 546 547 548 549 550 551 552 553 \
           554 555 556 557 558 559 560 561 562 563 564 565 566 567 568 569 570 \
           571 572 573 574 575 576 577 578 579 580 581 582 583 584 585 586 587 \
           588 589 590 591 592 593 594 595 596 597 598 599 600 601 602 603 604 \
           605 606 607 608 609 610 611 612 613 614 615 616 617 618 619 620 621 \
           622 623 624 625 626 627 628 629 630 631 632 633 634 635 636 637 638 \
           639 640 641 642 643 644 645 646 647 648 649 650 651 652 653 654 655 \
           656 657 658 659 660 661 662 663 664 665 666 667 668 669 670 671 672 \
           673 674 675 676 677 678 679 680 681 682 683 684 685 686 687 688 689 \
           690 691 692 693 694 695 696 697 698 699 700 701 702 703 704 705 706 \
           707 708 709 710 711 712 713 714 715 716 717 718 719 720 721 722 723 \
           724 725 726 727 728 729 730 731 732 733 734 735 736 737 738 739 740 \
           741 742 743 744 745 746 747 748 749 750 751 752 753 754 755 756 757 \
           758 759 760 761 762 763 764 765 766 767 768 769 770 771 772 773 774 \
           775 776 777 778 779 780 781 782 783 784 785 786 787 788 789 790 791 \
           792 793 794 795 796 797 798 799 800 801 802 803 804 805 806 807 808 \
           809 810 811 812 813 814 815 816 817 818 819 820 821 822 823 824 825 \
           826 827 828 829 830 831 832 833 834 835 836 837 838 839 840 841 842 \
           843 844 845 846 847 848 849 850 851 852 853 854 855 856 857 858 859 \
           860 861 862 863 864 865 866 867 868 869 870 871 872 873 874 875 876 \
           877 878 879 880 881 882 883 884 885 886 887 888 889 890 891 892 893 \
           894 895 896 897 898 899 900 901 902 903 904 905 906 907 908 909 910 \
           911 912 913 914 915 916 917 918 919 920 921 922 923 924 925 926 927 \
           928 929 930 931 932 933 934 935 936 937 938 939 940 941 942 943 944 \
           945 946 947 948 949 950 951 952 953 954 955 956 957 958 959 960 961 \
           962 963 964 965 966 967 968 969 970 971 972 973 974 975 976 977 978 \
           979 980 981 982 983 984 985 986 987 988 989 990 991 992 993 994 995 \
           996 997 998 999 1000 1001 1002 1003 1004 1005 1006 1007 1008 1009 \
           1010 1011 1012 1013 1014 1015 1016 1017 1018 1019 1020 1021 1022 1023 \
           1024 1025 1026 1027 1028 1029 1030 1031 1032 1033 1034 1035 1036 1037 \
           1038 1039 1040 1041 1042 1043 1044 1045 1046 1047 1048 1049 1050 1051 \
           1052 1053 1054 1055 1056 1057 1058 1059 1060 1061 1062 1063 1064 1065 \
           1066 1067 1068 1069 1070 1071 1072 1073 1074 1075 1076 1077 1078 1079 \
           1080 1081 1082 1083 1084 1085 1086 1087 1088 1089 1090 1091 1092 1093 \
           1094 1095 1096 1097 1098 1099 1100 1101 1102 1103 1104 1105 1106 1107 \
           1108 1109 1110 1111 1112 1113 1114 1115 1116 1117 1118 1119 1120 1121 \
           1122 1123 1124 1125 1126 1127 1128 1129 1130 1131 1132 1133 1134 1135 \
           1136 1137 1138 1139 1140 1141 1142 1143 1144 1145 1146 1147 1148 1149 \
           1150 1151 1152 1153 1154 1155 1156 1157 1158 1159 1160 1161 1162 1163 \
           1164 1165 1166 1167 1168 1169 1170 1171 1172 1173 1174 1175 1176 1177 \
           1178 1179 1180 1181 1182 1183 1184 1185 1186 1187 1188 1189 1190 1191 \
           1192 1193 1194 1195 1196 1197 1198 1199 1200 1201 1202 1203 1204 1205 \
           1206 1207 1208 1209 1210 1211 1212 1213 1214 1215 1216 1217 1218 1219 \
           1220 1221 1222 1223 1224 1225 1226 1227 1228 1229 1230 1231 1232 1233 \
           1234 1235 1236 1237 1238 1239 1240 1241 1242 1243 1244 1245 1246 1247 \
           1248 1249 1250 1251 1252 1253 1254 1255 1256 1257 1258 1259 1260 1261 \
           1262 1263 1264 1265 1266 1267 1268 1269 1270 1271 1272 1273 1274 1275 \
           1276 1277 1278 1279 1280 1281 1282 1283 1284 1285 1286 1287 1288 1289 \
           1290 1291 1292 1293 1294 1295 1296 1297 1298 1299 1300 1301 1302 1303 \
           1304 1305 1306 1307 1308 1309 1310 1311 1312 1313 1314 1315 1316 1317 \
           1318 1319 1320 1321 1322 1323 1324 1325 1326 1327 1328 1329 1330 1331 \
           1332 1333 1334 1335 1336 1337 1338 1339 1340 1341 1342 1343 1344 1345 \
           1346 1347 1348 1349 1350 1351 1352 1353 1354 1355 1356 1357 1358 1359 \
           1360 1361 1362 1363 1364 1365 1366 1367 1368 1369 1370 1371 1372 1373 \
           1374 1375 1376 1377 1378 1379 1380 1381 1382 1383 1384 1385 1386 1387 \
           1388 1389 1390 1391 1392 1393 1394 1395 1396 1397 1398 1399 1400 1401 \
           1402 1403 1404 1405 1406 1407 1408 1409 1410 1411 1412 1413 1414 1415 \
           1416 1417 1418 1419 1420 1421 1422 1423 1424 1425 1426 1427 1428 1429 \
           1430 1431 1432 1433 1434 1435 1436 1437 1438 1439 1440 1441 1442 1443 \
           1444 1445 1446 1447 1448 1449 1450 1451 1452 1453 1454 1455 1456 1457 \
           1458 1459 1460 1461 1462 1463 1464 1465 1466 1467 1468 1469 1470 1471 \
           1472 1473 1474 1475 1476 1477 1478 1479 1480 1481 1482 1483 1484 1485 \
           1486 1487 1488 1489 1490 1491 1492 1493 1494 1495 1496 1497 1498 1499 \
           1500 1501 1502 1503 1504 1505 1506 1507 1508 1509 1510 1511 1512 1513 \
           1514 1515 1516 1517 1518 1519 1520 1521 1522 1523 1524 1525 1526 1527 \
           1528 1529 1530 1531 1532 1533 1534 1535 1536 1537 1538 1539 1540 1541 \
           1542 1543 1544 1545 1546 1547 1548 1549 1550 1551 1552 1553 1554 1555 \
           1556 1557 1558 1559 1560 1561 1562 1563 1564 1565 1566 1567 1568 1569 \
           1570 1571 1572 1573 1574 1575 1576 1577 1578 1579 1580 1581 1582 1583 \
           1584 1585 1586 1587 1588 1589 1590 1591 1592 1593 1594 1595 1596 1597 \
           1598 1599 1600 1601 1602 1603 1604 1605 1606 1607 1608 1609 1610 1611 \
           1612 1613 1614 1615 1616 1617 1618 1619 1620 1621 1622 1623 1624 1625 \
           1626 1627 1628 1629 1630 1631 1632 1633 1634 1635 1636 1637 1638 1639 \
           1640 1641 1642 1643 1644 1645 1646 1647 1648 1649 1650 1651 1652 1653 \
           1654 1655 1656 1657 1658 1659 1660 1661 1662 1663 1664 1665 1666 1667 \
           1668 1669 1670 1671 1672 1673 1674 1675 1676 1677 1678 1679 1680 1681 \
           1682 1683 1684 1685 1686 1687 1688 1689 1690 1691 1692 1693 1694 1695 \
           1696 1697 1698 1699 1700 1701 1702 1703 1704 1705 1706 1707 1708 1709 \
           1710 1711 1712 1713 1714 1715 1716 1717 1718 1719 1720 1721 1722 1723 \
           1724 1725 1726 1727 1728 1729 1730 1731 1732 1733 1734 1735 1736 1737 \
           1738 1739 1740 1741 1742 1743 1744 1745 1746 1747 1748 1749 1750 1751 \
           1752 1753 1754 1755 1756 1757 1758 1759 1760 1761 1762 1763 1764 1765 \
           1766 1767 1768 1769 1770 1771 1772 1773 1774 1775 1776 1777 1778 1779 \
           1780 1781 1782 1783 1784 1785 1786 1787 1788 1789 1790 1791 1792 1793 \
           1794 1795 1796 1797 1798 1799 1800 1801 1802 1803 1804 1805 1806 1807 \
           1808 1809 1810 1811 1812 1813 1814 1815 1816 1817 1818 1819 1820 1821 \
           1822 1823 1824 1825 1826 1827 1828 1829 1830 1831 1832 1833 1834 1835 \
           1836 1837 1838 1839 1840 1841 1842 1843 1844 1845 1846 1847 1848 1849 \
           1850 1851 1852 1853 1854 1855 1856 1857 1858 1859 1860 1861 1862 1863 \
           1864 1865 1866 1867 1868 1869 1870 1871 1872 1873 1874 1875 1876 1877 \
           1878 1879 1880 1881 1882 1883 1884 1885 1886 1887 1888 1889 1890 1891 \
           1892 1893 1894 1895 1896 1897 1898 1899 1900 1901 1902 1903 1904 1905 \
           1906 1907 1908 1909 1910 1911 1912 1913 1914 1915 1916 1917 1918 1919 \
           1920 1921 1922 1923 1924 1925 1926 1927 1928 1929 1930 1931 1932 1933 \
           1934 1935 1936 1937 1938 1939 1940 1941 1942 1943 1944 1945 1946 1947 \
           1948 1949 1950 1951 1952 1953 1954 1955 1956 1957 1958 1959 1960 1961 \
           1962 1963 1964 1965 1966 1967 1968 1969 1970 1971 1972 1973 1974 1975 \
           1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 \
           1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 \
           2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 \
           2018 2019 2020 2021 2022 2023 2024 2025 2026 2027 2028 2029 2030 2031 \
           2032 2033 2034 2035 2036 2037 2038 2039 2040 2041 2042 2043 2044 2045 \
           2046 2047 2048 2049 2050 2051 2052 2053 2054 2055 2056 2057 2058 2059 \
           2060 2061 2062 2063 2064 2065 2066 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 372)}
wvScrollUp -win $_nWave2 54
wvScrollUp -win $_nWave2 300
wvScrollDown -win $_nWave2 4
wvSelectSignal -win $_nWave2 {( "G1" 19 )} 
wvScrollDown -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvSetCursor -win $_nWave2 370893.069925 -snap {("G1" 13)}
wvSetCursor -win $_nWave2 245761.670120 -snap {("G1" 13)}
wvSetCursor -win $_nWave2 360090.359150 -snap {("G1" 13)}
wvSelectSignal -win $_nWave2 {( "G1" 15 )} 
wvSelectSignal -win $_nWave2 {( "G1" 19 )} 
wvSelectSignal -win $_nWave2 {( "G1" 18 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G1" 371)}
wvSelectSignal -win $_nWave2 {( "G1" 18 )} 
wvScrollDown -win $_nWave2 47
wvScrollDown -win $_nWave2 304
wvSelectSignal -win $_nWave2 {( "G1" 18 19 20 21 22 23 24 25 26 27 28 29 30 31 \
           32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 \
           54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 \
           76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 \
           98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 \
           115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 \
           132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 \
           149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 \
           166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 \
           183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 \
           200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 \
           217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 \
           234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 \
           251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 \
           268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 \
           285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 \
           302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 \
           319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 \
           336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 \
           353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 \
           370 371 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 17)}
wvScrollUp -win $_nWave2 2
wvSelectSignal -win $_nWave2 {( "G1" 7 )} 
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSelectSignal -win $_nWave2 {( "G1" 11 )} 
wvScrollUp -win $_nWave2 2
wvSelectSignal -win $_nWave2 {( "G1" 7 )} 
wvSetPosition -win $_nWave2 {("G1" 7)}
wvExpandBus -win $_nWave2 {("G1" 7)}
wvSetPosition -win $_nWave2 {("G1" 49)}
wvScrollUp -win $_nWave2 29
wvSelectSignal -win $_nWave2 {( "G1" 7 )} 
wvSetPosition -win $_nWave2 {("G1" 7)}
wvCollapseBus -win $_nWave2 {("G1" 7)}
wvSetPosition -win $_nWave2 {("G1" 7)}
wvSetPosition -win $_nWave2 {("G1" 17)}
wvSetCursor -win $_nWave2 98141.078412 -snap {("G1" 7)}
srcActiveTrace "TB_HISOC.U_RVSEED.U_INST_MEM.axi_slv_rdata\[31:0\]" -win \
           $_nTrace1 -TraceByDConWave -TraceTime 0 -TraceValue \
           zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
wvSelectSignal -win $_nWave2 {( "G1" 7 )} 
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rvalid" -line 74 -pos 2 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rresp" -line 78 -pos 2 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rdata" -line 77 -pos 2 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rdata" -line 77 -pos 2 -win $_nTrace1
srcAction -pos 76 5 11 -win $_nTrace1 -name "axi_slv_rdata" -ctrlKey off
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM.U_AXI_SLV_CTRL_RD" -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM.U_AXI_SLV_CTRL_RD" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_INST_MEM.U_AXI_SLV_CTRL_RD" \
           -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM.U_AXI_SLV_CTRL_RD" -win $_nTrace1
srcSearchString "axi_slv_rdata" -win $_nTrace1 -next -case
srcSearchString "axi_slv_rdata" -win $_nTrace1 -next -case
srcSearchString "axi_slv_rdata" -win $_nTrace1 -next -case
srcSearchString "axi_slv_rdata" -win $_nTrace1 -next -case
srcSearchString "axi_slv_rdata" -win $_nTrace1 -next -case
srcDeselectAll -win $_nTrace1
debReload
srcHBSelect "TB_HISOC.U_RVSEED.U_IFU" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_IFU" -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_IFU" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ifu_axi_rlast" -line 63 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ifu_axi_rvalid" -line 64 -pos 1 -win $_nTrace1
srcSelect -signal "ifu_axi_rready" -line 65 -pos 1 -win $_nTrace1
srcSelect -signal "ifu_axi_rdata" -line 61 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSetCursor -win $_nWave2 107144.847074 -snap {("G1" 19)}
wvSetCursor -win $_nWave2 142259.544854 -snap {("G1" 21)}
wvSelectSignal -win $_nWave2 {( "G1" 19 )} 
wvSelectSignal -win $_nWave2 {( "G1" 19 20 21 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 18)}
wvSelectSignal -win $_nWave2 {( "G1" 17 )} 
wvSelectSignal -win $_nWave2 {( "G1" 15 )} 
wvScrollUp -win $_nWave2 1
srcHBSelect "TB_HISOC.U_RVSEED.U_IFU.U_MUX_PC" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_IFU.U_MUX_PC" -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_IFU.U_MUX_PC" -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_INST_MEM" -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM" -win $_nTrace1
wvSelectSignal -win $_nWave2 {( "G1" 14 )} 
wvSelectSignal -win $_nWave2 {( "G1" 18 )} 
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 9
wvSelectSignal -win $_nWave2 {( "G1" 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 \
           )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 2)}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_arvalid" -line 29 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_arready" -line 30 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_araddr" -line 20 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_arlen" -line 21 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_arsize" -line 22 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_arburst" -line 23 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 6 )} 
wvSelectSignal -win $_nWave2 {( "G1" 6 7 8 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 5)}
wvSetCursor -win $_nWave2 92738.817215 -snap {("G1" 3)}
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rresp" -line 34 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rvalid" -line 36 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rlast" -line 35 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_rvalid" -line 36 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rvalid" -line 36 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_rready" -line 37 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_rlast" -line 35 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_rdata" -line 33 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSetCursor -win $_nWave2 104443.716475 -snap {("G1" 6)}
wvSetCursor -win $_nWave2 108045.223940 -snap {("G1" 6)}
srcActiveTrace "TB_HISOC.U_RVSEED.U_INST_MEM.axi_slv_rvalid" -win $_nTrace1 \
           -TraceByDConWave -TraceTime 10100 -TraceValue 0
srcDeselectAll -win $_nTrace1
srcSelect -signal "burst_read_active" -line 175 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "burst_read_active" -line 175 -pos 1 -win $_nTrace1
srcAction -pos 174 6 10 -win $_nTrace1 -name "burst_read_active" -ctrlKey off
wvSetCursor -win $_nWave2 150362.936650 -snap {("G1" 9)}
wvSetCursor -win $_nWave2 150362.936650 -snap {("G1" 9)}
srcActiveTrace "TB_HISOC.U_RVSEED.U_INST_MEM.axi_slv_rdata\[31:0\]" -win \
           $_nTrace1 -TraceByDConWave -TraceTime 10100 -TraceValue \
           00000000000000000000000000000000
srcDeselectAll -win $_nTrace1
srcSelect -signal "burst_read_active" -line 175 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rdata_r" -line 176 -pos 1 -win $_nTrace1
srcAction -pos 175 6 8 -win $_nTrace1 -name "axi_slv_rdata_r" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rdata_r" -line 172 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_result_data" -line 172 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rdata_r" -line 172 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_result_data" -line 172 -pos 1 -win $_nTrace1
srcAction -pos 171 8 7 -win $_nTrace1 -name "rd_result_data" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_data_out" -line 102 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
debReload
wvSetCursor -win $_nWave2 125152.384397 -snap {("G1" 9)}
wvSetCursor -win $_nWave2 104443.716475 -snap {("G1" 8)}
wvSelectSignal -win $_nWave2 {( "G1" 6 )} 
wvSetCursor -win $_nWave2 105344.093341 -snap {("G1" 6)}
srcActiveTrace "TB_HISOC.U_RVSEED.U_INST_MEM.axi_slv_rvalid" -win $_nTrace1 \
           -TraceByDConWave -TraceTime 10100 -TraceValue 0
srcDeselectAll -win $_nTrace1
srcSelect -signal "burst_read_active" -line 168 -pos 1 -win $_nTrace1
srcAction -pos 167 6 9 -win $_nTrace1 -name "burst_read_active" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "burst_read_active" -line 93 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 10)}
wvSetPosition -win $_nWave2 {("G1" 9)}
wvSetPosition -win $_nWave2 {("G1" 8)}
wvSetPosition -win $_nWave2 {("G1" 7)}
wvSetPosition -win $_nWave2 {("G1" 6)}
wvSetPosition -win $_nWave2 {("G1" 5)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 5)}
wvSetPosition -win $_nWave2 {("G1" 6)}
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_arvalid" -line 95 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_arready" -line 95 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 7)}
wvSetPosition -win $_nWave2 {("G1" 6)}
wvSetPosition -win $_nWave2 {("G1" 5)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 5)}
wvSetPosition -win $_nWave2 {("G1" 7)}
wvSetCursor -win $_nWave2 108045.223940 -snap {("G1" 8)}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvSelectSignal -win $_nWave2 {( "G1" 8 )} 
wvSelectSignal -win $_nWave2 {( "G1" 9 )} 
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvSelectSignal -win $_nWave2 {( "G1" 12 )} 
wvSetCursor -win $_nWave2 109845.977672 -snap {("G1" 9)}
wvSetCursor -win $_nWave2 125152.384397 -snap {("G1" 12)}
srcActiveTrace "TB_HISOC.U_RVSEED.U_INST_MEM.axi_slv_rdata\[31:0\]" -win \
           $_nTrace1 -TraceByDConWave -TraceTime 10000 -TraceValue \
           00000000000000000000000000000000
wvSetPosition -win $_nWave2 {("G1" 12)}
wvSetPosition -win $_nWave2 {("G1" 13)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G1" 13)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 13)}
wvSetCursor -win $_nWave2 131455.022460 -snap {("G1" 12)}
srcActiveTrace "TB_HISOC.U_RVSEED.U_INST_MEM.mem_data_out\[31:0\]" -win $_nTrace1 \
           -TraceByDConWave -TraceTime 10000 -TraceValue \
           00000000000000000000000000000000
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_data\[mem_address\]" -line 96 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk" -line 91 -pos 1 -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM.U_AXI_SLV_CTRL_RD" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_INST_MEM.U_AXI_SLV_CTRL_RD" \
           -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM.U_AXI_SLV_CTRL_RD" -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_INST_MEM" -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_result_data" -line 102 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_address" -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 13)}
wvSetPosition -win $_nWave2 {("G1" 12)}
wvSetPosition -win $_nWave2 {("G1" 11)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 11)}
wvSetPosition -win $_nWave2 {("G1" 12)}
wvSetCursor -win $_nWave2 230496.477738 -snap {("G1" 12)}
wvSetCursor -win $_nWave2 345744.716608 -snap {("G1" 12)}
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_address" -win $_nTrace1
srcAction -pos 95 5 14 -win $_nTrace1 -name "mem_data\[mem_address\]" -ctrlKey \
          off
srcDeselectAll -win $_nTrace1
srcSelect -signal "burst_read_active" -line 85 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 12)}
wvSetPosition -win $_nWave2 {("G1" 11)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 11)}
wvSetPosition -win $_nWave2 {("G1" 12)}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_base_addr\[ADDR_LSB+:MEM_ADDR_WIDTH\]" -line 85 -pos 1 -win \
          $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "burst_read_active" -line 85 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_base_addr\[ADDR_LSB+:MEM_ADDR_WIDTH\]" -line 85 -pos 1 -win \
          $_nTrace1
srcAction -pos 84 19 4 -win $_nTrace1 -name \
          "rd_base_addr\[ADDR_LSB+:MEM_ADDR_WIDTH\]" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_araddr_r" -line 156 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 13 )} 
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
debReload
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "burst_read_active" -line 103 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "burst_read_active" -line 104 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
debReload
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 100991.518435 -snap {("G1" 13)}
srcDeselectAll -win $_nTrace1
debReload
wvUnknownSaveResult -win $_nWave2 -clear
srcDeselectAll -win $_nTrace1
debReload
wvSelectSignal -win $_nWave2 {( "G1" 9 )} 
wvSetCursor -win $_nWave2 150698.281415 -snap {("G1" 10)}
wvSelectSignal -win $_nWave2 {( "G1" 10 )} 
wvSetCursor -win $_nWave2 127028.394281 -snap {("G1" 10)}
srcActiveTrace "TB_HISOC.U_RVSEED.U_INST_MEM.axi_slv_rready" -win $_nTrace1 \
           -TraceByDConWave -TraceTime 30000 -TraceValue 1
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_rready" -line 210 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_rready" -line 210 -pos 1 -win $_nTrace1
srcAction -pos 209 6 4 -win $_nTrace1 -name "axi_rready" -ctrlKey off
srcDeselectAll -win $_nTrace1
debReload
wvSelectSignal -win $_nWave2 {( "G1" 9 )} 
wvSetCursor -win $_nWave2 146753.300226 -snap {("G1" 9)}
wvSelectSignal -win $_nWave2 {( "G1" 14 )} 
wvScrollDown -win $_nWave2 0
wvSelectSignal -win $_nWave2 {( "G1" 14 )} 
wvSelectSignal -win $_nWave2 {( "G1" 15 )} 
wvScrollUp -win $_nWave2 4
wvSelectSignal -win $_nWave2 {( "G1" 2 3 4 5 6 7 8 9 10 11 12 13 14 15 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 1)}
wvSelectSignal -win $_nWave2 {( "G1" 1 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G1" 0)}
srcDeselectAll -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED" -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED.U_IFU" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_IFU" -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_IFU" -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_INST_MEM" -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM" -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED.U_IFU" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_IFU" -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_IFU" -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED.U_IFU.clogb2" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_IFU.clogb2" -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_IFU.clogb2" -win $_nTrace1
srcDeselectAll -win $_nTrace1
debReload
srcHBSelect "TB_HISOC.U_RVSEED" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED" -delim "."
srcHBSelect "TB_HISOC.U_RVSEED" -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED.U_IFU" -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_INST_MEM" -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_araddr" -line 20 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk" -line 16 -pos 1 -win $_nTrace1
srcSelect -signal "rst_n" -line 17 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_arid" -line 19 -pos 1 -win $_nTrace1
srcSelect -toggle -signal "axi_slv_arid" -line 19 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_araddr" -line 20 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_arvalid" -line 29 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_arready" -line 30 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_rdata" -line 33 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_rvalid" -line 36 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_rready" -line 37 -pos 1 -win $_nTrace1
srcSelect -signal "axi_slv_rlast" -line 35 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvZoomAll -win $_nWave2
wvZoom -win $_nWave2 0.000000 16494234.762980
wvZoom -win $_nWave2 0.000000 595728.569318
wvSetCursor -win $_nWave2 25998.688503 -snap {("G1" 2)}
wvSetCursor -win $_nWave2 86512.877260 -snap {("G1" 4)}
wvSetCursor -win $_nWave2 21516.156002 -snap {("G1" 2)}
wvZoomAll -win $_nWave2
wvZoomAll -win $_nWave2
wvSetCursor -win $_nWave2 7422405.643341 -snap {("G1" 2)}
srcDeselectAll -win $_nTrace1
debReload
wvZoomAll -win $_nWave2
wvZoomAll -win $_nWave2
wvZoom -win $_nWave2 0.000000 226326.636569
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 95367.130533 -snap {("G1" 4)}
wvSelectSignal -win $_nWave2 {( "G1" 6 )} 
wvSelectSignal -win $_nWave2 {( "G1" 5 )} 
wvSelectSignal -win $_nWave2 {( "G1" 3 )} 
wvSetPosition -win $_nWave2 {("G1" 3)}
wvSetPosition -win $_nWave2 {("G1" 4)}
wvSetPosition -win $_nWave2 {("G1" 5)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 5)}
wvSelectSignal -win $_nWave2 {( "G1" 6 )} 
wvSelectSignal -win $_nWave2 {( "G1" 6 7 8 9 )} 
wvSetPosition -win $_nWave2 {("G1" 8)}
wvSetPosition -win $_nWave2 {("G1" 9)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 4)}
wvSetPosition -win $_nWave2 {("G2" 4)}
wvSelectSignal -win $_nWave2 {( "G2" 1 )} 
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSetPosition -win $_nWave2 {("G2" 2)}
wvSetPosition -win $_nWave2 {("G2" 3)}
wvSetPosition -win $_nWave2 {("G2" 4)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 4)}
wvSelectSignal -win $_nWave2 {( "G2" 3 )} 
wvSelectSignal -win $_nWave2 {( "G1" 5 )} 
wvSelectSignal -win $_nWave2 {( "G1" 3 )} 
wvSelectSignal -win $_nWave2 {( "G1" 3 4 5 )} 
wvSetCursor -win $_nWave2 88555.192638 -snap {("G1" 3)}
wvSetCursor -win $_nWave2 100816.680849 -snap {("G1" 3)}
wvSelectSignal -win $_nWave2 {( "G2" 1 )} 
wvSetCursor -win $_nWave2 167573.672223 -snap {("G2" 2)}
wvSetCursor -win $_nWave2 141688.308221 -snap {("G2" 1)}
srcActiveTrace "TB_HISOC.U_RVSEED.U_INST_MEM.axi_slv_rvalid" -win $_nTrace1 \
           -TraceByDConWave -TraceTime 10100 -TraceValue 0
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rvalid_r" -line 190 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rvalid_r" -line 190 -pos 1 -win $_nTrace1
srcAction -pos 189 6 9 -win $_nTrace1 -name "axi_slv_rvalid_r" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_result_en" -line 174 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_result_en" -line 174 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_result_en" -line 174 -pos 1 -win $_nTrace1
srcAction -pos 173 6 8 -win $_nTrace1 -name "rd_result_en" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_data_out_en" -line 107 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_data_out_en" -line 107 -pos 1 -win $_nTrace1
srcAction -pos 106 6 3 -win $_nTrace1 -name "mem_data_out_en" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_rden" -line 97 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_rden" -line 97 -pos 1 -win $_nTrace1
srcAction -pos 96 6 6 -win $_nTrace1 -name "mem_rden" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_req_en" -line 89 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_req_en" -line 89 -pos 1 -win $_nTrace1
srcAction -pos 88 6 5 -win $_nTrace1 -name "rd_req_en" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "burst_read_active" -line 105 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "burst_read_active" -line 105 -pos 1 -win $_nTrace1
srcAction -pos 104 6 6 -win $_nTrace1 -name "burst_read_active" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_arready" -line 97 -pos 1 -win $_nTrace1
debReload
wvSelectSignal -win $_nWave2 {( "G2" 1 )} 
wvSetCursor -win $_nWave2 198908.586541 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 185284.710750 -snap {("G2" 2)}
wvSetCursor -win $_nWave2 207082.912015 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 185284.710750 -snap {("G2" 2)}
wvSetCursor -win $_nWave2 200270.974120 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 192096.648645 -snap {("G2" 2)}
wvSetCursor -win $_nWave2 205720.524436 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 311986.755601 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 341959.282340 -snap {("G2" 2)}
wvSetCursor -win $_nWave2 201633.361699 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 168936.059802 -snap {("G2" 2)}
srcDeselectAll -win $_nTrace1
debReload
wvSetCursor -win $_nWave2 126702.044851 -snap {("G2" 1)}
wvSelectSignal -win $_nWave2 {( "G2" 5 )} 
wvSelectSignal -win $_nWave2 {( "G2" 6 )} 
wvSelectSignal -win $_nWave2 {( "G2" 6 7 8 9 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 5)}
wvSelectSignal -win $_nWave2 {( "G2" 3 )} 
wvSelectSignal -win $_nWave2 {( "G2" 5 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G2" 4)}
wvSelectSignal -win $_nWave2 {( "G2" 3 )} 
wvSetCursor -win $_nWave2 115802.944219 -snap {("G2" 3)}
wvSetCursor -win $_nWave2 234330.663596 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 351495.995394 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 465936.552033 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 110353.393903 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 201633.361699 -snap {("G1" 3)}
wvSetCursor -win $_nWave2 222069.175384 -snap {("G2" 4)}
srcActiveTrace "TB_HISOC.U_RVSEED.U_INST_MEM.axi_slv_rdata\[31:0\]" -win \
           $_nTrace1 -TraceByDConWave -TraceTime 50100 -TraceValue \
           00000000000000000000110100010011
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rdata_r" -line 191 -pos 1 -win $_nTrace1
srcAction -pos 190 6 6 -win $_nTrace1 -name "axi_slv_rdata_r" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_result_data" -line 185 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_result_data" -line 185 -pos 1 -win $_nTrace1
srcAction -pos 184 8 6 -win $_nTrace1 -name "rd_result_data" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_data_out" -line 106 -pos 1 -win $_nTrace1
srcAction -pos 105 6 7 -win $_nTrace1 -name "mem_data_out" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_data_out" -line 106 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_address" -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSetCursor -win $_nWave2 223431.562963 -snap {("G2" 5)}
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_rden" -line 97 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk" -line 92 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 5)}
wvSetPosition -win $_nWave2 {("G2" 4)}
wvSetPosition -win $_nWave2 {("G2" 3)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 3)}
wvSetPosition -win $_nWave2 {("G2" 4)}
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_rden" -line 90 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_rden" -line 90 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_rden" -line 90 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_rden" -line 90 -pos 1 -win $_nTrace1
srcAction -pos 89 15 6 -win $_nTrace1 -name "mem_rden" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_req_en" -line 89 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_req_en" -line 89 -pos 1 -win $_nTrace1
srcAction -pos 88 6 6 -win $_nTrace1 -name "rd_req_en" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "read_index" -line 105 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_arlen_r" -line 105 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "read_index" -line 105 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_req_en" -line 105 -pos 1 -win $_nTrace1
wvSetCursor -win $_nWave2 528606.380670 -snap {("G2" 2)}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_rvalid_r" -line 171 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_result_en" -line 173 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSetCursor -win $_nWave2 23160.588844 -snap {("G2" 2)}
wvSetCursor -win $_nWave2 35422.077055 -snap {("G2" 8)}
srcActiveTrace "TB_HISOC.U_RVSEED.U_INST_MEM.U_AXI_SLV_CTRL_RD.rd_result_en" -win \
           $_nTrace1 -TraceByDConWave -TraceTime 30000 -TraceValue 1
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_data_out_en" -line 107 -pos 1 -win $_nTrace1
srcAction -pos 106 6 10 -win $_nTrace1 -name "mem_data_out_en" -ctrlKey off
wvSelectSignal -win $_nWave2 {( "G2" 5 )} 
wvSetPosition -win $_nWave2 {("G2" 5)}
wvSetPosition -win $_nWave2 {("G2" 8)}
wvSetPosition -win $_nWave2 {("G1" 0)}
wvSetPosition -win $_nWave2 {("G2" 8)}
srcTraceConnectivity "TB_HISOC.U_RVSEED.U_INST_MEM.mem_rden" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem_rden" -line 97 -pos 1 -win $_nTrace1
srcAction -pos 96 6 6 -win $_nTrace1 -name "mem_rden" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_req_en" -line 89 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_req_en" -line 89 -pos 1 -win $_nTrace1
srcAction -pos 88 6 6 -win $_nTrace1 -name "rd_req_en" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "read_index" -line 105 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "axi_slv_arlen_r" -line 105 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "read_index" -line 105 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "rd_req_en" -line 105 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G2" 1 )} 
wvSetCursor -win $_nWave2 140325.920642 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 166211.284644 -snap {("G2" 4)}
wvSetCursor -win $_nWave2 144413.083379 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 267027.965493 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 391005.235186 -snap {("G2" 0)}
wvSetCursor -win $_nWave2 395092.397923 -snap {("G2" 1)}
wvSelectSignal -win $_nWave2 {( "G2" 1 2 3 4 )} 
wvSelectSignal -win $_nWave2 {( "G2" 4 )} 
wvSelectSignal -win $_nWave2 {( "G2" 4 10 )} 
wvSelectSignal -win $_nWave2 {( "G2" 4 5 6 7 8 9 10 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 3)}
wvSelectSignal -win $_nWave2 {( "G2" 1 )} 
wvSelectSignal -win $_nWave2 {( "G2" 1 2 3 )} 
wvSetPosition -win $_nWave2 {("G3" 0)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("G3" 3)}
wvSetPosition -win $_nWave2 {("G3" 3)}
wvSelectSignal -win $_nWave2 {( "G1" 3 )} 
wvSelectSignal -win $_nWave2 {( "G1" 3 4 5 )} 
wvSetPosition -win $_nWave2 {("G1" 5)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 3)}
wvSetCursor -win $_nWave2 91279.967796 -snap {("G2" 0)}
wvSetCursor -win $_nWave2 232968.276017 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 243867.376649 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 369207.033921 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 493184.303614 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 502721.016668 -snap {("G3" 1)}
wvSetCursor -win $_nWave2 619886.348466 -snap {("G3" 1)}
wvSetCursor -win $_nWave2 726152.579631 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 856941.787219 -snap {("G2" 1)}
wvZoomAll -win $_nWave2
wvSetCursor -win $_nWave2 7175392.626035 -snap {("G2" 3)}
wvSetCursor -win $_nWave2 9556013.544018 -snap {("G2" 3)}
wvZoom -win $_nWave2 10620586.982694 11006180.511663
wvZoom -win $_nWave2 10987321.535449 11000377.749748
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomAll -win $_nWave2
wvZoomAll -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G3" 3 )} 
wvSelectSignal -win $_nWave2 {( "G3" 1 )} 
wvSelectSignal -win $_nWave2 {( "G3" 2 )} 
wvSelectSignal -win $_nWave2 {( "G3" 3 )} 
wvSelectSignal -win $_nWave2 {( "G3" 1 )} 
wvSelectSignal -win $_nWave2 {( "G3" 3 )} 
wvSelectSignal -win $_nWave2 {( "G2" 1 )} 
wvSelectSignal -win $_nWave2 {( "G2" 3 )} 
wvSelectSignal -win $_nWave2 {( "G2" 1 )} 
wvSelectSignal -win $_nWave2 {( "G2" 3 )} 
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM.U_AXI_SLV_CTRL_RD" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_INST_MEM.U_AXI_SLV_CTRL_RD" \
           -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_INST_MEM.U_AXI_SLV_CTRL_RD" -win $_nTrace1
srcHBSelect "TB_HISOC.U_RVSEED.U_IFU" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_HISOC.U_RVSEED.U_IFU" -delim "."
srcHBSelect "TB_HISOC.U_RVSEED.U_IFU" -win $_nTrace1
