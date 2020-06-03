
<style type="text/css">

html, body, #apps-root {font-family:"Helvetica Neue";font-size:12px;
    line-height:1.5;
    color:#515a6e;
    background: rgb(245, 247, 249);
    -webkit-font-smoothing:antialiased;
    -moz-osx-font-smoothing:grayscale;
    height: 100%; }

  #apps-root { padding-left: 0px; padding-right: 0px; }

  #top { height: auto; border:none; }
  #top .nav>li:not(:last-child)>a { border-right: 1px solid #ccc; border-color:#2e6da4 }

  @media (min-width: 768px) { #top .navbar { height: auto;}

  #app-bar-divider { position: relative; width: 100%; min-width: 1130px; height: 8px; background-color: #2e6da4; }

  body.dev #top nav {background: #2C3E50;}
  body.production #top nav { background: #222222;}

  .navbar { border: none; }

  .navbar-inverse .navbar-nav>li>a { text-align: center; font-weight: 400;padding-top: 10px; padding-bottom: 10px; width:133px;}
  .navbar-inverse .navbar-nav>li>a:hover, .navbar-inverse .navbar-nav>.active>a:hover { background-color: #3498DB; }
  .navbar-inverse .navbar-nav>.active>a, .navbar-inverse .navbar-nav>.active>a:focus { background-color: #2e6da4; }
  .navbar-nav>li>a>i { display:block; text-align:center; padding-bottom: 10px; }

  .navbar-nav>li>a>img { display: block; padding-bottom: 10px; margin-left: 50%; }

  /* Begin sub Menu section */
  #app-sub-navigation { #height: 48px; #border-bottom: solid 1px #000000; width: 100%; min-width: 1130px; }

  #app-sub-navigation ul { display: flex; flex-direction: row; background-color: #e6e6e6; flex-grow: 1; -webkit-padding-start: 0px; margin-bottom:0px; }

  #app-sub-navigation ul li { border-left: solid 1px #ced4da; #height: 25px; display: flex; align-items: center; justify-items: center; justify-content: center; min-width: auto; padding-left: 6px; padding-right: 6px; padding-top: 6px; padding-bottom: 6px; border-bottom: solid 1px #ced4da; font-size: 12px; }

  @media screen and (max-width: 1500px) { #app-sub-navigation ul li { font-size: 10px; min-width: auto; } }

  @media screen and (max-width: 1300px) { #app-sub-navigation ul li { font-size: 10px; min-width: 50px; } }

  #app-sub-navigation ul li a { display: flex; justify-content: center; align-items: center; text-align: center; height: 100%; width: 100%; text-decoration: none; color: rgba(0, 0, 0, 0.5); white-space: nowrap; }

  #app-sub-navigation ul li:last-child { border-right: solid 1px #ced4da; }

  #app-sub-navigation ul li:hover { background-color: #fff; min-height: 25px; position: relative; }

  #app-sub-navigation ul li:hover a { text-decoration: none; }

  #app-sub-navigation ul li.selected:hover a { color: #000000 !important; }

  #app-sub-navigation ul li.selected { background-color: rgb(245, 247, 249); position: relative; #height: 25px; border-bottom: none; }

  #app-sub-navigation ul li.selected :after { content: ''; position: absolute; top: -2px; left: calc(40%); width: 0; height: 0; border-right: 6px solid transparent; border-top: 6px solid #2e6da4; border-left: 6px solid transparent; }

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
    <#if hideNav! != 'true'>

    <div id="top">


      <nav class="navbar navbar-default navbar-static-top navbar-inverse" role="navigation">
        <div class="container-fluid">
          <div class="navbar-header">
            <#--<a href="/" class="navbar-brand"><img src="https://avatars1.githubusercontent.com/u/8334323?s=200&v=4" width="40"></a>-->
            <#assign headerLogoList = sri.getThemeValues("STRT_HEADER_LOGO")>
            <#if headerLogoList?has_content><m-link href="/apps" class="navbar-brand"><img src="${sri.buildUrl(headerLogoList?first).getUrl()}" alt="Home"></m-link></#if>
            <#assign headerTitleList = sri.getThemeValues("STRT_HEADER_TITLE")>
            <#if headerTitleList?has_content><div class="navbar-brand">${ec.resource.expand(headerTitleList?first, "")}</div></#if>
          </div>
          <#assign moreSize=7>
          <div id="navbar-menu" class="collapse navbar-collapse">
            <ul class="nav navbar-nav">
              <template v-if="navMenuList[1]">
                <li v-for="(subscreen, subscreenIndex) in navMenuList[1].subscreens" :class="{active:subscreen.active}">
                  <template v-if="(subscreenIndex+1)<=${moreSize}">
                    <m-link :href="subscreen.pathWithParams">
                      <i v-if="subscreen.imageType === 'icon'" :class="subscreen.image"></i>
                      <img v-else :src="subscreen.image" :alt="subscreen.title" width="15">
                      {{subscreen.title}}</m-link>
                  </template>
                </li>
              </template>
              <!--- The "More" dropdown menu item will be hidden on extra-small displays. --->

              <template v-if="navMenuList[1] && navMenuList[1].subscreens.length>${moreSize}">
              <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="glyphicon glyphicon-th-list"></i>更多 <b class="caret"></b></a>
                <ul class="dropdown-menu">
                  <li v-for="(subscreen, subscreenIndex) in navMenuList[1].subscreens" :class="{active:subscreen.active}">
                    <template v-if="(subscreenIndex+1)>${moreSize}">
                      <m-link :href="subscreen.pathWithParams"><i v-if="subscreen.imageType === 'icon'" :class="subscreen.image"></i>
                        <img v-else :src="subscreen.image" :alt="subscreen.title" width="15">
                        {{subscreen.title}}</m-link>
                    </template>
                  </li>

                  <li class="divider"></li>
                </ul>
              </li>
              </template>

              <template v-if="navMenuList[1] && navMenuList[1].subscreens.length>${moreSize}">
                <template v-for="(subscreen, subscreenIndex) in navMenuList[1].subscreens" :class="{active:subscreen.active}">
                  <template v-if="(subscreenIndex+1)>${moreSize} && subscreen.active">
                    <li class="active">
                      <m-link :href="subscreen.pathWithParams">
                        <i v-if="subscreen.imageType === 'icon'" :class="subscreen.image"></i>
                        <img v-else :src="subscreen.image" :alt="subscreen.title" width="15">{{subscreen.title}}</m-link>
                    </li>
                  </template>
                </template>
              </template>
            </ul>
            <ul class="nav navbar-nav navbar-right">
              <li><a href="${sri.buildUrl("/Login/logout").url}" data-toggle="tooltip" title="${ec.l10n.localize("Logout")} ${(ec.user.userAccount.userFullName)!ec.user.userAccount.username}"
                onclick="return confirm('${ec.l10n.localize("Logout")} ${(ec.user.userAccount.userFullName)!ec.user.userAccount.username}?')"  data-placement="bottom"><i class="glyphicon glyphicon-off"></i> 退出</a></li>
            </ul>
          </div>
        </div>
        <div id="app-bar-divider"></div>
        <template v-if="navMenuList[2]">
        <div id="app-sub-navigation">
          <ul>
              <li v-for="(subscreen, subscreenIndex) in navMenuList[2].subscreens" :class="{selected:subscreen.active}">
                <m-link :href="subscreen.pathWithParams"><!--<span :class="subscreen.image"></span>-->{{subscreen.title}}</m-link>
              </li>
          </ul>
        </div>
        </template>
      </nav>
    </div>
    </#if>

    <div id="content"><div class="inner"><div class="container-fluid">
        <subscreens-active></subscreens-active>
    </div></div></div>

    <#if hideNav! != 'true'>
    <div id="footer" class="bg-dark">
        <#assign footerItemList = sri.getThemeValues("STRT_FOOTER_ITEM")>
        <div id="apps-footer-content">
            <#list footerItemList! as footerItem>
                <#assign footerItemTemplate = footerItem?interpret>
                <@footerItemTemplate/>
            </#list>
        </div>
    </div>
    </#if>
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
