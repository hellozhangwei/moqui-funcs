<#--
This software is in the public domain under CC0 1.0 Universal plus a Grant of Patent License.

To the extent possible under law, the author(s) have dedicated all
copyright and related and neighboring rights to this software to the
public domain worldwide. This software is distributed without any
warranty.

You should have received a copy of the CC0 Public Domain Dedication
along with this software (see the LICENSE.md file). If not, see
<http://creativecommons.org/publicdomain/zero/1.0/>.
-->

<#include "runtime://template/screen-macro/DefaultScreenMacros.vuet.ftl"/>

<#macro ckeditor>
  <#assign name><@fieldName .node/></#assign>
  <#assign fieldValue = sri.getFieldValueString(.node)>
  <#assign urlInstance = sri.makeUrlByType(.node["@feedUrl"], "transition", .node, "true")>
  <ckeditor name="${name}" content="${fieldValue!?html}" id="<@fieldId .node/>" feedUrl="${urlInstance}"/>
</#macro>

<#--usage <dropzone id="testzone" url="createContent" paramName="contentFile" parameter-map="[workEffortId:workEffortId]"/>-->
<#macro dropzone>
  <#assign urlInstance = sri.makeUrlByType(.node["@url"], "transition", .node, "false")>
  <#assign parameterMap = urlInstance.getParameterMap()>
  <dropzone id="${.node["@id"]}" url="${urlInstance}" paramName="${.node["@paramName"]!"file"}" v-bind:params="{<#list parameterMap.keySet() as parameterKey>'${parameterKey}':'${parameterMap[parameterKey]}',</#list>}"/>
</#macro>

<#macro submit>
<#assign confirmationMessage = ec.getResource().expand(.node["@confirmation"]!, "")/>
<#assign buttonText><#if .node["@text"]?has_content>${ec.getResource().expand(.node["@text"], "")}<#else><@fieldTitle .node?parent/></#if></#assign>
<#assign iconClass = .node["@icon"]!>
<#if !iconClass?has_content><#assign iconClass = sri.getThemeIconClass(buttonText)!></#if>
<button type="submit" name="<@fieldName .node/>" value="<@fieldName .node/>" id="<@fieldId .node/>"<#if confirmationMessage?has_content> onclick="return confirm('${confirmationMessage?js_string}');"</#if><#if .node?parent["@tooltip"]?has_content> data-toggle="tooltip" title="${ec.getResource().expand(.node?parent["@tooltip"], "")}"</#if> class="btn btn-${.node["@btn-type"]!"primary"} btn-sm"<#if ownerForm?has_content> form="${ownerForm}"</#if>><#if iconClass?has_content><i class="${iconClass}"></i> </#if>
<#if .node["image"]?has_content><#assign imageNode = .node["image"][0]>
<img src="${sri.makeUrlByType(imageNode["@url"],imageNode["@url-type"]!"content",null,"true")}" alt="<#if imageNode["@alt"]?has_content>${imageNode["@alt"]}<#else><@fieldTitle .node?parent/></#if>"<#if imageNode["@width"]?has_content> width="${imageNode["@width"]}"</#if><#if imageNode["@height"]?has_content> height="${imageNode["@height"]}"</#if>>
<#else>
<#t>${buttonText}
</#if>
</button>
</#macro>
