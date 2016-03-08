//= require jquery

$(document).ready(function(){
  var ua = navigator.userAgent.toLowerCase();
  if (ua.indexOf('android') > -1) {
    document.location = "http://fusion.qq.com/app_download?appid=1105163992&platform=qzone&via=QZ.MOBILEDETAIL.QRCODE&u=3046917960";
  } else if (ua.indexOf('iphone') > -1) {
    if (ua.match(/MicroMessenger/i) == "micromessenger") {
      $("#weixin").show();
    } else {
      document.location = "https://itunes.apple.com/us/app/lian-qiu-bao/id1058814578";
    }
  } else if (ua.indexOf('ipad') > -1) {
    if (ua.match(/MicroMessenger/i) == "micromessenger") {
      $("#weixin").show();
    } else {
      document.location = "https://itunes.apple.com/us/app/lian-qiu-bao/id1058814578";
    }
  } else {
    document.location = "http://lianqiubao.com";
  }
});