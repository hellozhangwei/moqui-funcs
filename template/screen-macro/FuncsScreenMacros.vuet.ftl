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

<#--usage <dropzone id="testzone" url="createContent" paramName="contentFile" params="${groovy.json.JsonOutput.toJson([workEffortId:workEffortId])}"/>-->
<#macro dropzone>
  <#assign urlInstance = sri.makeUrlByType(.node["@url"], "transition", .node, "false")>

  <#assign params = ec.getResource().expand(.node["@params"], "")><#--params here is a string like [workEffortId:HM-004]-->

  <dropzone id="${.node["@id"]}" url="${urlInstance}" paramName="${.node["@paramName"]!"file"}" v-bind:params='${params}'/>
</#macro>
