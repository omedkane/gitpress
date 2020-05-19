import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ACloth {
  ACloth(this.cindex, this.cnawa, this.price);
  int cindex;
  String cnawa;
  int price;
}

class Contitems {
  Contitems(this.qty, this.imgfile, this.itemname, this.dacolor, this.oripixi)
      : pixi = qty * oripixi;
  int qty;
  String imgfile;
  String itemname;
  Color dacolor;
  int pixi;
  int oripixi;
  void updatepixi() {
    this.pixi = this.qty * this.oripixi;
  }

  void increaseqty() {
    this.qty++;
    this.updatepixi();
  }

  void decreaseqty() {
    if (this.qty != 0) this.qty--;
    this.updatepixi();
  }
}

ACloth shirts = ACloth(0, "Chemise(s)", 30);
ACloth pants = ACloth(1, "Pantalon(s)", 60);
ACloth boubous = ACloth(2, "Boubou(s)", 100);
ACloth suits = ACloth(3, "Veste(s)", 100);

List<ACloth> allclothes = [
  ACloth(0, "Chemise(s)", 30),
  ACloth(1, "Pantalon(s)", 60),
  ACloth(2, "Boubou(s)", 100),
  ACloth(3, "Veste(s)", 100)
];

var formatMe = NumberFormat("#,###", "en_US");

var daordersDb = [
  [
    DateTime.parse("2019-03-13"),
    [
      [
        [7, 1, 10, 3],
        "12h:31",
        true
      ],
      [
        [7, 1, 10, 3],
        "13h:32",
        false
      ],
      [
        [7, 1, 10, 3],
        "14h:33",
        false
      ],
    ],
  ],
  [
    DateTime.parse("2019-03-11"),
    [
      [
        [4, 0, 2, 8],
        "15h:34",
        false
      ],
      [
        [4, 0, 2, 8],
        "16h:35",
        true
      ],
      [
        [4, 0, 2, 8],
        "17h:36",
        false
      ],
    ],
  ],
  [
    DateTime.parse("2019-03-07"),
    [
      [
        [5, 2, 12, 0],
        "18h:37",
        true
      ],
      [
        [5, 2, 12, 0],
        "19h:38",
        true
      ],
      [
        [5, 2, 12, 0],
        "20h:39",
        true
      ],
    ],
  ]
];

var ml = [
  [//0
    '2020-03-29 00:47:34.751',// 0-0
    [//0-1  //daorders
      [//0-1-0  //0
        [//0-1-0-0    //0-0   //dadata
          [1, 'MUL91XsYPTNwzkA0evY7'], //elem
          [4, 'xtFv5ykhqhRpx7a6qWGj']
        ],
        '0h:47',//0-1-0-1     //0-1
        false,//0-1-0-2       //0-2
        'i7LvLZgZIxFMbjvfb7Is'//0-1-0-3     //0-3
      ]
    ]
  ],
  [
    '2020-03-28 01:36:51.129',
    [
      [
        [
          [3, '9oPtblnKFxyzJun3lXF3'],
          [2, 'MUL91XsYPTNwzkA0evY7']
        ],
        '1h:36',
        false,
        'YluteadYyaGSxiuQGTGT'
      ],
      [
        [
          [3, '9oPtblnKFxyzJun3lXF3'],
          [2, 'MUL91XsYPTNwzkA0evY7']
        ],
        '1h:36',
        false,
        'fHKBYmO2UP8T9Yw2RFWR'
      ]
    ]
  ]
];
