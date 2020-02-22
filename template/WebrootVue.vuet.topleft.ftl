<style type="text/css">

#apps-root { padding-left: 0px; padding-right: 0px; }

.navbar-default .navbar-nav>li>a { color: #fff; }
.navbar-default .navbar-nav>li>a>.glyphicon {padding-right: 10px;}
.navbar-default .navbar-nav>.active>a {border-radius: 4px;background-color: #fff;padding: 6px 8px;margin: 4px 2px;}
.navbar-nav>li>a{padding: 6px 8px;margin: 4px 2px;}

/*#top, #content{ margin: 0 0 0 250px; }*/
.contentMargin{ margin: 0 0 0 220px; }

/*#nice-menu {height:51px;background:#337ab7}*/

.sidebar { z-index: 1; position: absolute; width: 220px;padding-top:50px;border-right: 1px solid #ddd;border-bottom: 1px solid #ddd;height:100%;}
.sidebar li a {padding: 12px 16px;}

.ttdiv {
    padding: 10px 15px;float: left;
}

#apps-root.tt-toggled .ttspan-fill {
    display: none;
}

#apps-root.tt-toggled .sidebar {
    width: 46px !important;
}

#apps-root.tt-toggled .sidebar sidebar-nav{
    width: 46px !important;
    background-color: red;
}

#apps-root.tt-toggled #content{
    margin-left: 46px;
}

#apps-root.tt-toggled .sidebar-brand{
    border-bottom: none;
}

.ttspan-right {
    #float: right;
    padding-bottom: 10px;
    cursor: pointer !important;
}

.nav>li.selected{
  background-color: #eee;
  box-shadow: inset 4px 0 0 #4b4ba3;
}

.nav>li.selected>a{
  margin-left: 4px;
}

.selected3{
  background: rgba(0,0,0,0.04);
}
</style>
<div id="apps-root"><#-- NOTE: webrootVue component attaches here, uses this and below for template -->
    <input type="hidden" id="confMoquiSessionToken" value="${ec.web.sessionToken}">
    <input type="hidden" id="confAppHost" value="${ec.web.getHostName(true)}">
    <input type="hidden" id="confAppRootPath" value="${ec.web.servletContext.contextPath}">
    <input type="hidden" id="confBasePath" value="${ec.web.servletContext.contextPath}/apps">
    <input type="hidden" id="confLinkBasePath" value="${ec.web.servletContext.contextPath}/funcs">
    <input type="hidden" id="confUserId" value="${ec.user.userId!''}">
    <input type="hidden" id="confLocale" value="${ec.user.locale.toLanguageTag()}">
    <#assign navbarCompList = sri.getThemeValues("STRT_HEADER_NAVBAR_COMP")>
    <#list navbarCompList! as navbarCompUrl><input type="hidden" class="confNavPluginUrl" value="${navbarCompUrl}"></#list>

    <!--left menu (second and third level menu)-->
    <template v-if="navMenuList[2] && navMenuList[2].subscreens && navMenuList[2].subscreens.length>0">
      <div class="navbar-default sidebar nav-left" role="navigation"><!--navbar-right:class="{navLeftWidth:navMenuList[2]}"-->
        <ul class="nav in" style="padding-left: 0px;"><!-- style="overflow-x: auto;overflow-y: auto;height:700px;"-->

          <li v-for="(subscreen2, subscreenIndex) in navMenuList[2].subscreens" :class="{selected:subscreen2.active}">
            <m-link :href="subscreen2.pathWithParams">
              <template v-if="subscreen2.image">
                <i v-if="subscreen2.imageType === 'icon'" :class="subscreen2.image" style="padding-right: 4px;"></i>
                <img v-else :src="subscreen2.image" :alt="subscreen2.title" width="18" style="padding-right: 4px;">
              </template>
              <i v-else class="glyphicon glyphicon-link" style="padding-right: 8px;"></i>
              <span class="ttspan-fill">{{subscreen2.title}}</span>
            </m-link>

            <!--start third level-->
            <template v-if="subscreen2.active && navMenuList[3] && !navMenuList[3].hasTabMenu">
              <ul class="nav in ttspan-fill" style="padding-left: 20px;">
                <li v-for="(subscreen3, subscreenIndex) in navMenuList[3].subscreens" :class="{selected3:subscreen3.active}">
                  <m-link :href="subscreen3.pathWithParams">
                    <template v-if="subscreen3.image">
                      <i v-if="subscreen3.imageType === 'icon'" :class="subscreen3.image" style="padding-right: 4px;"></i>
                      <img v-else :src="subscreen3.image" :alt="subscreen3.title" width="18" style="padding-right: 4px;">
                    </template>
                    <i v-else class="glyphicon glyphicon-link" style="padding-right: 8px;"></i>
                    {{subscreen3.title}}
                  </m-link>
                </li>
              </ul>
            </template>
            <!--end third level-->
          </li>
          <li >
            <a class="ttspan-right" onclick="$('#apps-root').toggleClass('tt-toggled')"><i class="fa fa-align-justify" style="padding-right: 8px;"></i><span class="ttspan-fill">Collapse sidebar</span></a>
          </li>
        </ul>

      </div>
     
    </template>
<#if hideNav! != 'true'>
  <div id="top">
    <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
      <div class="navbar-header">
        <#assign headerLogoList = sri.getThemeValues("STRT_HEADER_LOGO")>
        <#if headerLogoList?has_content><m-link href="/apps" class="navbar-brand"><img src="${sri.buildUrl(headerLogoList?first).getUrl()}" alt="Home"></m-link></#if>
        <#assign headerTitleList = sri.getThemeValues("STRT_HEADER_TITLE")>
        <#if headerTitleList?has_content>
          <div class="navbar-brand">${ec.resource.expand(headerTitleList?first, "")}</div>
        </#if>
      </div>

      <ul class="nav navbar-nav">
        <template v-if="navMenuList[1]">
          <li v-for="(subscreen, subscreenIndex) in navMenuList[1].subscreens" :class="{active:subscreen.active}">
            <template v-if="subscreenIndex<=6">
              <m-link :href="subscreen.pathWithParams">
                <i v-if="subscreen.imageType === 'icon'" :class="subscreen.image"></i>
                <img v-else :src="subscreen.image" :alt="subscreen.title" width="15">{{subscreen.title}}</m-link>
            </template>
          </li>
        </template>
        <!--- The "More" dropdown menu item will be hidden on extra-small displays. --->
        <template v-if="navMenuList[1] && navMenuList[1].subscreens && navMenuList[1].subscreens.length>6">
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="glyphicon glyphicon-th-list"></span>More <b class="caret"></b></a>
            <ul class="dropdown-menu">
              <li v-for="(subscreen, subscreenIndex) in navMenuList[1].subscreens" :class="{active:subscreen.active}">
                <template v-if="subscreenIndex>6">
                  <m-link :href="subscreen.pathWithParams"><i v-if="subscreen.imageType === 'icon'" :class="subscreen.image"></i>
                    <img v-else :src="subscreen.image" :alt="subscreen.title" width="15">
                    {{subscreen.title}}</m-link>
                </template>
              </li>
              <li class="divider"></li>
            </ul>
          </li>
        </template>

        <template v-if="navMenuList[1] && navMenuList[1].subscreens && navMenuList[1].subscreens.length>6">
          <template v-for="(subscreen, subscreenIndex) in navMenuList[1].subscreens" :class="{active:subscreen.active}">
            <template v-if="subscreenIndex>6 && subscreen.active">
              <li class="active">
                <m-link :href="subscreen.pathWithParams">
                  <i v-if="subscreen.imageType === 'icon'" :class="subscreen.image"></i>
                  <img v-else :src="subscreen.image" :alt="subscreen.title" width="15">{{subscreen.title}}</m-link>
              </li>
            </template>
          </template>
        </template>
      </ul>

      <div id="navbar-buttons" class="collapse navbar-collapse navbar-ex1-collapse">
      <#-- logout button -->
        <a href="${sri.buildUrl("/Login/logout").url}" data-toggle="tooltip" data-original-title="${ec.l10n.localize("Logout")} ${(ec.user.userAccount.userFullName)!''}" data-placement="bottom" class="btn btn-danger btn-sm navbar-btn navbar-right"><i class="glyphicon glyphicon-off"></i></a>
      <#-- screen history menu -->
      <#-- get initial history from server? <#assign screenHistoryList = ec.web.getScreenHistory()><#list screenHistoryList as screenHistory><#if (screenHistory_index >= 25)><#break></#if>{url:pathWithParams, name:title}</#list> -->
        <div id="history-menu" class="nav navbar-right dropdown">
          <a id="history-menu-link" href="#" class="dropdown-toggle btn btn-default btn-sm navbar-btn" data-toggle="dropdown" title="${ec.l10n.localize("History")}">
            <i class="glyphicon glyphicon-list"></i></a>
          <ul class="dropdown-menu">
            <li v-for="histItem in navHistoryList"><m-link :href="histItem.pathWithParams">
              <template v-if="histItem.image">
                <i v-if="histItem.imageType === 'icon'" :class="histItem.image" style="padding-right: 8px;"></i>
                <img v-else :src="histItem.image" :alt="histItem.title" width="18" style="padding-right: 4px;">
              </template>
              <i v-else class="glyphicon glyphicon-link" style="padding-right: 8px;"></i>
              {{histItem.title}}</m-link></li>
          </ul>
        </div>
        <#-- screen history previous screen -->
        <a href="#" @click.prevent="goPreviousScreen()" data-toggle="tooltip" data-original-title="${ec.l10n.localize("Previous Screen")}" data-placement="bottom" class="btn btn-default btn-sm navbar-btn navbar-right"><i class="glyphicon glyphicon-step-backward"></i></a>
        <#-- notify history -->
        <div id="notify-history-menu" class="nav navbar-right dropdown">
          <a id="notify-history-menu-link" href="#" class="dropdown-toggle btn btn-default btn-sm navbar-btn" data-toggle="dropdown" title="${ec.l10n.localize("Notifications")}">
            <i class="glyphicon glyphicon-exclamation-sign"></i></a>
          <ul class="dropdown-menu" @click.prevent="stopProp">
            <li v-for="histItem in notifyHistoryList">
            <#-- NOTE: don't use v-html for histItem.message, may contain input repeated back so need to encode for security (make sure scripts not run, etc) -->
              <div :class="'alert alert-' + histItem.type" @click.prevent="stopProp" role="alert"><strong>{{histItem.time}}</strong> <span>{{histItem.message}}</span></div>
            </li>
          </ul>
        </div>
        <#-- screen documentation/help -->
        <div v-if="navMenuList.length > 0 && navMenuList[navMenuList.length - 1].screenDocList.length" id="document-menu" class="nav navbar-right dropdown">
          <a id="document-menu-link" href="#" class="dropdown-toggle btn btn-info btn-sm navbar-btn" data-toggle="dropdown" title="Documentation">
            <i class="glyphicon glyphicon-question-sign"></i></a>
          <ul class="dropdown-menu">
            <li v-for="screenDoc in navMenuList[navMenuList.length - 1].screenDocList">
              <a href="#" @click.prevent="showScreenDocDialog(screenDoc.index)">{{screenDoc.title}}</a></li>
          </ul>
        </div>
        <#-- dark/light switch -->
        <a href="#" @click.prevent="switchDarkLight()" data-toggle="tooltip" data-original-title="${ec.l10n.localize ("Switch Dark/Light")}" data-placement="bottom" class="btn btn-default btn-sm navbar-btn navbar-right"><i class="glyphicon glyphicon-adjust"></i></a>

        <#-- QZ print options placeholder -->
        <component :is="qzVue" ref="qzVue"></component>

        <#-- nav plugins -->
        <template v-for="navPlugin in navPlugins"><component :is="navPlugin"></component></template>
        <#-- spinner, usually hidden -->
        <div class="navbar-right" style="padding:8px;" :class="{ hidden: loading < 1 }"><div class="spinner small"><div>Loading…</div></div></div>
      </div>

    </nav>
  </div>
</#if>
    <div id="content" :class="{contentMargin:(navMenuList[2] && navMenuList[2].subscreens && navMenuList[2].subscreens.length>0)}" ><div class="inner"><div class="container-fluid">
        <subscreens-active></subscreens-active>
    </div></div></div>

    <div id="footer" class="bg-dark">
        <#assign footerItemList = sri.getThemeValues("STRT_FOOTER_ITEM")>
        <div id="apps-footer-content">
            <#list footerItemList! as footerItem>
                <#assign footerItemTemplate = footerItem?interpret>
                <@footerItemTemplate/>
            </#list>
        </div>
    </div>

</div>

<div id="screen-document-dialog" class="modal dynamic-dialog" aria-hidden="true" style="display: none;" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">${ec.l10n.localize("Documentation")}</h4>
            </div>
            <div class="modal-body" id="screen-document-dialog-body">
                <div class="spinner"><div>Loading…</div></div>
            </div>
            <div class="modal-footer"><button type="button" class="btn btn-primary" data-dismiss="modal">${ec.l10n.localize("Close")}</button></div>
        </div>
    </div>
</div>
