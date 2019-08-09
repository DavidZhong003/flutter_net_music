class BannerModuleEntity {
  int code;
  List<BannerModuleBanner> banners;

  BannerModuleEntity({this.code, this.banners});

  BannerModuleEntity.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['banners'] != null) {
      banners = new List<BannerModuleBanner>();
      (json['banners'] as List).forEach((v) {
        banners.add(new BannerModuleBanner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.banners != null) {
      data['banners'] = this.banners.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerModuleBanner {
  dynamic adLocation;
  dynamic monitorImpress;
  String bannerId;
  dynamic extMonitor;
  dynamic pid;
  String pic;
  dynamic program;
  dynamic video;
  dynamic adurlV2;
  dynamic adDispatchJson;
  dynamic monitorType;
  dynamic adid;
  String titleColor;
  String requestId;
  bool exclusive;
  dynamic event;
  String scm;
  dynamic alg;
  BannerModuleBannersSong song;
  int targetId;
  bool showAdTag;
  dynamic adSource;
  dynamic showContext;
  int targetType;
  String typeTitle;
  String url;
  String encodeId;
  dynamic extMonitorInfo;
  dynamic monitorClick;
  List<Null> monitorImpressList;
  dynamic monitorBlackList;
  List<Null> monitorClickList;

  BannerModuleBanner(
      {this.adLocation,
      this.monitorImpress,
      this.bannerId,
      this.extMonitor,
      this.pid,
      this.pic,
      this.program,
      this.video,
      this.adurlV2,
      this.adDispatchJson,
      this.monitorType,
      this.adid,
      this.titleColor,
      this.requestId,
      this.exclusive,
      this.event,
      this.scm,
      this.alg,
      this.song,
      this.targetId,
      this.showAdTag,
      this.adSource,
      this.showContext,
      this.targetType,
      this.typeTitle,
      this.url,
      this.encodeId,
      this.extMonitorInfo,
      this.monitorClick,
      this.monitorImpressList,
      this.monitorBlackList,
      this.monitorClickList});

  BannerModuleBanner.fromJson(Map<String, dynamic> json) {
    adLocation = json['adLocation'];
    monitorImpress = json['monitorImpress'];
    bannerId = json['bannerId'];
    extMonitor = json['extMonitor'];
    pid = json['pid'];
    pic = json['pic'];
    program = json['program'];
    video = json['video'];
    adurlV2 = json['adurlV2'];
    adDispatchJson = json['adDispatchJson'];
    monitorType = json['monitorType'];
    adid = json['adid'];
    titleColor = json['titleColor'];
    requestId = json['requestId'];
    exclusive = json['exclusive'];
    event = json['event'];
    scm = json['scm'];
    alg = json['alg'];
    song = json['song'] != null
        ? new BannerModuleBannersSong.fromJson(json['song'])
        : null;
    targetId = json['targetId'];
    showAdTag = json['showAdTag'];
    adSource = json['adSource'];
    showContext = json['showContext'];
    targetType = json['targetType'];
    typeTitle = json['typeTitle'];
    url = json['url'];
    encodeId = json['encodeId'];
    extMonitorInfo = json['extMonitorInfo'];
    monitorClick = json['monitorClick'];
    if (json['monitorImpressList'] != null) {
      monitorImpressList = new List<Null>();
    }
    monitorBlackList = json['monitorBlackList'];
    if (json['monitorClickList'] != null) {
      monitorClickList = new List<Null>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adLocation'] = this.adLocation;
    data['monitorImpress'] = this.monitorImpress;
    data['bannerId'] = this.bannerId;
    data['extMonitor'] = this.extMonitor;
    data['pid'] = this.pid;
    data['pic'] = this.pic;
    data['program'] = this.program;
    data['video'] = this.video;
    data['adurlV2'] = this.adurlV2;
    data['adDispatchJson'] = this.adDispatchJson;
    data['monitorType'] = this.monitorType;
    data['adid'] = this.adid;
    data['titleColor'] = this.titleColor;
    data['requestId'] = this.requestId;
    data['exclusive'] = this.exclusive;
    data['event'] = this.event;
    data['scm'] = this.scm;
    data['alg'] = this.alg;
    if (this.song != null) {
      data['song'] = this.song.toJson();
    }
    data['targetId'] = this.targetId;
    data['showAdTag'] = this.showAdTag;
    data['adSource'] = this.adSource;
    data['showContext'] = this.showContext;
    data['targetType'] = this.targetType;
    data['typeTitle'] = this.typeTitle;
    data['url'] = this.url;
    data['encodeId'] = this.encodeId;
    data['extMonitorInfo'] = this.extMonitorInfo;
    data['monitorClick'] = this.monitorClick;
    if (this.monitorImpressList != null) {
      data['monitorImpressList'] = [];
    }
    data['monitorBlackList'] = this.monitorBlackList;
    if (this.monitorClickList != null) {
      data['monitorClickList'] = [];
    }
    return data;
  }
}

class BannerModuleBannersSong {
  int no;
  String rt;
  int copyright;
  int fee;
  dynamic rurl;
  BannerModuleBannersSongPrivilege privilege;
  int mst;
  int pst;
  int pop;
  int dt;
  int rtype;
  int sId;
  List<Null> rtUrls;
  int id;
  int st;
  dynamic a;
  String cd;
  int publishTime;
  String cf;
  BannerModuleBannersSongH h;
  int mv;
  BannerModuleBannersSongAl al;
  BannerModuleBannersSongL l;
  BannerModuleBannersSongM m;
  int cp;
  List<Null> alia;
  int djId;
  dynamic crbt;
  List<BannerModuleBannersSongAr> ar;
  dynamic rtUrl;
  int ftype;
  int t;
  int v;
  String name;
  int mark;

  BannerModuleBannersSong(
      {this.no,
      this.rt,
      this.copyright,
      this.fee,
      this.rurl,
      this.privilege,
      this.mst,
      this.pst,
      this.pop,
      this.dt,
      this.rtype,
      this.sId,
      this.rtUrls,
      this.id,
      this.st,
      this.a,
      this.cd,
      this.publishTime,
      this.cf,
      this.h,
      this.mv,
      this.al,
      this.l,
      this.m,
      this.cp,
      this.alia,
      this.djId,
      this.crbt,
      this.ar,
      this.rtUrl,
      this.ftype,
      this.t,
      this.v,
      this.name,
      this.mark});

  BannerModuleBannersSong.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    rt = json['rt'];
    copyright = json['copyright'];
    fee = json['fee'];
    rurl = json['rurl'];
    privilege = json['privilege'] != null
        ? new BannerModuleBannersSongPrivilege.fromJson(json['privilege'])
        : null;
    mst = json['mst'];
    pst = json['pst'];
    pop = json['pop'];
    dt = json['dt'];
    rtype = json['rtype'];
    sId = json['s_id'];
    if (json['rtUrls'] != null) {
      rtUrls = new List<Null>();
    }
    id = json['id'];
    st = json['st'];
    a = json['a'];
    cd = json['cd'];
    publishTime = json['publishTime'];
    cf = json['cf'];
    h = json['h'] != null
        ? new BannerModuleBannersSongH.fromJson(json['h'])
        : null;
    mv = json['mv'];
    al = json['al'] != null
        ? new BannerModuleBannersSongAl.fromJson(json['al'])
        : null;
    l = json['l'] != null
        ? new BannerModuleBannersSongL.fromJson(json['l'])
        : null;
    m = json['m'] != null
        ? new BannerModuleBannersSongM.fromJson(json['m'])
        : null;
    cp = json['cp'];
    if (json['alia'] != null) {
      alia = new List<Null>();
    }
    djId = json['djId'];
    crbt = json['crbt'];
    if (json['ar'] != null) {
      ar = new List<BannerModuleBannersSongAr>();
      (json['ar'] as List).forEach((v) {
        ar.add(new BannerModuleBannersSongAr.fromJson(v));
      });
    }
    rtUrl = json['rtUrl'];
    ftype = json['ftype'];
    t = json['t'];
    v = json['v'];
    name = json['name'];
    mark = json['mark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['no'] = this.no;
    data['rt'] = this.rt;
    data['copyright'] = this.copyright;
    data['fee'] = this.fee;
    data['rurl'] = this.rurl;
    if (this.privilege != null) {
      data['privilege'] = this.privilege.toJson();
    }
    data['mst'] = this.mst;
    data['pst'] = this.pst;
    data['pop'] = this.pop;
    data['dt'] = this.dt;
    data['rtype'] = this.rtype;
    data['s_id'] = this.sId;
    if (this.rtUrls != null) {
      data['rtUrls'] = [];
    }
    data['id'] = this.id;
    data['st'] = this.st;
    data['a'] = this.a;
    data['cd'] = this.cd;
    data['publishTime'] = this.publishTime;
    data['cf'] = this.cf;
    if (this.h != null) {
      data['h'] = this.h.toJson();
    }
    data['mv'] = this.mv;
    if (this.al != null) {
      data['al'] = this.al.toJson();
    }
    if (this.l != null) {
      data['l'] = this.l.toJson();
    }
    if (this.m != null) {
      data['m'] = this.m.toJson();
    }
    data['cp'] = this.cp;
    if (this.alia != null) {
      data['alia'] = [];
    }
    data['djId'] = this.djId;
    data['crbt'] = this.crbt;
    if (this.ar != null) {
      data['ar'] = this.ar.map((v) => v.toJson()).toList();
    }
    data['rtUrl'] = this.rtUrl;
    data['ftype'] = this.ftype;
    data['t'] = this.t;
    data['v'] = this.v;
    data['name'] = this.name;
    data['mark'] = this.mark;
    return data;
  }
}

class BannerModuleBannersSongPrivilege {
  int st;
  int flag;
  int subp;
  int fl;
  int fee;
  int dl;
  int cp;
  bool preSell;
  bool cs;
  bool toast;
  int maxbr;
  int id;
  int pl;
  int sp;
  int payed;

  BannerModuleBannersSongPrivilege(
      {this.st,
      this.flag,
      this.subp,
      this.fl,
      this.fee,
      this.dl,
      this.cp,
      this.preSell,
      this.cs,
      this.toast,
      this.maxbr,
      this.id,
      this.pl,
      this.sp,
      this.payed});

  BannerModuleBannersSongPrivilege.fromJson(Map<String, dynamic> json) {
    st = json['st'];
    flag = json['flag'];
    subp = json['subp'];
    fl = json['fl'];
    fee = json['fee'];
    dl = json['dl'];
    cp = json['cp'];
    preSell = json['preSell'];
    cs = json['cs'];
    toast = json['toast'];
    maxbr = json['maxbr'];
    id = json['id'];
    pl = json['pl'];
    sp = json['sp'];
    payed = json['payed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['st'] = this.st;
    data['flag'] = this.flag;
    data['subp'] = this.subp;
    data['fl'] = this.fl;
    data['fee'] = this.fee;
    data['dl'] = this.dl;
    data['cp'] = this.cp;
    data['preSell'] = this.preSell;
    data['cs'] = this.cs;
    data['toast'] = this.toast;
    data['maxbr'] = this.maxbr;
    data['id'] = this.id;
    data['pl'] = this.pl;
    data['sp'] = this.sp;
    data['payed'] = this.payed;
    return data;
  }
}

class BannerModuleBannersSongH {
  int br;
  int fid;
  int size;
  int vd;

  BannerModuleBannersSongH({this.br, this.fid, this.size, this.vd});

  BannerModuleBannersSongH.fromJson(Map<String, dynamic> json) {
    br = json['br'];
    fid = json['fid'];
    size = json['size'];
    vd = json['vd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['br'] = this.br;
    data['fid'] = this.fid;
    data['size'] = this.size;
    data['vd'] = this.vd;
    return data;
  }
}

class BannerModuleBannersSongAl {
  String picUrl;
  String name;
  List<Null> tns;
  String picStr;
  int id;
  int pic;

  BannerModuleBannersSongAl(
      {this.picUrl, this.name, this.tns, this.picStr, this.id, this.pic});

  BannerModuleBannersSongAl.fromJson(Map<String, dynamic> json) {
    picUrl = json['picUrl'];
    name = json['name'];
    if (json['tns'] != null) {
      tns = new List<Null>();
    }
    picStr = json['pic_str'];
    id = json['id'];
    pic = json['pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['picUrl'] = this.picUrl;
    data['name'] = this.name;
    if (this.tns != null) {
      data['tns'] = [];
    }
    data['pic_str'] = this.picStr;
    data['id'] = this.id;
    data['pic'] = this.pic;
    return data;
  }
}

class BannerModuleBannersSongL {
  int br;
  int fid;
  int size;
  int vd;

  BannerModuleBannersSongL({this.br, this.fid, this.size, this.vd});

  BannerModuleBannersSongL.fromJson(Map<String, dynamic> json) {
    br = json['br'];
    fid = json['fid'];
    size = json['size'];
    vd = json['vd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['br'] = this.br;
    data['fid'] = this.fid;
    data['size'] = this.size;
    data['vd'] = this.vd;
    return data;
  }
}

class BannerModuleBannersSongM {
  int br;
  int fid;
  int size;
  int vd;

  BannerModuleBannersSongM({this.br, this.fid, this.size, this.vd});

  BannerModuleBannersSongM.fromJson(Map<String, dynamic> json) {
    br = json['br'];
    fid = json['fid'];
    size = json['size'];
    vd = json['vd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['br'] = this.br;
    data['fid'] = this.fid;
    data['size'] = this.size;
    data['vd'] = this.vd;
    return data;
  }
}

class BannerModuleBannersSongAr {
  String name;
  List<Null> tns;
  List<Null> alias;
  int id;

  BannerModuleBannersSongAr({this.name, this.tns, this.alias, this.id});

  BannerModuleBannersSongAr.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['tns'] != null) {
      tns = new List<Null>();
    }
    if (json['alias'] != null) {
      alias = new List<Null>();
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.tns != null) {
      data['tns'] = [];
    }
    if (this.alias != null) {
      data['alias'] = [];
    }
    data['id'] = this.id;
    return data;
  }
}
