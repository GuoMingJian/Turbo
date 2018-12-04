webpackJsonp([11],{117:function(t,e,n){function a(t){n(130)}var i=n(0)(n(118),n(133),a,"data-v-ab1c66ca",null);t.exports=i.exports,i.options.__file="/src/modules/main/components/linearButton/linearButton.vue"},118:function(t,e,n){"use strict";Object.defineProperty(e,"__esModule",{value:!0}),e.default={name:"linearButton",props:{btnTxt:{type:String,default:""},disabled:{type:Boolean,default:!1}},methods:{handleClick:function(){this.$emit("click")}}}},119:function(t,e,n){"use strict";var a=n(117),i=n.n(a);n.d(e,"a",function(){return i.a})},130:function(t,e){},133:function(t,e){t.exports={render:function(){var t=this,e=t.$createElement;return(t._self._c||e)("button",{staticClass:"btn",attrs:{disabled:t.disabled},on:{click:t.handleClick}},[t._v("\n    "+t._s(t.btnTxt)+"\n")])},staticRenderFns:[]}},167:function(t,e,n){function a(t){n(224)}var i=n(0)(n(173),n(231),a,"data-v-0650ec56",null);t.exports=i.exports,i.options.__file="/src/modules/main/components/inputCell/inputCell.vue"},173:function(t,e,n){"use strict";Object.defineProperty(e,"__esModule",{value:!0}),e.default={name:"inputCell",props:{value:{default:""},title:{type:String,default:""},inputType:{type:String,default:"text"},placeholder:{type:String,default:""},readonly:{type:Boolean,default:!1}}}},180:function(t,e,n){"use strict";var a=n(167),i=n.n(a);n.d(e,"a",function(){return i.a})},224:function(t,e){},231:function(t,e){t.exports={render:function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"ui-input-cell"},[n("div",{staticClass:"title"},[t._v("\n        "+t._s(t.title)+"\n    ")]),t._v(" "),n("div",{staticClass:"input-box font-num"},[t._t("input")],2),t._v(" "),n("div",{staticClass:"right"},[t._t("right")],2)])},staticRenderFns:[]}},323:function(t,e,n){function a(t){n(802)}var i=n(0)(n(454),n(890),a,"data-v-0805139d",null);t.exports=i.exports,i.options.__file="/src/modules/main/remittance/remittanceInput/remittanceInput.vue"},330:function(t,e,n){"use strict";e.a={methods:{},created:function(){}}},454:function(t,e,n){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var a=n(11),i=n.n(a),s=n(180),o=n(119);e.default={name:"remittanceInput",components:{vInputCell:s.a,vLinearButton:o.a},computed:{showTips:function(){return parseFloat(this.remittanceInfo.amount)>parseFloat(this.remittanceInfo.balance)},showRecPoint:function(){return parseFloat(this.remittanceInfo.amount)>parseFloat(this.maxShowRecPoint)},canNext:function(){return""!==this.remittanceInfo.amount&&""!==this.remittanceInfo.tranType&&""!==this.remittanceInfo.recName&&""!==this.remittanceInfo.recCardNo&&""!==this.remittanceInfo.recBank&&(this.showRecPoint&&""!==this.remittanceInfo.recPoint||!this.showRecPoint)}},data:function(){return{options:{scroll:!0},showPostscript:!1,postscriptList:[{txt:"工资"},{txt:"还款"},{txt:"房租"},{txt:"生活费"},{txt:"贷款"}],remittanceInfo:{amount:"",balance:"122017.18",tranNo:"",tranType:"实时转账",tranTypeNum:"0",recName:"",recCardNo:"",recBank:"测试银行",recPoint:"测试收款网点",recPhone:"",postScript:"",tranActiveIndex:"0",bankCardActiveIndex:"0"},tranAccountList:[{type:"实时转账",tips:"",typeNum:"0",isActive:!1},{type:"次日转账",tips:"将于次日（0点之后）汇出款项",typeNum:"1",isActive:!1},{type:"普通转账",tips:"将于24小时之内汇出款项",typeNum:"2",isActive:!1}],bankCardList:[{bankIcon:"zhongguominshengyinhang",bankName:"民生银行",bankCardNo:"6214000000000006666",bankCardType:"储蓄卡",name:"程璧荣",balance:"123456789"},{bankIcon:"zhongguogongshangyinhang",bankName:"工商银行",bankCardNo:"6214 **** 6555",bankCardType:"储蓄卡",balance:"223456789",name:"张三"},{bankIcon:"pufayinhang",bankName:"浦发银行",bankCardNo:"6214 **** 6444",bankCardType:"储蓄卡",balance:"129545",name:"王五"},{bankIcon:"guangfayinhang",bankName:"广发银行",bankCardNo:"6214 **** 6333",bankCardType:"储蓄卡",balance:"999999999",name:"冯宝宝"},{bankIcon:"dongyayinhang",bankName:"东亚银行",bankCardNo:"6214 **** 6222",bankCardType:"储蓄卡",balance:"78954",name:"王也"},{bankIcon:"zhaoshangyinhang",bankName:"招商银行",bankCardNo:"6214 **** 6111",bankCardType:"储蓄卡",balance:"4399",name:"张起灵"}],maxShowRecPoint:"100000",maxTran:"100000",show:!1,showAlert:!1,popupType:"",popupInfo:{title:"选择转账方式"},alertMsg:"您的转账金额大于实时转账限额，已转为普通转账方式（24小时内汇出款项）",tranActiveIndex:"0",bankCardActiveIndex:"0"}},filters:{normalizeMoney:function(t){if(!t)return"";t=parseFloat(t),t=t.toFixed(2);for(var e=t.toString(),n=e.split("."),a=n[0].split("").reverse(),i=n[1],s=a.length,o=[],r=0;r<s;r+=3)o.unshift(a.slice(r,r+3).reverse().join(""));return o.join(",")+"."+i},formatBankCard:function(t){if(!t)return"";t=t.toString();var e=/^(\d{4})(.*)(\d{4})$/;return t=t.replace(e,function(t,e,n,a){return e+" **** "+a})}},methods:{handleShowPostscript:function(){this.showPostscript=!this.showPostscript},limitInput:function(t){var e=t.target.value,n="",a="";if(e=e.replace(/[^0-9\.]/gi,""),e.indexOf(".")>-1){var i=e.indexOf(".");n=e.slice(0,i),a=e.slice(i+1).toString().replace(/\./gi,""),a.length>2&&(a=a.slice(0,2)),t.target.value=n+"."+a,this.remittanceInfo.amount=n+"."+a}else t.target.value=e,this.remittanceInfo.amount=e;this.isOverMaxTran()},reformatMoney:function(t){if(!t)return"";t=parseFloat(t),t=t.toFixed(2);for(var e=t.toString(),n=e.split("."),a=n[0].split("").reverse(),i=n[1],s=a.length,o=[],r=0;r<s;r+=3)o.unshift(a.slice(r,r+3).reverse().join(""));return o.join(",")+"."+i},showTranAccount:function(){this.popupType="tran",this.popupInfo.title="选择转账方式",this.show=!0},handleShowCardList:function(){this.popupType="card",this.popupInfo.title="选择卡片",this.show=!0},closePopup:function(){this.show=!1},chooseTranAccountType:function(t){parseFloat(this.maxTran)<parseFloat(this.remittanceInfo.amount)&&0==t||(this.activeTranIndex("tranActiveIndex","tranAccountList",t),this.remittanceInfo.tranType=this.tranAccountList[this.remittanceInfo.tranActiveIndex].type,this.remittanceInfo.tranTypeNum=this.tranAccountList[this.remittanceInfo.tranActiveIndex].typeNum,this.closePopup())},chooseCard:function(t){this.activeTranIndex("bankCardActiveIndex","bankCardList",t),this.remittanceInfo=i()(this.remittanceInfo,this.bankCardList[this.bankCardActiveIndex]),this.closePopup()},activeTranIndex:function(t,e,n){this[t]=""===this[t]?0:this[t];this[t];this.remittanceInfo[t]=n},isOverMaxTran:function(){0==this.remittanceInfo.tranActiveIndex&&parseFloat(this.maxTran)<parseFloat(this.remittanceInfo.amount)&&(this.remittanceInfo.tranActiveIndex="2",this.showAlert=!0)},jumpRecPointPage:function(){this.jumpPage("main/remittance/recPoint")},jumpRecBankPage:function(){this.jumpPage("main/remittance/chooseRecBank")},jumpTransferPage:function(){this.remittanceInfo.tranNo=this.bankCardList[this.bankCardActiveIndex].bankCardNo,this.jumpPage("/main/remittance/transferRemittance")},jumpPageRegister:function(){this.jumpPage("/main/remittance/receiverRegister")},jumpAddBankCard:function(){this.jumpPage("/login/addBankCard/addBankCard")},jumpPage:function(t){var e={path:t,params:this.remittanceInfo};window.T.go(e)},setPostScript:function(t){this.remittanceInfo.postScript=t},getPageParams:function(){var t=this;window.T.Native.getPageParams().then(function(e){var n=e.params;t.remittanceInfo=i()(t.remittanceInfo,n)})}},created:function(){this.getPageParams()}}},522:function(t,e,n){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var a=n(11),i=n.n(a),s=(n(2),n(323)),o=n.n(s),r=n(330),c=i()(o.a,{mixins:[r.a]});init(c)},802:function(t,e){},890:function(t,e){t.exports={render:function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("v-page",{attrs:{options:t.options}},[n("div",{staticClass:"remittance-container"},[n("div",{staticClass:"card-info font-num"},[n("div",{staticClass:"top"},[n("p",[t._v("转出账号")]),t._v(" "),n("p",{staticClass:"card-no",on:{click:t.handleShowCardList}},[n("span",[t._v(t._s(t._f("formatBankCard")(t.bankCardList[t.remittanceInfo.bankCardActiveIndex].bankCardNo)))]),t._v(" "),n("i",{staticClass:"icon icon-list_icon_down-",class:{active:t.show&&"card"===t.popupType}})])]),t._v(" "),n("div",{staticClass:"bottom"},[n("span",{staticClass:"txt"},[t._v("余额")]),t._v(" "),n("span",{staticClass:"money"},[t._v(t._s(t._f("normalizeMoney")(t.bankCardList[t.remittanceInfo.bankCardActiveIndex].balance))+"元")])])]),t._v(" "),n("div",{staticClass:"amount"},[n("div",{staticClass:"top"},[n("span",{staticClass:"txt"},[t._v("转账金额")]),t._v(" "),n("p",{staticClass:"remittance-type"},[n("span",{staticClass:"type"},[t._v(t._s(t.tranAccountList[t.remittanceInfo.tranActiveIndex].type))]),t._v(" "),n("span",{staticClass:"change-type",on:{click:t.showTranAccount}},[t._v("更换")])])]),t._v(" "),n("div",{staticClass:"bottom"},[n("span",{staticClass:"rem-sign"},[t._v("¥")]),t._v(" "),n("div",{staticClass:"input-box font-num"},[n("input",{directives:[{name:"model",rawName:"v-model",value:t.remittanceInfo.amount,expression:"remittanceInfo.amount"}],attrs:{type:"text"},domProps:{value:t.remittanceInfo.amount},on:{input:[function(e){e.target.composing||t.$set(t.remittanceInfo,"amount",e.target.value)},t.limitInput]}})])])]),t._v(" "),n("div",{directives:[{name:"show",rawName:"v-show",value:t.showTips,expression:"showTips"}],staticClass:"tips"},[n("div",{staticClass:"symbol-wrap"},[n("v-symbol",{attrs:{name:"warn"}})],1),t._v(" "),n("p",[t._v("所输金额不能超过余额范围!")])]),t._v(" "),n("ul",{staticClass:"input-group font-num"},[n("li",{staticClass:"item"},[n("v-input-cell",{attrs:{title:"收款人"}},[n("input",{directives:[{name:"model",rawName:"v-model",value:t.remittanceInfo.recName,expression:"remittanceInfo.recName"}],attrs:{slot:"input",type:"text",placeholder:"请输入收款人姓名",maxlength:"15"},domProps:{value:t.remittanceInfo.recName},on:{input:function(e){e.target.composing||t.$set(t.remittanceInfo,"recName",e.target.value)}},slot:"input"}),t._v(" "),n("div",{staticClass:"icon-wrap",attrs:{slot:"right"},on:{click:t.jumpPageRegister},slot:"right"},[n("i",{staticClass:"icon icon-head_default"})])])],1),t._v(" "),n("li",{staticClass:"item"},[n("v-input-cell",{attrs:{title:"收款账号"}},[n("input",{directives:[{name:"model",rawName:"v-model",value:t.remittanceInfo.recCardNo,expression:"remittanceInfo.recCardNo"}],attrs:{slot:"input",type:"tel",placeholder:"请输入收款人账号",maxlength:"20"},domProps:{value:t.remittanceInfo.recCardNo},on:{input:function(e){e.target.composing||t.$set(t.remittanceInfo,"recCardNo",e.target.value)}},slot:"input"})])],1),t._v(" "),n("li",{staticClass:"item"},[n("v-input-cell",{attrs:{title:"收款银行"}},[n("input",{directives:[{name:"model",rawName:"v-model",value:t.remittanceInfo.recBank,expression:"remittanceInfo.recBank"}],attrs:{slot:"input",type:"text",placeholder:"选择银行",readonly:""},domProps:{value:t.remittanceInfo.recBank},on:{input:function(e){e.target.composing||t.$set(t.remittanceInfo,"recBank",e.target.value)}},slot:"input"}),t._v(" "),n("div",{staticClass:"icon-wrap",attrs:{slot:"right"},on:{click:t.jumpRecBankPage},slot:"right"},[n("i",{staticClass:"icon icon-list_icon_path-"})])])],1),t._v(" "),n("li",{directives:[{name:"show",rawName:"v-show",value:t.showRecPoint,expression:"showRecPoint"}],staticClass:"item"},[n("v-input-cell",{attrs:{title:"收款网点"}},[n("input",{directives:[{name:"model",rawName:"v-model",value:t.remittanceInfo.recPoint,expression:"remittanceInfo.recPoint"}],attrs:{slot:"input",type:"text",placeholder:"选择网点",readonly:""},domProps:{value:t.remittanceInfo.recPoint},on:{input:function(e){e.target.composing||t.$set(t.remittanceInfo,"recPoint",e.target.value)}},slot:"input"}),t._v(" "),n("div",{staticClass:"icon-wrap",attrs:{slot:"right"},on:{click:t.jumpRecPointPage},slot:"right"},[n("i",{staticClass:"icon icon-list_icon_path-"})])])],1),t._v(" "),n("li",{staticClass:"item"},[n("v-input-cell",{attrs:{title:"短信通知"}},[n("input",{directives:[{name:"model",rawName:"v-model",value:t.remittanceInfo.recPhone,expression:"remittanceInfo.recPhone"}],attrs:{slot:"input",type:"tel",placeholder:"收款人手机号（可不填）",maxlength:"11"},domProps:{value:t.remittanceInfo.recPhone},on:{input:function(e){e.target.composing||t.$set(t.remittanceInfo,"recPhone",e.target.value)}},slot:"input"})])],1)]),t._v(" "),n("div",{staticClass:"postscript"},[n("v-input-cell",{attrs:{title:"附言"}},[n("input",{directives:[{name:"model",rawName:"v-model",value:t.remittanceInfo.postScript,expression:"remittanceInfo.postScript"}],attrs:{slot:"input",type:"text",placeholder:"转账备注（可不填）"},domProps:{value:t.remittanceInfo.postScript},on:{input:function(e){e.target.composing||t.$set(t.remittanceInfo,"postScript",e.target.value)}},slot:"input"}),t._v(" "),n("div",{staticClass:"icon-wrap",attrs:{slot:"right"},on:{click:t.handleShowPostscript},slot:"right"},[n("i",{staticClass:"icon icon-list_icon_down-",class:{active:t.showPostscript}})])]),t._v(" "),n("div",{staticClass:"list-wrap"},[n("ul",{staticClass:"postscript-list"},t._l(t.postscriptList,function(e,a){return n("li",{key:a,staticClass:"item",on:{click:function(n){t.setPostScript(e.txt)}}},[t._v("\n                        "+t._s(e.txt)+"\n                    ")])}))])],1),t._v(" "),n("div",{staticClass:"btn-wrap",class:{active:t.showPostscript}},[n("v-linear-button",{attrs:{btnTxt:"下一步",disabled:!t.canNext},on:{click:t.jumpTransferPage}})],1)]),t._v(" "),n("v-popup",{model:{value:t.show,callback:function(e){t.show=e},expression:"show"}},[n("div",{staticClass:"popup-wrap"},[n("div",{staticClass:"title-wrap"},[n("h1",{staticClass:"title"},[t._v(t._s(t.popupInfo.title))]),t._v(" "),n("span",{staticClass:"popup-cancel",on:{click:t.closePopup}},[t._v("取消")])]),t._v(" "),n("div",{staticClass:"list-wrap font-num"},[n("ul",{directives:[{name:"show",rawName:"v-show",value:"tran"===t.popupType,expression:"popupType === 'tran'"}],staticClass:"tran-type-list list"},t._l(t.tranAccountList,function(e,a){return n("li",{key:a,staticClass:"item",on:{click:function(e){t.chooseTranAccountType(a)}}},[n("div",{staticClass:"left"},[n("span",{staticClass:"top"},[t._v(t._s(e.type))]),t._v(" "),n("span",{staticClass:"bottom"},[t._v(t._s(e.tips))])]),t._v(" "),n("div",{staticClass:"right"},[n("i",{directives:[{name:"show",rawName:"v-show",value:a==t.remittanceInfo.tranActiveIndex,expression:"index == remittanceInfo.tranActiveIndex"}],staticClass:"icon icon-check"})])])})),t._v(" "),n("ul",{directives:[{name:"show",rawName:"v-show",value:"card"===t.popupType,expression:"popupType === 'card'"}],staticClass:"card-list list"},[t._l(t.bankCardList,function(e,a){return n("li",{key:a,staticClass:"item",on:{click:function(e){t.chooseCard(a)}}},[n("div",{staticClass:"left"},[n("div",{staticClass:"symbol-wrap"},[n("v-symbol",{attrs:{name:e.bankIcon}})],1),t._v(" "),n("div",{staticClass:"cardInfo"},[n("span",{staticClass:"top"},[t._v(t._s(e.name))]),t._v(" "),n("p",{staticClass:"bottom"},[n("span",[t._v(t._s(""+e.bankName+e.bankCardType))]),t._v(" "),n("span",{staticClass:"card-no"},[t._v(t._s(t._f("formatBankCard")(e.bankCardNo)))])])])]),t._v(" "),n("div",{staticClass:"right"},[n("i",{directives:[{name:"show",rawName:"v-show",value:t.remittanceInfo.bankCardActiveIndex==a,expression:"remittanceInfo.bankCardActiveIndex == index"}],staticClass:"icon icon-check"})])])}),t._v(" "),n("li",{staticClass:"item add",on:{click:t.jumpAddBankCard}},[n("v-symbol",{attrs:{name:"add"}}),t._v(" "),n("span",{staticClass:"txt"},[t._v("添加卡片")])],1)],2)])])]),t._v(" "),n("v-alert",{model:{value:t.showAlert,callback:function(e){t.showAlert=e},expression:"showAlert"}},[n("p",{staticClass:"alert-txt"},[t._v(t._s(t.alertMsg))])])],1)},staticRenderFns:[]}}},[522]);
//# sourceMappingURL=remittanceInput.js.map