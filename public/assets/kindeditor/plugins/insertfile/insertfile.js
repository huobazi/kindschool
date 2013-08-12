/*******************************************************************************
* KindEditor - WYSIWYG HTML Editor for Internet
* Copyright (C) 2006-2011 kindsoft.net
*
* @author Roddy <luolonghao@gmail.com>
* @site http://www.kindsoft.net/
* @licence http://www.kindsoft.net/license.php
*******************************************************************************/
KindEditor.plugin("insertfile",function(e){var t=this,a="insertfile",i=e.undef(t.allowFileUpload,!0),n=e.undef(t.allowFileManager,!1),l=e.undef(t.formatUploadUrl,!0),o=e.undef(t.uploadJson,t.basePath+"php/upload_json.php"),r=e.undef(t.extraFileUploadParams,{}),s=e.undef(t.filePostName,"imgFile"),d=t.lang(a+".");t.plugin.fileDialog=function(c){var u=e.undef(c.fileUrl,"http://"),p=e.undef(c.fileTitle,""),m=c.clickFn,h=['<div style="padding:20px;">','<div class="ke-dialog-row">','<label for="keUrl" style="width:60px;">'+d.url+"</label>",'<input type="text" id="keUrl" name="url" class="ke-input-text" style="width:160px;" /> &nbsp;','<input type="button" class="ke-upload-button" value="'+d.upload+'" /> &nbsp;','<span class="ke-button-common ke-button-outer">','<input type="button" class="ke-button-common ke-button" name="viewServer" value="'+d.viewServer+'" />',"</span>","</div>",'<div class="ke-dialog-row">','<label for="keTitle" style="width:60px;">'+d.title+"</label>",'<input type="text" id="keTitle" class="ke-input-text" name="title" value="" style="width:160px;" /></div>',"</div>","</form>","</div>"].join(""),g=t.createDialog({name:a,width:450,title:t.lang(a),body:h,yesBtn:{name:t.lang("yes"),click:function(){var a=e.trim(v.val()),i=k.val();return"http://"==a||e.invalidUrl(a)?(alert(t.lang("invalidUrl")),v[0].focus(),void 0):(""===e.trim(i)&&(i=a),m.call(t,a,i),void 0)}}}),f=g.div,v=e('[name="url"]',f),b=e('[name="viewServer"]',f),k=e('[name="title"]',f);if(i){var y=e.uploadbutton({button:e(".ke-upload-button",f)[0],fieldName:s,url:e.addParam(o,"dir=file"),extraParams:r,afterUpload:function(i){if(g.hideLoading(),0===i.error){var n=i.url;l&&(n=e.formatUrl(n,"absolute")),v.val(n),t.afterUpload&&t.afterUpload.call(t,n,i,a),alert(t.lang("uploadSuccess"))}else alert(i.message)},afterError:function(e){g.hideLoading(),t.errorDialog(e)}});y.fileBox.change(function(){g.showLoading(t.lang("uploadLoading")),y.submit()})}else e(".ke-upload-button",f).hide();n?b.click(function(){t.loadPlugin("filemanager",function(){t.plugin.filemanagerDialog({viewType:"LIST",dirName:"file",clickFn:function(a){t.dialogs.length>1&&(e('[name="url"]',f).val(a),t.afterSelectFile&&t.afterSelectFile.call(t,a),t.hideDialog())}})})}):b.hide(),v.val(u),k.val(p),v[0].focus(),v[0].select()},t.clickToolbar(a,function(){t.plugin.fileDialog({clickFn:function(e,a){var i='<a class="ke-insertfile" href="'+e+'" data-ke-src="'+e+'" target="_blank">'+a+"</a>";t.insertHtml(i).hideDialog().focus()}})})});