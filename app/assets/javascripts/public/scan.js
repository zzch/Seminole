//= require jquery

$(document).ready(function(){
  var ua = navigator.userAgent.toLowerCase();
  if (ua.indexOf('android') > -1) {
    document.location = "http://assets.lianqiubao.com/apk/Lianqiubao_v1.0.0.apk";
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