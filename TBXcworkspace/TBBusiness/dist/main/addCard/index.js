webpackJsonp([30],{316:function(e,n,t){function i(e){t(835)}var a=t(0)(t(446),t(925),i,"data-v-4d324b62",null);e.exports=a.exports,a.options.__file="/src/modules/main/addCard/index/index.vue"},446:function(e,n,t){"use strict";Object.defineProperty(n,"__esModule",{value:!0}),n.default={name:"addCard",data:function(){return{num:"",disable:!0}},watch:{num:function(){this.num?this.disable=!1:this.disable=!0}},methods:{go:function(){T.go("main/showAddCard/index")}}}},514:function(e,n,t){"use strict";Object.defineProperty(n,"__esModule",{value:!0});var i=(t(2),t(316)),a=t.n(i);init(a.a)},835:function(e,n){},925:function(e,n){e.exports={render:function(){var e=this,n=e.$createElement,t=e._self._c||n;return t("v-page",[t("div",{attrs:{slot:"header"},slot:"header"},[t("v-header",{staticStyle:{position:"relative"}},[t("v-btn",{attrs:{icon:"icon icon-back"}}),e._v(" "),t("h1",[e._v("添加卡片")])],1)],1),e._v(" "),t("main",[t("ul",[t("li",[t("v-input",{attrs:{title:"姓名",placeholder:"请输入本人银行卡号"},model:{value:e.num,callback:function(n){e.num=n},expression:"num"}})],1),e._v(" "),t("li",[t("v-input",{attrs:{title:"卡号",placeholder:"请输入本人银行卡号"},model:{value:e.num,callback:function(n){e.num=n},expression:"num"}}),e._v(" "),t("a",{class:"icon-xiangji"})],1)])]),e._v(" "),t("v-button",{class:{disable:e.disable},on:{click:e.go}},[e._v("验证卡号")])],1)},staticRenderFns:[]}}},[514]);
//# sourceMappingURL=index.js.map