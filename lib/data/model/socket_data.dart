import 'dart:convert';

SocketData socketDataFromJson(String str) => SocketData.fromJson(json.decode(str));

String socketDataToJson(SocketData data) => json.encode(data.toJson());

class SocketData {
  SocketData({
    required this.socketDataE,
    required this.e,
    required this.s,
    required this.socketDataP,
    required this.p,
    required this.w,
    required this.x,
    required this.socketDataC,
    required this.q,
    required this.socketDataB,
    required this.b,
    required this.socketDataA,
    required this.a,
    required this.socketDataO,
    required this.h,
    required this.socketDataL,
    required this.v,
    required this.socketDataQ,
    required this.o,
    required this.c,
    required this.f,
    required this.l,
    required this.n,
  });

  String socketDataE;
  int e;
  String s;
  String socketDataP;
  String p;
  String w;
  String x;
  String socketDataC;
  String q;
  String socketDataB;
  String b;
  String socketDataA;
  String a;
  String socketDataO;
  String h;
  String socketDataL;
  String v;
  String socketDataQ;
  int o;
  int c;
  int f;
  int l;
  int n;

  factory SocketData.fromJson(Map<String, dynamic> json) => SocketData(
    socketDataE: json["e"],
    e: json["E"],
    s: json["s"],
    socketDataP: json["p"],
    p: json["P"],
    w: json["w"],
    x: json["x"],
    socketDataC: json["c"],
    q: json["Q"],
    socketDataB: json["b"],
    b: json["B"],
    socketDataA: json["a"],
    a: json["A"],
    socketDataO: json["o"],
    h: json["h"],
    socketDataL: json["l"],
    v: json["v"],
    socketDataQ: json["q"],
    o: json["O"],
    c: json["C"],
    f: json["F"],
    l: json["L"],
    n: json["n"],
  );

  Map<String, dynamic> toJson() => {
    "e": socketDataE,
    "E": e,
    "s": s,
    "p": socketDataP,
    "P": p,
    "w": w,
    "x": x,
    "c": socketDataC,
    "Q": q,
    "b": socketDataB,
    "B": b,
    "a": socketDataA,
    "A": a,
    "o": socketDataO,
    "h": h,
    "l": socketDataL,
    "v": v,
    "q": socketDataQ,
    "O": o,
    "C": c,
    "F": f,
    "L": l,
    "n": n,
  };
}
