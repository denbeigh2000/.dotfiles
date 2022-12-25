{
  profiles = {
    triple = {
      fingerprint = {
        DP-0 = "00ffffffffffff0010acc4a04c46353015190104a5351e783a7c15a7544b9f260d5054a54b008100b300d100714fa9408180d1c00101565e00a0a0a02950302035000f282100001a000000ff00564b36484335354e3035464c0a000000fc0044454c4c205032343136440a20000000fd0031561d711c000a20202020202001b402031df15090050403020716010611121513141f202309070783010000023a801871382d40582c45000f282100001e011d8018711c1620582c25000f282100009e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f2821000018f44c00c082802b4060d835480f282100001c0000000000000000d7";
        DP-2 = "00ffffffffffff0010acc4a04c3846311c190104a5351e783a7c15a7544b9f260d5054a54b008100b300d100714fa9408180d1c00101565e00a0a0a02950302035000f282100001a000000ff00564b3648433537393146384c0a000000fc0044454c4c205032343136440a20000000fd0031561d711c000a20202020202001b802031df15090050403020716010611121513141f202309070783010000023a801871382d40582c45000f282100001e011d8018711c1620582c25000f282100009e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f2821000018f44c00c082802b4060d835480f282100001c0000000000000000d7";
        DP-4 = "00ffffffffffff0010acc4a04c5454311c190104a5351e783a7c15a7544b9f260d5054a54b008100b300d100714fa9408180d1c00101565e00a0a0a02950302035000f282100001a000000ff00564b3648433537393154544c0a000000fc0044454c4c205032343136440a20000000fd0031561d711c000a202020202020016402031df15090050403020716010611121513141f202309070783010000023a801871382d40582c45000f282100001e011d8018711c1620582c25000f282100009e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f2821000018f44c00c082802b4060d835480f282100001c0000000000000000d7";
      };
      config = {
        DP-0 = {
          enable = true;
          mode = "2560x1440";
          position = "1440x280";
          primary = true;
          rotate = "normal";
        };
        DP-2 = {
          enable = true;
          mode = "2560x1440";
          position = "0x0";
          rotate = "right";
        };
        DP-4= {
          enable = true;
          mode = "2560x1440";
          position = "4000x0";
          rotate = "left";
        };
      };
    };
  };
}