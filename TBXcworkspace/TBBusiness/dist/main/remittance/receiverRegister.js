webpackJsonp([26],{322:function(a,t,s){function n(a){s(852)}var e=s(0)(s(453),s(942),n,"data-v-70f06c83",null);a.exports=e.exports,e.options.__file="/src/modules/main/remittance/receiverRegister/receiverRegister.vue"},453:function(a,t,s){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var n=s(11),e=s.n(n);t.default={name:"receiverRegister",data:function(){return{registerList:[{name:"冯宝宝",showCardList:!1,cardList:[{bankIcon:"zhongguogongshangyinhang",bankName:"中国工商银行",cardNo:"62245454512745454"},{bankIcon:"zhongguominshengyinhang",bankName:"中国民生银行",cardNo:"6224545451274567"},{bankIcon:"pufayinhang",bankName:"浦发银行",cardNo:"62245454512741234"}]},{name:"王也",showCardList:!1,cardList:[{bankIcon:"guangfayinhang",bankName:"广发银行",cardNo:"62245454512741235"}]},{name:"张之维",showCardList:!1,cardList:[{bankIcon:"zhaoshangyinhang",bankName:"中国招商银行",cardNo:"62245454512741236"}]}]}},filters:{formatBankCard:function(a){if(!a)return"";a=a.toString();var t=/^(\d{4})(.*)(\d{4})$/;return a=a.replace(t,function(a,t,s,n){return t+" **** "+n})}},methods:{showCardList:function(a){this.registerList[a].showCardList=!this.registerList[a].showCardList},chooseCard:function(a,t){t.name=a;var s={recName:t.name,recCardNo:t.cardNo};this.jumpBack("main/remittance/remittanceInput",s)},jumpBack:function(a,t){console.log(e()(this.remittanceInfo,t)),window.T.back({params:e()(this.remittanceInfo,t),back:a})},getPageParams:function(){var a=this;window.T.Native.getPageParams().then(function(t){var s=t.params;a.remittanceInfo=e()(a.remittanceInfo||{},s)})}},created:function(){this.getPageParams()}}},521:function(a,t,s){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var n=(s(2),s(322)),e=s.n(n);init(e.a)},852:function(a,t){},942:function(a,t){a.exports={render:function(){var a=this,t=a.$createElement,s=a._self._c||t;return s("v-page",[s("div",{attrs:{slot:"header"},slot:"header"},[s("v-header",[s("v-btn"),a._v(" "),s("h1",[a._v("收款人名册")]),a._v(" "),s("v-btn-text",[s("span",{staticClass:"header-btn-txt"},[a._v("手机通讯录")])])],1)],1),a._v(" "),s("div",{staticClass:"rec-container"},[s("v-scroller",{attrs:{outTop:!0}},[s("ul",{staticClass:"register-list font-num"},a._l(a.registerList,function(t,n){return s("li",{key:n,staticClass:"item"},[s("div",{directives:[{name:"show",rawName:"v-show",value:t.cardList.length>1,expression:"item.cardList.length > 1"}],staticClass:"hasMoreCard"},[s("div",{staticClass:"info-wrap",on:{click:function(t){a.showCardList(n)}}},[s("div",{staticClass:"left"},[s("v-symbol",{attrs:{name:"card-active-copy"}})],1),a._v(" "),s("div",{staticClass:"middle"},[s("span",{staticClass:"top"},[a._v(a._s(t.name))])]),a._v(" "),s("div",{staticClass:"right"},[s("p",{staticClass:"card-count"},[s("span",[a._v(a._s(t.cardList.length))]),s("span",[a._v("张")])]),a._v(" "),s("div",{staticClass:"icon-wrap"},[s("i",{staticClass:"icon icon-list_icon_down-",class:{active:t.showCardList}})])])]),a._v(" "),s("ul",{staticClass:"card-list",class:{active:t.showCardList}},a._l(t.cardList,function(n,e){return s("li",{key:e,staticClass:"card-item",on:{click:function(s){a.chooseCard(t.name,n)}}},[s("div",{staticClass:"icon-wrap"},[s("v-symbol",{attrs:{name:n.bankIcon}})],1),a._v(" "),s("p",{staticClass:"bank-name"},[a._v(a._s(n.bankName))]),a._v(" "),s("p",{staticClass:"card-no"},[a._v(a._s(a._f("formatBankCard")(n.cardNo)))])])}))]),a._v(" "),s("div",{directives:[{name:"show",rawName:"v-show",value:1===t.cardList.length,expression:"item.cardList.length === 1"}],staticClass:"hasOneCard"},[s("div",{staticClass:"info-wrap",on:{click:function(s){a.chooseCard(t.name,t.cardList[0])}}},[s("div",{staticClass:"left"},[s("v-symbol",{attrs:{name:t.cardList[0].bankIcon}})],1),a._v(" "),s("div",{staticClass:"middle"},[s("span",{staticClass:"top"},[a._v(a._s(t.name))]),a._v(" "),s("p",{staticClass:"bottom"},[s("span",{staticClass:"bank-name"},[a._v(a._s(t.cardList[0].bankName))]),a._v(" "),s("span",{staticClass:"card-no"},[a._v(a._s(a._f("formatBankCard")(t.cardList[0].cardNo)))])])])])])])}))])],1)])},staticRenderFns:[]}}},[521]);
//# sourceMappingURL=receiverRegister.js.map